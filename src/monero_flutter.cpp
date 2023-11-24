#include <memory>
#include "monero_flutter.h"
#include "wallet2.h"
#include "wallet/monero_wallet.h"
#include "wallet/monero_wallet_factory.h"
#include "wallet/monero_wallet_full.h"
#include "wallet/monero_wallet_model.h"
#include "daemon/monero_daemon_model.h"
#include "utils/monero_utils.h"

// TODO TEMP
#include <iostream>

using namespace std;
using namespace monero;

struct wallet_listener : public monero_wallet_listener {
    void on_sync_progress(uint64_t height, uint64_t start_height, uint64_t end_height, double percent_done, const string& message) override {
        cout << "height=" << height << "; start_height=" << start_height << "; end_height=" << end_height << "; percent_done=" << percent_done << "; " << message << endl;
    }
    void on_new_block(uint64_t height) override{}
    void on_balances_changed(uint64_t new_balance, uint64_t new_unlocked_balance) override {}
    void on_output_received(const monero_output_wallet& output) override {}
    void on_output_spent(const monero_output_wallet& output) override {}
};

namespace monero
{
struct wallet2_listener : public tools::i_wallet2_callback
{
public:
    wallet2_listener(monero_wallet_full& wallet, tools::wallet2& wallet2);
    ~wallet2_listener();
};

class monero_wallet_full2 : public monero_wallet_full
{
public:
    size_t get_num_subaddresses(uint32_t account_index) const
    {
        return m_w2->get_num_subaddresses(account_index);
    }
    
    vector<string> get_public_nodes() const
    {
        auto source = m_w2->get_public_nodes();
        
        std::vector<std::string> target;
        target.resize(source.size());

        std::transform(source.begin(), source.end(), target.begin(), [](const cryptonote::public_node& src_item) {
            return src_item.host + ":" + std::to_string(src_item.rpc_port);
        });

        return target;
    }
};

struct monero_wallet_factory2 : monero_wallet_factory
{
    monero_wallet_full* create_origin() override
    {
        return new monero_wallet_full2();
    }
};
}

#if __APPLE__
// Fix for randomx on ios
void __clear_cache(void* start, void* end) { }
#endif

#ifdef __cplusplus
extern "C"
{
#endif

static const std::vector<std::string> to_vector(const char* const* const array, uint32_t size)
{
    std::vector<std::string> result;
    
    for (uint32_t i = 0; i < size; i++)
    {
        std::string item = std::string(array[i]);
        result.push_back(item);
    }
    
    return result;
}

static const char* const* from_vector(const std::vector<std::string>& input)
{
    if (input.size() <= 0)
        return nullptr;

    // deallocate memory in the calling code!
    char** result = (char**)calloc(input.size() + 1, sizeof(char**));

    char** rp = result;

    for (auto const& s : input)
    {
        char* item = (char*)calloc(s.size() + 1, sizeof(char*));
        *rp++ = std::strcpy(item, s.c_str());
    }

    (*rp) = nullptr;

    return result;
}

// Work correctly with '\0' characters!
static const uint8_t* duplicate_bytes(const std::string& str)
{
    std::size_t length = str.length();
    
    // deallocate memory in the calling code!
    uint8_t* bytes = (uint8_t*)calloc(length, sizeof(uint8_t));
    std::memcpy(bytes, str.c_str(), length);
    
    return bytes;
}

static monero_wallet_full2* _wallet;
static wallet_listener* _listener;

static void set_wallet(monero_wallet_full2* wallet) {
    if (nullptr != _wallet) {
        delete _wallet;
        _wallet = nullptr;
    }
    
    _wallet = wallet;
}

// ************* Load/Save *************

bool is_wallet_exist(const char* path)
{
    bool wallet_exists = monero_wallet_full::wallet_exists(path);
    return wallet_exists;
}

bool is_wallet_loaded()
{
    return nullptr != _wallet;
}

void restore_wallet_from_seed(const char* path, const char* password, const char* seed, int32_t network_type, ErrorBox* error)
{
    auto config = make_shared<monero_wallet_config>();
    config->m_path = path;
    config->m_password = password;
    config->m_seed = seed;
    config->m_network_type = static_cast<monero_network_type>(network_type);
    
    auto wallet = (monero_wallet_full2*)monero_wallet_factory2().create_wallet(*config);
    set_wallet(wallet);
}

void open_wallet_data(const char* password, int32_t network_type, const uint8_t* keys_data, const int32_t keys_data_len, const uint8_t* cache_data, const int32_t cache_data_len, ErrorBox* error)
{
    auto wallet = (monero_wallet_full2*)monero_wallet_factory2().open_wallet_data(password,
                                                                                  static_cast<monero_network_type>(network_type),
                                                                                  std::string(reinterpret_cast<const char*>(keys_data), keys_data_len),
                                                                                  std::string(reinterpret_cast<const char*>(cache_data), cache_data_len));
    set_wallet(wallet);
}

void load_wallet(const char* path, const char* password, int32_t network_type, ErrorBox* error)
{
    auto wallet = (monero_wallet_full2*)monero_wallet_factory2().open_wallet(path, password, static_cast<monero_network_type>(network_type));
    set_wallet(wallet);
}

const ByteArray get_keys_data(const char* password, bool view_only, ErrorBox* error)
{
    ByteArray result;
    result.length = 0;
    result.bytes = nullptr;
    
    string buffer = _wallet->get_keys_file_buffer(password, view_only);
    result.length = (int32_t)buffer.length();
    result.bytes = duplicate_bytes(buffer);
    
    return result;
}

const ByteArray get_cache_data(ErrorBox* error)
{
    ByteArray result;
    result.length = 0;
    result.bytes = nullptr;
    
    string buffer = _wallet->get_cache_file_buffer();
    result.length = (int32_t)buffer.length();
    result.bytes = duplicate_bytes(buffer);
    
    return result;
}

void store(ErrorBox* error)
{
    _wallet->save();
}

void close_current_wallet(ErrorBox* error)
{
    _wallet->close();
    set_wallet(nullptr);
}

// ************* Multisig *************

const char* prepare_multisig(ErrorBox* error)
{
    std::string result = _wallet->prepare_multisig();
    return strdup(result.c_str());
}

const char* make_multisig(const char* const* const info, uint32_t size, uint32_t threshold, const char* password, ErrorBox* error)
{
    auto info_vector = to_vector(info, size);
    auto result = _wallet->make_multisig(info_vector, threshold, password);
    
    if (result.empty())
        return nullptr;
    
    return strdup(result.c_str());
}

const char* exchange_multisig_keys(const char* const* const info, uint32_t size, const char* password, ErrorBox* error)
{
    auto info_vector = to_vector(info, size);
    auto init_result = _wallet->exchange_multisig_keys(info_vector, password);
    auto multisig_hex = init_result.m_multisig_hex;
    
    return strdup(multisig_hex->c_str());
}

bool is_multisig_import_needed(ErrorBox* error)
{
    return _wallet->is_multisig_import_needed();
}

void export_multisig_images(const char** info, ErrorBox* error)
{
    string multisig_hex = _wallet->export_multisig_hex();
    
    if (!multisig_hex.empty())
        (*info) = strdup(multisig_hex.c_str());
}

uint32_t import_multisig_images(const char* const* const info, uint32_t size, ErrorBox* error)
{
    auto multisig_hexes = to_vector(info, size);
    auto result = _wallet->import_multisig_hex(multisig_hexes);
    return result;
}

// ************* Sync *************

void setup_node(const char* address, const char* login, const char* password, ErrorBox* error)
{
    bool is_connected = _wallet->is_connected_to_daemon();
    cout << "is_connected_to_daemon=" << is_connected << endl;
    
    _wallet->set_daemon_connection(address, login, password);
    
    is_connected = _wallet->is_connected_to_daemon();
    cout << "is_connected_to_daemon=" << is_connected << endl;
}

void start_refresh(ErrorBox* error)
{
    // TODO make listener global value
    _listener = new wallet_listener();
    _wallet->add_listener(*_listener);
    
    _wallet->sync();
}

uint64_t get_syncing_height(ErrorBox* error)
{
    auto restore_height = _wallet->get_restore_height();
    auto daemon_height = _wallet->get_daemon_height();
    auto height = _wallet->get_height();
    
    cout << "restore_height=" << restore_height << "; daemon_height" << daemon_height << "; height=" << height << endl;
    
    return 1;
}

uint64_t get_current_height(ErrorBox* error)
{
    return 0;
}

uint64_t get_node_height_or_update(uint64_t base_eight)
{
    return 0;
}

const char* const* get_public_nodes()
{
    std::vector<std::string> nodes = _wallet->get_public_nodes();
    return from_vector(nodes);
}

uint64_t get_single_block_tx_count(const std::string& address, uint64_t block_height)
{
    auto http_client_factory = std::unique_ptr<epee::net_utils::http::http_client_factory>(new net::http::client_factory());
    auto http_client(http_client_factory->create());
    
    boost::optional<epee::net_utils::http::login> login{};
    login.emplace("", "");
    
    auto ssl = address.rfind("https", 0) == 0 ?
    epee::net_utils::ssl_support_t::e_ssl_support_enabled :
    epee::net_utils::ssl_support_t::e_ssl_support_disabled;
    
    http_client->set_server(address, login, ssl);
    std::chrono::seconds timeout = std::chrono::minutes(3);
    
    cryptonote::COMMAND_RPC_GET_BLOCKS_BY_HEIGHT::request req;
    cryptonote::COMMAND_RPC_GET_BLOCKS_BY_HEIGHT::response res;
    
    req.heights = {block_height};
    
    bool r = epee::net_utils::invoke_http_bin("/getblocks_by_height.bin", req, res, *http_client, timeout);
    
    if (res.status != CORE_RPC_STATUS_OK)
        throw std::runtime_error(res.status);
    
    if (!r || 1 != res.blocks.size())
        return -1;
    
    return res.blocks[0].txs.size();
}

// ************* Financial *************

const char* get_address(ErrorBox* error)
{
    auto address = _wallet->get_address(0, 0);
    return strdup(address.c_str());
}

const char* get_receive_address(ErrorBox* error)
{
    uint32_t num_subaddresses = (uint32_t)_wallet->get_num_subaddresses(0);
    auto address = _wallet->get_address(0, num_subaddresses);
    return strdup(address.c_str());
}

uint64_t get_confirmed_balance(ErrorBox* error)
{
    return _wallet->get_unlocked_balance();
}

const char* get_all_transactions_json(ErrorBox* error)
{
    auto txs = _wallet->get_txs();
    
    auto blocks = monero_utils::get_blocks_from_txs(txs);
    
    rapidjson::Document doc;
    doc.SetObject();
    doc.AddMember("blocks", monero_utils::to_rapidjson_val(doc.GetAllocator(), blocks), doc.GetAllocator());
    
    auto blocks_json = monero_utils::serialize(doc);
    
    monero_utils::free(blocks);
    
    return strdup(blocks_json.c_str());
}

const char* get_utxos_json(ErrorBox* error)
{
    auto tx_query = make_shared<monero_tx_query>();
    tx_query->m_is_locked = false;
    tx_query->m_is_confirmed = true;
    
    auto output_query = make_shared<monero_output_query>();
    output_query->m_is_spent = false;
    output_query->m_tx_query = tx_query;
    
    // get utxos
    auto outputs = _wallet->get_outputs(*output_query);
    
    vector<shared_ptr<monero_block>> blocks = monero_utils::get_blocks_from_outputs(outputs);
    
    rapidjson::Document doc;
    doc.SetObject();
    doc.AddMember("blocks", monero_utils::to_rapidjson_val(doc.GetAllocator(), blocks), doc.GetAllocator());
    
    auto blocks_json = monero_utils::serialize(doc);
    
    // free memory
    monero_utils::free(blocks);
    monero_utils::free(output_query->m_tx_query.get());
    
    return strdup(blocks_json.c_str());
}

void thaw(const char* key_image, ErrorBox* error)
{
    _wallet->thaw_output(key_image);
}

void freeze(const char* key_image, ErrorBox* error)
{
    _wallet->freeze_output(key_image);
}

const char* create_transaction(const char* tx_config_json, ErrorBox* error)
{
    auto tx_config = monero_tx_config::deserialize(tx_config_json);
    auto txs = _wallet->create_txs(*tx_config);
    
    if (txs.size() != 1) {
        // TODO
    }
    
    auto result = txs[0]->m_tx_set.get()->serialize();
    
    return strdup(result.c_str());
}

const char* describe_tx_set(const char* tx_set_json, ErrorBox* error)
{
    auto tx_set = monero_tx_set::deserialize(tx_set_json);
    auto result = _wallet->describe_tx_set(tx_set);
    string result_json = result.serialize();
    
    return strdup(result_json.c_str());
}

#ifdef __cplusplus
}
#endif

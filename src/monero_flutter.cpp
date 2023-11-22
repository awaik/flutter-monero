#include <memory>
#include "monero_flutter.h"
#include "wallet/monero_wallet_full.h"
#include "wallet/monero_wallet_model.h"
#include "daemon/monero_daemon_model.h"

using namespace std;
using namespace monero;

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

// Work correctly with '\0' characters!
static const uint8_t* duplicate_bytes(const std::string& str)
{
    std::size_t length = str.length();
    
    // deallocate memory in the calling code!
    uint8_t* bytes = (uint8_t*)calloc(length, sizeof(uint8_t));
    std::memcpy(bytes, str.c_str(), length);
    
    return bytes;
}

static monero_wallet_full* _wallet;

static void set_wallet(monero_wallet_full* wallet) {
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
    
    auto wallet = monero_wallet_full::create_wallet(*config);
    set_wallet(wallet);
}

void open_wallet_data(const char *password, int32_t network_type, const uint8_t *keys_data, const int32_t keys_data_len, const uint8_t *cache_data, const int32_t cache_data_len, ErrorBox* error)
{
    auto wallet = monero_wallet_full::open_wallet_data(password,
                                                       static_cast<monero_network_type>(network_type),
                                                       std::string(reinterpret_cast<const char*>(keys_data), keys_data_len),
                                                       std::string(reinterpret_cast<const char*>(cache_data), cache_data_len));
    set_wallet(wallet);
}

void load_wallet(const char* path, const char* password, int32_t network_type, ErrorBox* error)
{
    auto wallet = monero_wallet_full::open_wallet(path, password, static_cast<monero_network_type>(network_type));
    set_wallet(wallet);
}

const ByteArray get_keys_data(const char *password, bool view_only, ErrorBox* error)
{
    ByteArray result;
    result.length = 0;
    result.bytes = nullptr;
    
    string buffer = _wallet->get_keys_file_buffer(password, view_only);
    result.length = (int32_t)buffer.length();
    result.bytes = duplicate_bytes(buffer);
}

const ByteArray get_cache_data(ErrorBox* error)
{
    ByteArray result;
    result.length = 0;
    result.bytes = nullptr;
    
    string buffer = _wallet->get_cache_file_buffer();
    result.length = (int32_t)buffer.length();
    result.bytes = duplicate_bytes(buffer);
}

// ************* Multisig *************

const char* prepare_multisig(ErrorBox* error)
{
    std::string result = _wallet->prepare_multisig();
    return strdup(result.c_str());
}

const char* make_multisig(const char* const* const info, uint32_t size, uint32_t threshold, const char *password, ErrorBox* error)
{
    auto info_vector = to_vector(info, size);
    auto result = _wallet->make_multisig(info_vector, threshold, password);
    
    if (result.empty())
        return nullptr;
    
    return strdup(result.c_str());
}

const char* exchange_multisig_keys(const char* const* const info, uint32_t size, const char *password, ErrorBox* error)
{
    //auto info_vector = to_vector(info, size);
    
    //auto init_result = _wallet->exchange_multisig_keys(info_vector, password);
    
    //auto multisig_hex = init_result->m_multisig_hex;
    
    //return strdup(multisig_hex.c_str());
    
    return nullptr;
}

bool is_multisig_import_needed(ErrorBox* error)
{
    return false;
    //return _wallet->is_multisig_import_needed();
}

void export_multisig_images(const char** info, ErrorBox* error)
{
    
    //std::string images;
    
    //bool is_success = _wallet->export_key_images(images);
    
    //if (is_success)
    //    (*info) = strdup(images.c_str());
}

uint32_t import_multisig_images(const char* const* const info, uint32_t size, ErrorBox* error)
{
    //auto info_vector = to_vector(info, size);
    
    //uint32_t result = (uint32_t)_wallet->import_key_images(info_vector);
    
    //return result;
    
    return 1;
}

void setup_node(const char* address, const char* login, const char* password, bool use_ssl, bool is_light_wallet, ErrorBox* error)
{
    
}

void start_refresh(ErrorBox* error)
{
    
}

uint64_t get_syncing_height(ErrorBox* error)
{
    return 0;
}

uint64_t get_current_height(ErrorBox* error)
{
    return 0;
}

uint64_t get_node_height_or_update(uint64_t base_eight)
{
    return 0;
}

// ************* Financial *************

const char* get_address(uint32_t account_index, uint32_t address_index, ErrorBox* error)
{
    return nullptr;
}

int32_t get_num_subaddresses(int32_t account_index, ErrorBox *error)
{
    return 0;
}

const char *get_outputs(const char *output_query_json, ErrorBox *error)
{
    return nullptr;
}

void thaw(const char* key_image, ErrorBox* error)
{
    _wallet->thaw_output(key_image);
}

void freeze(const char* key_image, ErrorBox* error)
{
    _wallet->freeze_output(key_image);
}

const char *create_transactions(const char *tx_config_json, ErrorBox *error)
{
    return nullptr;
}

const char *describe_tx_set(const char *tx_set_json, ErrorBox *error)
{
    return nullptr;
}

#ifdef __cplusplus
}
#endif

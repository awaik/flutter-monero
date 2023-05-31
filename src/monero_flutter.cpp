#include "cstdlib"
#include <functional>
#if defined(_WIN64)
#else
#include <unistd.h>
#endif
#include <mutex>
#include "monero_flutter.h"
#if __APPLE__
// Fix for randomx on ios
void __clear_cache(void* start, void* end) { }
#endif
#include "wallet2_api.h"

#ifdef __cplusplus
extern "C"
{
#endif

    const uint64_t MONERO_BLOCK_SIZE = 1000;

    struct SubaddressRow
    {
        uint64_t id;
        char* address;
        char* label;

        SubaddressRow(std::size_t _id, char* _address, char* _label)
        {
            id = static_cast<uint64_t>(_id);
            address = _address;
            label = _label;
        }
    };

    struct AccountRow
    {
        uint64_t id;
        char* label;

        AccountRow(std::size_t _id, char* _label)
        {
            id = static_cast<uint64_t>(_id);
            label = _label;
        }
    };

    struct MoneroWalletListener : Monero::WalletListener
    {
        uint64_t m_height;
        bool m_need_to_refresh;
        bool m_new_transaction;

        MoneroWalletListener()
        {
            m_height = 0;
            m_need_to_refresh = false;
            m_new_transaction = false;
        }

        void moneySpent(const std::string& txId, uint64_t amount) override
        {
            m_new_transaction = true;
        }

        void moneyReceived(const std::string& txId, uint64_t amount) override
        {
            m_new_transaction = true;
        }

        void unconfirmedMoneyReceived(const std::string& txId, uint64_t amount) override
        {
            m_new_transaction = true;
        }

        void newBlock(uint64_t height) override
        {
            m_height = height;
        }

        void updated() override
        {
            m_new_transaction = true;
        }

        void refreshed() override
        {
            m_need_to_refresh = true;
        }

        void resetNeedToRefresh()
        {
            m_need_to_refresh = false;
        }

        bool isNeedToRefresh()
        {
            return m_need_to_refresh;
        }

        bool isNewTransactionExist()
        {
            return m_new_transaction;
        }

        void resetIsNewTransactionExist()
        {
            m_new_transaction = false;
        }

        uint64_t height()
        {
            return m_height;
        }
    };

    struct TransactionInfoRow
    {
        uint64_t amount;
        uint64_t fee;
        uint64_t blockHeight;
        uint64_t confirmations;
        uint32_t subaddrAccount;
        int8_t direction;
        int8_t isPending;
        uint32_t subaddrIndex;

        char* hash;
        char* paymentId;

        int64_t datetime;

        TransactionInfoRow(Monero::TransactionInfo* transaction)
        {
            amount = transaction->amount();
            fee = transaction->fee();
            blockHeight = transaction->blockHeight();
            subaddrAccount = transaction->subaddrAccount();
            std::set<uint32_t>::iterator it = transaction->subaddrIndex().begin();
            subaddrIndex = *it;
            confirmations = transaction->confirmations();
            datetime = static_cast<int64_t>(transaction->timestamp());
            direction = transaction->direction();
            isPending = static_cast<int8_t>(transaction->isPending());
            std::string hash_str(transaction->hash());
            hash = strdup(hash_str.c_str());
            paymentId = strdup(transaction->paymentId().c_str());
        }
    };

    struct PendingTransactionRaw
    {
        uint64_t amount;
        uint64_t fee;
        char* hash;
        char* hex;
        char* txKey;
        Monero::PendingTransaction* transaction;

        PendingTransactionRaw(Monero::PendingTransaction* _transaction)
        {
            transaction = _transaction;
            amount = _transaction->amount();
            fee = _transaction->fee();
            hash = strdup(_transaction->txid()[0].c_str());
            hex = strdup(_transaction->hex()[0].c_str());
            txKey = strdup(_transaction->txKey()[0].c_str());
        }
    };

    Monero::Wallet* m_wallet;
    Monero::TransactionHistory* m_transaction_history;
    MoneroWalletListener* m_listener;
    Monero::Subaddress* m_subaddress;
    Monero::SubaddressAccount* m_account;
    uint64_t m_last_known_wallet_height;
    uint64_t m_cached_syncing_blockchain_height = 0;
    std::mutex store_lock;
    bool is_storing = false;

    // **********************************************************************************************************************************
    // Wallet manager
    // **********************************************************************************************************************************

    void change_current_wallet(Monero::Wallet* wallet)
    {
        m_wallet = wallet;
        m_listener = nullptr;

        if (wallet != nullptr)
            m_transaction_history = wallet->history();
        else
            m_transaction_history = nullptr;

        if (wallet != nullptr)
            m_account = wallet->subaddressAccount();
        else
            m_account = nullptr;

        if (wallet != nullptr)
            m_subaddress = wallet->subaddress();
        else
            m_subaddress = nullptr;
    }

    // Creating (loading) wallet

    static bool is_wallet_created(ErrorBox* error)
    {
        const char* const message = "Wallet not found!";

        if (nullptr == m_wallet)
        {
            error->code = -1;
            error->message = strdup(message);

            return false;
        }

        return true;
    }

    static bool is_account_loaded(ErrorBox* error)
    {
        const char* const message = "Account not loaded!";

        if (nullptr == m_account)
        {
            error->code = -1;
            error->message = strdup(message);

            return false;
        }

        return true;
    }

    static bool is_subaddress_loaded(ErrorBox* error)
    {
        const char* const message = "Subaddress not loaded!";

        if (nullptr == m_subaddress)
        {
            error->code = -1;
            error->message = strdup(message);

            return false;
        }

        return true;
    }

    static bool is_history_loaded(ErrorBox* error)
    {
        const char* const message = "History not loaded!";

        if (nullptr == m_transaction_history)
        {
            error->code = -1;
            error->message = strdup(message);

            return false;
        }

        return true;
    }

    static bool is_listener_setted(ErrorBox* error)
    {
        const char* const message = "Listener not setted!";

        if (nullptr == m_listener)
        {
            error->code = -1;
            error->message = strdup(message);

            return false;
        }

        return true;
    }

    static void extract_wallet_error(const Monero::Wallet* wallet, ErrorBox* error)
    {
        int status;
        std::string errorString;

        wallet->statusWithErrorString(status, errorString);

        if (wallet->status() != Monero::Wallet::Status_Ok)
        {
            error->code = -100;
            error->message = strdup(errorString.c_str());
        }
    }

    void create_wallet(const char* path, const char* password, const char* language, int32_t network_type, ErrorBox* error)
    {
        Monero::Wallet* wallet;

        try
        {
            wallet = Monero::WalletManagerFactory::getWalletManager()->createWallet(
                path,
                password,
                language,
                static_cast<Monero::NetworkType>(network_type));
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        extract_wallet_error(wallet, error);

        if (0 == error->code)
            change_current_wallet(wallet);
    }

    void restore_wallet_from_seed(const char* path, const char* password, const char* seed, int32_t network_type, uint64_t restoreHeight, ErrorBox* error)
    {
        Monero::Wallet* wallet;

        try
        {
            wallet = Monero::WalletManagerFactory::getWalletManager()->recoveryWallet(
                std::string(path),
                std::string(password),
                std::string(seed),
                static_cast<Monero::NetworkType>(network_type),
                restoreHeight);
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        extract_wallet_error(wallet, error);

        if (0 == error->code)
            change_current_wallet(wallet);
    }

    void restore_wallet_from_keys(const char* path, const char* password, const char* language, const char* address, const char* view_key, const char* spend_key, int32_t network_type, uint64_t restore_height, ErrorBox* error)
    {
        Monero::Wallet* wallet;

        try
        {
            wallet = Monero::WalletManagerFactory::getWalletManager()->createWalletFromKeys(
                std::string(path),
                std::string(password),
                std::string(language),
                static_cast<Monero::NetworkType>(network_type),
                restore_height,
                std::string(address),
                std::string(view_key),
                std::string(spend_key));
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        extract_wallet_error(wallet, error);

        if (0 == error->code)
            change_current_wallet(wallet);
    }

    bool is_wallet_exist(const char* path)
    {
        return Monero::WalletManagerFactory::getWalletManager()->walletExists(std::string(path));
    }

    void load_wallet(const char* path, const char* password, int32_t net_type, ErrorBox* error)
    {
#if defined(_POSIX_VERSION)
        nice(19);
#endif
        Monero::Wallet* wallet;

        try
        {
            wallet = Monero::WalletManagerFactory::getWalletManager()->openWallet(
                std::string(path),
                std::string(password),
                net_type);
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        extract_wallet_error(wallet, error);

        if (0 == error->code)
            change_current_wallet(wallet);
    }

    void open_wallet_data_hex(const char *password,
                                  bool testnet,
                                  const char *keys_data_hex,
                                  const char *cache_data_hex,
                                  const char *daemon_address,
                                  const char *daemon_username,
                                  const char *daemon_password,
                                  ErrorBox* error)
    {
        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        Monero::Wallet* wallet;

        try
        {
            wallet = Monero::WalletManagerFactory::getWalletManager()->open_wallet_data_hex(std::string(password),
                                testnet,
                                std::string(keys_data_hex),
                                std::string(cache_data_hex),
                                std::string(daemon_address),
                                std::string(daemon_username),
                                std::string(daemon_password));
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        extract_wallet_error(wallet, error);

        if (0 == error->code)
            change_current_wallet(wallet);
    }

    void open_wallet_data(const char *password,
                                bool testnet,
                                const uint8_t *keys_data,
                                const int32_t keys_data_len,
                                const uint8_t *cache_data,
                                const int32_t cache_data_len,
                                const char *daemon_address,
                                const char *daemon_username,
                                const char *daemon_password,
                                ErrorBox* error)
    {
        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        Monero::Wallet* wallet;

        try
        {
            wallet = Monero::WalletManagerFactory::getWalletManager()->open_wallet_data(std::string(password),
                                testnet,
                                std::string(reinterpret_cast<const char*>(keys_data), keys_data_len),
                                std::string(reinterpret_cast<const char*>(cache_data), cache_data_len),
                                std::string(daemon_address),
                                std::string(daemon_username),
                                std::string(daemon_password));
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        extract_wallet_error(wallet, error);

        if (0 == error->code)
            change_current_wallet(wallet);
    }

    void close_current_wallet(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        bool is_success = false;

        try
        {
            is_success = Monero::WalletManagerFactory::getWalletManager()->closeWallet(wallet);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_success)
        {
            if (nullptr != wallet)
            {
                extract_wallet_error(wallet, error);
                return;
            }

            const char* const errorMessage = "Unknown error!";

            error->code = -3;
            error->message = strdup(errorMessage);
        }

        change_current_wallet(nullptr);
    }

    // Get info

    const char* secret_view_key(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            result = strdup(m_wallet->secretViewKey().c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char* public_view_key(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            result = strdup(m_wallet->publicViewKey().c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char* secret_spend_key(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            result = strdup(m_wallet->secretSpendKey().c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char* public_spend_key(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            result = strdup(m_wallet->publicSpendKey().c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char* seed(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            result = strdup(m_wallet->seed().c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char* get_filename(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            result = strdup(m_wallet->filename().c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    // Change

    void set_password(const char* password, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        bool is_changed;

        try
        {
            is_changed = wallet->setPassword(std::string(password));
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_changed)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());
        }
    }

    // Save

    void store(const char* path, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        if (is_storing)
            return;

        store_lock.lock();

        is_storing = true;

        bool is_success = false;

        try
        {
            is_success = m_wallet->store(std::string(path));
        }
        catch (std::exception& e)
        {
            is_success = false;
            error->code = -2;
            error->message = strdup(e.what());
        }

        if (0 == error->code && !is_success)
        {
            const char* const unknown_error_message = "Unknown error!";

            auto error_message = m_wallet->errorString();
            const char* error_message_value;

            error_message_value = error_message.empty() ? unknown_error_message : error_message.c_str();

            error->code = -3;
            error->message = strdup(error_message_value);
        }

        is_storing = false;
        store_lock.unlock();
    }

    // Unknown use case!
    void set_recovering_from_seed(bool is_recovery, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        m_wallet->setRecoveringFromSeed(is_recovery);
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

    const ByteArray getByteArray(const uint8_t *keys_data, const int32_t keys_data_len)
    {
        std::string data_buf = std::string(reinterpret_cast<const char*>(keys_data), keys_data_len);

        ByteArray result;
        result.length = (uint32_t)data_buf.length();
        result.bytes = duplicate_bytes(data_buf);

        return result;
    }

    const char *get_keys_data_hex(const char *password, bool view_only, ErrorBox* error)
    {
        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        if (!is_wallet_created(error))
            return nullptr;

        const char* buffer = nullptr;

        try
        {
            buffer = strdup(m_wallet->get_keys_data_hex(std::string(password), view_only).c_str());
        }
        catch (std::exception& e)
        {
            error->message = strdup(e.what());
        }

        return buffer;
    }

    const ByteArray get_keys_data(const char *password, bool view_only, ErrorBox* error)
    {
        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        ByteArray result;
        result.length = 0;
        result.bytes = nullptr;

        if (!is_wallet_created(error))
            return result;

        try
        {
            std::string data_buf = m_wallet->get_keys_data_buf(std::string(password), view_only);
            result.length = (int32_t)data_buf.length();
            result.bytes = duplicate_bytes(data_buf);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char *get_cache_data_hex(const char *password, ErrorBox* error)
    {
        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        if (!is_wallet_created(error))
            return nullptr;

        const char* buffer = nullptr;

        try
        {
            buffer = strdup(m_wallet->get_cache_data_hex(std::string(password)).c_str());
        }
        catch (std::exception& e)
        {
            error->message = strdup(e.what());
        }

        return buffer;
    }

    const ByteArray get_cache_data(const char *password, ErrorBox* error)
    {
        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        ByteArray result;
        result.length = 0;
        result.bytes = nullptr;

        if (!is_wallet_created(error))
            return result;

        try
        {
            std::string data_buf = m_wallet->get_cache_data_buf(std::string(password));
            result.length = (int32_t)data_buf.length();
            result.bytes = duplicate_bytes(data_buf);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    // **********************************************************************************************************************************
    // Synchronization
    // **********************************************************************************************************************************

    void on_startup(ErrorBox* error)
    {
        try
        {
            Monero::Utils::onStartup();
            Monero::WalletManagerFactory::setLogLevel(0);
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());
        }
    }

    void setup_node(const char* address, const char* login, const char* password, bool use_ssl, bool is_light_wallet, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        #if defined(_POSIX_VERSION)
        nice(19);
        #endif

        Monero::Wallet* wallet = m_wallet;

        std::string login_value = "";
        std::string password_value = "";

        if (login != nullptr)
            login_value = std::string(login);

        if (password != nullptr)
            password_value = std::string(password);

        bool is_initialized = false;

        try
        {
            is_initialized = wallet->init(std::string(address), 0, login_value, password_value, use_ssl, is_light_wallet);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_initialized)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());

            return;
        }

        bool is_success = false;

        try
        {
            is_success = wallet->connectToDaemon();
        }
        catch (std::exception& e)
        {
            error->code = -4;
            error->message = strdup(e.what());

            return;
        }

        if (!is_success)
        {
            error->code = -5;
            error->message = strdup(wallet->errorString().c_str());

            return;
        }
    }

    void set_listener(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        m_last_known_wallet_height = 0;

        if (m_listener != nullptr)
            delete m_listener;

        m_listener = new MoneroWalletListener();

        m_wallet->setListener(m_listener);
    }

    void connect_to_node(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        #if defined(_POSIX_VERSION)
                nice(19);
        #endif

        bool is_success = false;

        try
        {
            is_success = wallet->connectToDaemon();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_success)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());
        }
    }

    bool is_connected(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return false;

        bool is_connected = false;

        try
        {
            is_connected = m_wallet->connected();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return is_connected;
    }

    bool is_needed_to_refresh(ErrorBox* error)
    {
        if (!is_listener_setted(error))
            return false;

        bool should_refresh = m_listener->isNeedToRefresh();

        if (should_refresh)
            m_listener->resetNeedToRefresh();

        return should_refresh;
    }

    void start_refresh(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        try
        {
            wallet->refreshAsync();
            wallet->startRefresh();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void pause_refresh(ErrorBox *error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        try
        {
            wallet->pauseRefresh();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void set_refresh_from_block_height(uint64_t height, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        try
        {
            m_wallet->setRefreshFromBlockHeight(height);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void rescan_blockchain(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        try
        {
            m_wallet->rescanBlockchainAsync();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void set_trusted_daemon(bool arg, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        try
        {
            m_wallet->setTrustedDaemon(arg);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    bool trusted_daemon(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return false;

        bool result = false;

        try
        {
            result = m_wallet->trustedDaemon();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    uint64_t get_node_height(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return 0;

        uint64_t result = 0;

        try
        {
            result = m_wallet->daemonBlockChainHeight();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    bool is_new_transaction_exist(ErrorBox* error)
    {
        if (!is_listener_setted(error))
            return false;

        bool is_new_transaction_exist = m_listener->isNewTransactionExist();

        if (is_new_transaction_exist)
            m_listener->resetIsNewTransactionExist();

        return is_new_transaction_exist;
    }

    uint64_t get_syncing_height(ErrorBox* error)
    {
        if (!is_listener_setted(error))
            return 0;

        uint64_t height = m_listener->height();

        if (height <= 1)
            return 0;

        if (height != m_last_known_wallet_height)
            m_last_known_wallet_height = height;

        return height;
    }

    uint64_t get_current_height(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return 0;

        uint64_t result = 0;

        try
        {
            result = m_wallet->blockChainHeight();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    uint64_t get_node_height_or_update(uint64_t base_eight)
    {
        if (m_cached_syncing_blockchain_height < base_eight)
            m_cached_syncing_blockchain_height = base_eight;

        return m_cached_syncing_blockchain_height;
    }

    void rescan_spent(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        bool is_success;

        try
        {
            is_success = wallet->rescanSpent();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_success)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());
        }
    }

    // **********************************************************************************************************************************
    // Account
    // **********************************************************************************************************************************

    int64_t* account_get_all(ErrorBox* error)
    {
        if (!is_account_loaded(error))
            return nullptr;

        std::vector<Monero::SubaddressAccountRow*> accounts = m_account->getAll();
        size_t size = accounts.size();

        int64_t* account_handles = new int64_t[size];

        for (int i = 0; i < size; i++)
        {
            Monero::SubaddressAccountRow* row = accounts[i];
            AccountRow* accountRow = new AccountRow(row->getRowId(), strdup(row->getLabel().c_str()));
            account_handles[i] = reinterpret_cast<int64_t>(accountRow);
        }

        return account_handles;
    }

    int32_t account_size(ErrorBox* error)
    {
        if (!is_account_loaded(error))
            return 0;

        auto accounts = m_account->getAll();
        return (uint32_t)accounts.size();
    }

    void free_block_of_accounts(int64_t* handles, int32_t size)
    {
        int64_t* p = handles;

        while (size-- > 0)
        {
            int64_t handle = *(handles++);
            auto item = reinterpret_cast<AccountRow*>(handle);

            delete item;
        }

        delete[] p;
    }

    int64_t* subaddress_get_all(ErrorBox* error)
    {
        if (!is_subaddress_loaded(error))
            return nullptr;

        std::vector<Monero::SubaddressRow*> subaddresses = m_subaddress->getAll();
        size_t size = subaddresses.size();

        int64_t* subaddressesValue = new int64_t[size];

        for (int i = 0; i < size; i++)
        {
            Monero::SubaddressRow* row = subaddresses[i];
            SubaddressRow* localRow = new SubaddressRow(row->getRowId(), strdup(row->getAddress().c_str()), strdup(row->getLabel().c_str()));
            subaddressesValue[i] = reinterpret_cast<int64_t>(localRow);
        }

        return subaddressesValue;
    }

    int32_t subaddress_size(ErrorBox* error)
    {
        if (!is_subaddress_loaded(error))
            return 0;

        auto subaddresses = m_subaddress->getAll();
        return (uint32_t)subaddresses.size();
    }

    void free_block_of_subaddresses(int64_t* handles, int32_t size)
    {
        int64_t* p = handles;

        while (size-- > 0)
        {
            int64_t handle = *(handles++);
            auto item = reinterpret_cast<SubaddressRow*>(handle);

            delete item;
        }

        delete[] p;
    }

    const char* get_address(uint32_t account_index, uint32_t address_index, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* address = nullptr;

        try
        {
            address = strdup(m_wallet->address(account_index, address_index).c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return address;
    }

    uint64_t get_full_balance(uint32_t account_index, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return 0;

        uint64_t balance;

        try
        {
            balance = m_wallet->balance(account_index);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return balance;
    }

    uint64_t get_unlocked_balance(uint32_t account_index, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return 0;

        uint64_t balance;

        try
        {
            balance = m_wallet->unlockedBalance(account_index);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return balance;
    }

    const char* get_subaddress_label(uint32_t account_index, uint32_t address_index, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* label = nullptr;

        try
        {
            label = strdup(m_wallet->getSubaddressLabel(account_index, address_index).c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return label;
    }

    void account_add_row(const char* label, ErrorBox* error)
    {
        if (!is_account_loaded(error))
            return;

        try
        {
            m_account->addRow(std::string(label));
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void account_set_label_row(uint32_t account_index, const char* label, ErrorBox* error)
    {
        if (!is_account_loaded(error))
            return;

        try
        {
            m_account->setLabel(account_index, label);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void subaddress_add_row(uint32_t account_index, const char* label, ErrorBox* error)
    {
        if (!is_subaddress_loaded(error))
            return;

        try
        {
            m_subaddress->addRow(account_index, std::string(label));
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void subaddress_set_label(uint32_t account_index, uint32_t address_index, const char* label, ErrorBox* error)
    {
        if (!is_subaddress_loaded(error))
            return;

        try
        {
            m_subaddress->setLabel(account_index, address_index, std::string(label));
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void account_refresh(ErrorBox* error)
    {
        if (!is_account_loaded(error))
            return;

        try
        {
            m_account->refresh();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    void subaddress_refresh(uint32_t account_index, ErrorBox* error)
    {
        if (!is_subaddress_loaded(error))
            return;

        try
        {
            m_subaddress->refresh(account_index);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    // **********************************************************************************************************************************
    // Transaction
    // **********************************************************************************************************************************

    void transactions_refresh(ErrorBox* error)
    {
        if (!is_history_loaded(error))
            return;

        try
        {
            m_transaction_history->refresh();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }
    }

    int64_t* transactions_get_all(ErrorBox* error)
    {
        if (!is_history_loaded(error))
            return nullptr;

        std::vector<Monero::TransactionInfo*> transactions = m_transaction_history->getAll();
        size_t size = transactions.size();

        int64_t* transaction_handles = new int64_t[size];

        for (int i = 0; i < size; i++)
        {
            Monero::TransactionInfo* row = transactions[i];
            TransactionInfoRow* tx = new TransactionInfoRow(row);
            transaction_handles[i] = reinterpret_cast<int64_t>(tx);
        }

        return transaction_handles;
    }

    int64_t transactions_count(ErrorBox* error)
    {
        if (!is_history_loaded(error))
            return 0;

        return m_transaction_history->count();
    }

    void free_block_of_transactions(int64_t* handles, int32_t size)
    {
        int64_t* p = handles;

        while (size-- > 0)
        {
            int64_t handle = *(handles++);
            auto item = reinterpret_cast<TransactionInfoRow*>(handle);

            delete item;
        }

        delete[] p;
    }

    const char* get_tx_key(const char* tx_id, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* tx_key = nullptr;

        try
        {
            tx_key = strdup(m_wallet->getTxKey(std::string(tx_id)).c_str());
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return tx_key;
    }

    void transaction_create(const char* address, const char* payment_id, const char* amount, uint8_t priority, uint32_t subaddr_account, ExternPendingTransactionRaw* pending_transaction, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

#if defined(_POSIX_VERSION)
        nice(19);
#endif

        auto priority_value = static_cast<Monero::PendingTransaction::Priority>(priority);
        std::string payment_id_value;

        Monero::PendingTransaction* transaction;

        if (payment_id != nullptr)
            payment_id_value = std::string(payment_id);

        auto amount_value = (amount != nullptr) ? (Monero::optional<uint64_t>)Monero::Wallet::amountFromString(std::string(amount)) : Monero::optional<uint64_t>();

        try
        {
            transaction = wallet->createTransaction(std::string(address), payment_id_value, amount_value, wallet->defaultMixin(), priority_value, subaddr_account);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        int status = transaction->status();

        if (status == Monero::PendingTransaction::Status::Status_Error
            || status == Monero::PendingTransaction::Status::Status_Critical)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());

            return;
        }

        if (m_listener != nullptr)
            m_listener->m_new_transaction = true;

        if (wallet->multisig().isMultisig)
            transaction->signMultisigTx();

        pending_transaction->amount = transaction->amount();
        pending_transaction->fee = transaction->fee();
        pending_transaction->hash = strdup(transaction->txid()[0].c_str());
        pending_transaction->hex = strdup(transaction->hex()[0].c_str());
        pending_transaction->tx_key = strdup(transaction->txKey()[0].c_str());
        pending_transaction->multisig_sign_data = strdup(transaction->multisigSignData().c_str());
        pending_transaction->monero_transaction_handle = reinterpret_cast<int64_t>(transaction);
    }

    void transaction_create_mult_dest(const char** addresses, const char* payment_id, const char** amounts, uint32_t size, uint8_t priority_raw, uint32_t subaddr_account, ExternPendingTransactionRaw* pending_transaction, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

#if defined(_POSIX_VERSION)
        nice(19);
#endif

        std::vector<std::string> address_values;
        std::vector<uint64_t> amount_values;

        for (uint32_t i = 0; i < size; i++)
        {
            address_values.push_back(std::string(*addresses));
            amount_values.push_back(Monero::Wallet::amountFromString(std::string(*amounts)));

            addresses++;
            amounts++;
        }

        auto priority = static_cast<Monero::PendingTransaction::Priority>(priority_raw);

        std::string _payment_id;

        if (payment_id != nullptr)
            _payment_id = std::string(payment_id);

        Monero::PendingTransaction* transaction;

        try
        {
            transaction = wallet->createTransactionMultDest(address_values, _payment_id, amount_values, wallet->defaultMixin(), priority, subaddr_account);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        int status = transaction->status();

        if (status == Monero::PendingTransaction::Status::Status_Error || status == Monero::PendingTransaction::Status::Status_Critical)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());

            return;
        }

        if (m_listener != nullptr)
            m_listener->m_new_transaction = true;

        if (wallet->multisig().isMultisig)
            transaction->signMultisigTx();

        pending_transaction->amount = transaction->amount();
        pending_transaction->fee = transaction->fee();
        pending_transaction->hash = strdup(transaction->txid()[0].c_str());
        pending_transaction->hex = strdup(transaction->hex()[0].c_str());
        pending_transaction->tx_key = strdup(transaction->txKey()[0].c_str());
        pending_transaction->multisig_sign_data = strdup(transaction->multisigSignData().c_str());
        pending_transaction->monero_transaction_handle = reinterpret_cast<int64_t>(transaction);
    }

    void transaction_commit(ExternPendingTransactionRaw* transaction, ErrorBox* error)
    {
        auto pending_transaction = reinterpret_cast<Monero::PendingTransaction*>(transaction->monero_transaction_handle);

        bool is_committed = false;

        try
        {
            is_committed = pending_transaction->commit();
        }
        catch (std::exception& e)
        {
            error->code = -1;
            error->message = strdup(e.what());

            return;
        }

        if (!is_committed)
        {
            error->code = -2;
            error->message = strdup(pending_transaction->errorString().c_str());

            return;
        }

        if (m_listener != nullptr)
            m_listener->m_new_transaction = true;
    }

    void freeze(const char* key_image, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        std::string key_value = key_image;
        bool is_success;

        try
        {
            is_success = wallet->freeze(key_value);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_success)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());
        }
    }

    void thaw(const char* key_image, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        std::string key_value = key_image;
        bool is_success;

        try
        {
            is_success = wallet->thaw(key_value);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (!is_success)
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());
        }
    }

    bool frozen(const char* key_image, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return false;

        std::string key_value = key_image;

        bool result = false;

        try
        {
            result = m_wallet->frozen(key_value);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char *get_transfers(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        std::string text;

        try
        {
            text = m_wallet->get_transfers();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return nullptr;
        }

        const char * result = strdup(text.c_str());

        return result;
    }

    // **********************************************************************************************************************************
    // Multisig
    // **********************************************************************************************************************************

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

    bool is_multisig(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return false;

        Monero::MultisigState state;

        try
        {
            state = m_wallet->multisig();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return false;
        }

        return state.isMultisig;
    }

    const char* prepare_multisig(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        std::string result;

        try
        {
            result = m_wallet->prepare_multisig();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return nullptr;
        }

        return strdup(result.c_str());
    }

    const char* get_multisig_info(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        std::string result;

        try
        {
            result = m_wallet->getMultisigInfo();
        }
        catch (std::exception& e)
        {
            result = std::string();

            error->code = -2;
            error->message = strdup(e.what());
        }

        if (result.empty())
            return nullptr;

        return strdup(result.c_str());
    }

    const char* exchange_multisig_keys(const char* const* const info, uint32_t size, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        auto info_vector = to_vector(info, size);

        std::string result;

        try
        {
            result = m_wallet->exchangeMultisigKeys(info_vector);
        }
        catch (std::exception& e)
        {
            result = std::string();

            error->code = -2;
            error->message = strdup(e.what());
        }

        if (result.empty())
            return nullptr;

        return strdup(result.c_str());
    }

    bool is_multisig_import_needed(ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return false;

        bool result = false;

        try
        {
            result = m_wallet->hasMultisigPartialKeyImages();
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    uint32_t import_multisig_images(const char* const* const info, uint32_t size, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return 0;

        auto info_vector = to_vector(info, size);

        uint32_t result;

        try
        {
            result = (uint32_t)m_wallet->importMultisigImages(info_vector);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    void export_multisig_images(const char** info, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return;

        auto wallet = m_wallet;

        std::string images;
        bool is_success = false;

        try
        {
            is_success = wallet->exportMultisigImages(images);
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());

            return;
        }

        if (is_success)
            (*info) = strdup(images.c_str());
        else
        {
            error->code = -3;
            error->message = strdup(wallet->errorString().c_str());
        }
    }

    const char* make_multisig(const char* const* const info, uint32_t size, uint32_t threshold, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        std::vector<std::string> info_vector = to_vector(info, size);
        std::string result;

        try
        {
            result = m_wallet->makeMultisig(info_vector, threshold);
        }
        catch (std::exception& e)
        {
            result = std::string();

            error->code = -2;
            error->message = strdup(e.what());
        }

        if (result.empty())
            return nullptr;

        return strdup(result.c_str());
    }

    const char* sign_multisig_tx_hex(const char* multisig_tx_hex, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        const char* result = nullptr;

        try
        {
            std::string hexString = multisig_tx_hex;
            Monero::MoneroMultisigSignResult signResult = m_wallet->sign_multisig_tx_hex(hexString);

            if (!signResult.m_signed_multisig_tx_hex.empty())
                result = strdup(signResult.m_signed_multisig_tx_hex.c_str());
            else
                result = nullptr;
        }
        catch (std::exception& e)
        {
            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

    const char* const* submit_multisig_tx_hex(const char* signed_multisig_tx_hex, ErrorBox* error)
    {
        if (!is_wallet_created(error))
            return nullptr;

        std::string signed_multisig_tx_hex_value = signed_multisig_tx_hex;
        std::vector<std::string> result_vector;
        const char* const* result;

        try
        {
            result_vector = m_wallet->submit_multisig_tx_hex(signed_multisig_tx_hex_value);
            result = from_vector(result_vector);
        }
        catch (std::exception& e)
        {
            result = nullptr;

            error->code = -2;
            error->message = strdup(e.what());
        }

        return result;
    }

#ifdef __cplusplus
}
#endif
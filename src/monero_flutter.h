#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct ErrorBox
    {
        int code;
        const char *message;
    } ErrorBox;

    typedef struct ByteArray {
        const uint8_t *bytes;
        int32_t length;
    } ByteArray;

    typedef struct ExternPendingTransactionRaw
    {
        int64_t amount;
        int64_t fee;
        const char *hex;
        const char *hash;
        const char *tx_key;
        const char *multisig_sign_data;
        int64_t monero_transaction_handle;
    } ExternPendingTransactionRaw;

    // **********************************************************************************************************************************
    // Wallet manager
    // **********************************************************************************************************************************

    // Creating (loading) wallet
    void create_wallet(const char *path, const char *password, const char *language, int32_t network_type, ErrorBox *error);
    void restore_wallet_from_seed(const char *path, const char *password, const char *seed, int32_t network_type, uint64_t restore_height, ErrorBox *error);
    void restore_wallet_from_keys(const char *path, const char *password, const char *language, const char *address, const char *view_key, const char *spend_key, int32_t network_type, uint64_t restore_height, ErrorBox *error);
    bool is_wallet_exist(const char *path);
    void load_wallet(const char *path, const char *password, int32_t net_type, ErrorBox *error);

    void open_wallet_data_hex(const char *password,
                                  bool testnet,
                                  const char *keys_data_hex,
                                  const char *cache_data_hex,
                                  const char *daemon_address,
                                  const char *daemon_username,
                                  const char *daemon_password,
                                  ErrorBox* error);

    void open_wallet_data(const char *password,
                              bool testnet,
                              const uint8_t *keys_data,
                              const int32_t keys_data_len,
                              const uint8_t *cache_data,
                              const int32_t cache_data_len,
                              const char *daemon_address,
                              const char *daemon_username,
                              const char *daemon_password,
                              ErrorBox* error);

    void close_current_wallet(ErrorBox *error);

    // Get info
    const char *secret_view_key(ErrorBox *error);
    const char *public_view_key(ErrorBox *error);
    const char *secret_spend_key(ErrorBox *error);
    const char *public_spend_key(ErrorBox *error);
    const char *seed(ErrorBox *error);
    const char *get_mnemonic(ErrorBox *error);

    const char *get_filename(ErrorBox *error);

    // Change
    void set_password(const char *password, ErrorBox *error);

    // Save
    void store(const char *path, ErrorBox *error);

    // Unknown use case!
    void set_recovering_from_seed(bool is_recovery, ErrorBox *error);

    const char *get_keys_data_hex(const char *password, bool view_only, ErrorBox* error);
    const ByteArray get_keys_data(const char *password, bool view_only, ErrorBox* error);
    const char *get_cache_data_hex(const char *password, ErrorBox* error);
    const ByteArray get_cache_data(const char *password, ErrorBox* error);

    // **********************************************************************************************************************************
    // Synchronization
    // **********************************************************************************************************************************

    void on_startup(ErrorBox *error);
    void setup_node(const char *address, const char *login, const char *password, bool use_ssl, bool is_light_wallet, ErrorBox *error);
    void set_listener(ErrorBox *error);
    void connect_to_node(ErrorBox *error);
    bool is_connected(ErrorBox *error);
    bool is_needed_to_refresh(ErrorBox *error);
    void start_refresh(ErrorBox *error);
    void pause_refresh(ErrorBox *error);
    void set_refresh_from_block_height(uint64_t height, ErrorBox *error);
    void rescan_blockchain(ErrorBox *error);
    void set_trusted_daemon(bool arg, ErrorBox *error);
    bool trusted_daemon(ErrorBox *error);
    uint64_t get_node_height(ErrorBox *error);
    bool is_new_transaction_exist(ErrorBox *error);
    uint64_t get_syncing_height(ErrorBox *error);
    uint64_t get_current_height(ErrorBox *error);

    void rescan_spent(ErrorBox *error);

    //uint64_t get_node_height_or_update(uint64_t base_eight);

    // **********************************************************************************************************************************
    // Account
    // **********************************************************************************************************************************

    // Get info
    int64_t *account_get_all(ErrorBox *error);
    int32_t account_size(ErrorBox *error);
    void free_block_of_accounts(int64_t *handles, int32_t size);

    int32_t get_num_subaddresses(int32_t account_index, ErrorBox *error);
    int64_t *subaddress_get_all(ErrorBox *error);
    int32_t subaddress_size(ErrorBox *error);
    void free_block_of_subaddresses(int64_t *handles, int32_t size);

    const char *get_address(uint32_t account_index, uint32_t address_index, ErrorBox *error);

    uint64_t get_full_balance(uint32_t account_index, ErrorBox *error);
    uint64_t get_unlocked_balance(uint32_t account_index, ErrorBox *error);

    const char *get_subaddress_label(uint32_t account_index, uint32_t address_index, ErrorBox *error);

    // SetInfo
    void account_add_row(const char *label, ErrorBox *error);
    void account_set_label_row(uint32_t account_index, const char *label, ErrorBox *error);
    void subaddress_add_row(uint32_t account_index, const char *label, ErrorBox *error);
    void subaddress_set_label(uint32_t account_index, uint32_t address_index, const char *label, ErrorBox *error);

    // Refresh
    void account_refresh(ErrorBox *error);
    void subaddress_refresh(uint32_t account_index, ErrorBox *error);

    // **********************************************************************************************************************************
    // Transaction
    // **********************************************************************************************************************************

    void transactions_refresh(ErrorBox *error);

    int64_t *transactions_get_all(ErrorBox *error);
    int64_t transactions_count(ErrorBox *error);
    void free_block_of_transactions(int64_t *handles, int32_t size);

    const char *get_tx_key(const char *tx_id, ErrorBox *error);

    void transaction_create(const char *address, const char *payment_id, const char *amount, uint8_t priority_raw, uint32_t subaddr_account, ExternPendingTransactionRaw *pending_transaction, ErrorBox *error);
    void transaction_create_mult_dest(const char **addresses, const char *payment_id, const char **amounts, uint32_t size, uint8_t priority, uint32_t subaddr_account, ExternPendingTransactionRaw *pending_transaction, ErrorBox *error);
    void transaction_commit(ExternPendingTransactionRaw *transaction, ErrorBox *error);

    void freeze(const char *key_image, ErrorBox *error);
    void thaw(const char *key_image, ErrorBox *error);
    bool frozen(const char *key_image, ErrorBox *error);

    const char *get_txs(const char *tx_query_json, ErrorBox *error);
    const char *get_outputs(const char *output_query_json, ErrorBox *error);
    const char *sweep_unlocked(const char *config_json, ErrorBox *error);
    const char *describe_tx_set(const char *tx_set_json, ErrorBox *error);

    const char *get_transfers(ErrorBox* error);

    // **********************************************************************************************************************************
    // Multisig
    // **********************************************************************************************************************************

    bool is_multisig(ErrorBox *error);
    const char *prepare_multisig(ErrorBox *error);
    const char *get_multisig_info(ErrorBox *error);
    const char *exchange_multisig_keys(const char *const *info, uint32_t size, ErrorBox *error);
    bool is_multisig_import_needed(ErrorBox *error);
    uint32_t import_multisig_images(const char *const *info, uint32_t size, ErrorBox *error);
    void export_multisig_images(const char **info, ErrorBox *error);
    const char *make_multisig(const char *const *info, uint32_t size, uint32_t threshold, ErrorBox *error);
    const char *sign_multisig_tx_hex(const char *multisig_tx_hex, ErrorBox *error);
    const char *const *submit_multisig_tx_hex(const char *signed_multisig_tx_hex, ErrorBox *error);

#ifdef __cplusplus
}
#endif

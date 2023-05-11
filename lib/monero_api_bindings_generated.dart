// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings for `src/flutter_monero.h`.
///
/// Regenerate bindings with `flutter pub run ffigen --config ffigen.yaml`.
///
class MoneroApiBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  MoneroApiBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  MoneroApiBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// Creating (loading) wallet
  void create_wallet(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ffi.Char> language,
    int network_type,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _create_wallet(
      path,
      password,
      language,
      network_type,
      error,
    );
  }

  late final _create_walletPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Int32,
              ffi.Pointer<ErrorBox>)>>('create_wallet');
  late final _create_wallet = _create_walletPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, int, ffi.Pointer<ErrorBox>)>();

  void restore_wallet_from_seed(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ffi.Char> seed,
    int network_type,
    int restore_height,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _restore_wallet_from_seed(
      path,
      password,
      seed,
      network_type,
      restore_height,
      error,
    );
  }

  late final _restore_wallet_from_seedPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Int32,
              ffi.Uint64,
              ffi.Pointer<ErrorBox>)>>('restore_wallet_from_seed');
  late final _restore_wallet_from_seed =
      _restore_wallet_from_seedPtr.asFunction<
          void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>, int, int, ffi.Pointer<ErrorBox>)>();

  void restore_wallet_from_keys(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ffi.Char> language,
    ffi.Pointer<ffi.Char> address,
    ffi.Pointer<ffi.Char> view_key,
    ffi.Pointer<ffi.Char> spend_key,
    int network_type,
    int restore_height,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _restore_wallet_from_keys(
      path,
      password,
      language,
      address,
      view_key,
      spend_key,
      network_type,
      restore_height,
      error,
    );
  }

  late final _restore_wallet_from_keysPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Int32,
              ffi.Uint64,
              ffi.Pointer<ErrorBox>)>>('restore_wallet_from_keys');
  late final _restore_wallet_from_keys =
      _restore_wallet_from_keysPtr.asFunction<
          void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              int,
              int,
              ffi.Pointer<ErrorBox>)>();

  bool is_wallet_exist(
    ffi.Pointer<ffi.Char> path,
  ) {
    return _is_wallet_exist(
      path,
    );
  }

  late final _is_wallet_existPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Char>)>>(
          'is_wallet_exist');
  late final _is_wallet_exist =
      _is_wallet_existPtr.asFunction<bool Function(ffi.Pointer<ffi.Char>)>();

  void load_wallet(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> password,
    int net_type,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _load_wallet(
      path,
      password,
      net_type,
      error,
    );
  }

  late final _load_walletPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Int32, ffi.Pointer<ErrorBox>)>>('load_wallet');
  late final _load_wallet = _load_walletPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int,
          ffi.Pointer<ErrorBox>)>();

  void close_current_wallet(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _close_current_wallet(
      error,
    );
  }

  late final _close_current_walletPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'close_current_wallet');
  late final _close_current_wallet = _close_current_walletPtr
      .asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  /// Get info
  ffi.Pointer<ffi.Char> secret_view_key(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _secret_view_key(
      error,
    );
  }

  late final _secret_view_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('secret_view_key');
  late final _secret_view_key = _secret_view_keyPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> public_view_key(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _public_view_key(
      error,
    );
  }

  late final _public_view_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('public_view_key');
  late final _public_view_key = _public_view_keyPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> secret_spend_key(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _secret_spend_key(
      error,
    );
  }

  late final _secret_spend_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('secret_spend_key');
  late final _secret_spend_key = _secret_spend_keyPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> public_spend_key(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _public_spend_key(
      error,
    );
  }

  late final _public_spend_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('public_spend_key');
  late final _public_spend_key = _public_spend_keyPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> seed(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _seed(
      error,
    );
  }

  late final _seedPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>>('seed');
  late final _seed = _seedPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_filename(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_filename(
      error,
    );
  }

  late final _get_filenamePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_filename');
  late final _get_filename = _get_filenamePtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  /// Change
  void set_password(
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _set_password(
      password,
      error,
    );
  }

  late final _set_passwordPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('set_password');
  late final _set_password = _set_passwordPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  /// Save
  void store(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _store(
      path,
      error,
    );
  }

  late final _storePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('store');
  late final _store = _storePtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  /// Unknown use case!
  void set_recovering_from_seed(
    bool is_recovery,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _set_recovering_from_seed(
      is_recovery,
      error,
    );
  }

  late final _set_recovering_from_seedPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Bool, ffi.Pointer<ErrorBox>)>>('set_recovering_from_seed');
  late final _set_recovering_from_seed = _set_recovering_from_seedPtr
      .asFunction<void Function(bool, ffi.Pointer<ErrorBox>)>();

  /// **********************************************************************************************************************************
  /// Synchronization
  /// **********************************************************************************************************************************
  void on_startup(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _on_startup(
      error,
    );
  }

  late final _on_startupPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'on_startup');
  late final _on_startup =
      _on_startupPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  void setup_node(
    ffi.Pointer<ffi.Char> address,
    ffi.Pointer<ffi.Char> login,
    ffi.Pointer<ffi.Char> password,
    bool use_ssl,
    bool is_light_wallet,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _setup_node(
      address,
      login,
      password,
      use_ssl,
      is_light_wallet,
      error,
    );
  }

  late final _setup_nodePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Bool,
              ffi.Bool,
              ffi.Pointer<ErrorBox>)>>('setup_node');
  late final _setup_node = _setup_nodePtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, bool, bool, ffi.Pointer<ErrorBox>)>();

  void set_listener(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _set_listener(
      error,
    );
  }

  late final _set_listenerPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'set_listener');
  late final _set_listener =
      _set_listenerPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  void connect_to_node(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _connect_to_node(
      error,
    );
  }

  late final _connect_to_nodePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'connect_to_node');
  late final _connect_to_node =
      _connect_to_nodePtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  bool is_connected(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _is_connected(
      error,
    );
  }

  late final _is_connectedPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ErrorBox>)>>(
          'is_connected');
  late final _is_connected =
      _is_connectedPtr.asFunction<bool Function(ffi.Pointer<ErrorBox>)>();

  bool is_needed_to_refresh(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _is_needed_to_refresh(
      error,
    );
  }

  late final _is_needed_to_refreshPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ErrorBox>)>>(
          'is_needed_to_refresh');
  late final _is_needed_to_refresh = _is_needed_to_refreshPtr
      .asFunction<bool Function(ffi.Pointer<ErrorBox>)>();

  void start_refresh(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _start_refresh(
      error,
    );
  }

  late final _start_refreshPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'start_refresh');
  late final _start_refresh =
      _start_refreshPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  void set_refresh_from_block_height(
    int height,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _set_refresh_from_block_height(
      height,
      error,
    );
  }

  late final _set_refresh_from_block_heightPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Uint64,
              ffi.Pointer<ErrorBox>)>>('set_refresh_from_block_height');
  late final _set_refresh_from_block_height = _set_refresh_from_block_heightPtr
      .asFunction<void Function(int, ffi.Pointer<ErrorBox>)>();

  void rescan_blockchain(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _rescan_blockchain(
      error,
    );
  }

  late final _rescan_blockchainPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'rescan_blockchain');
  late final _rescan_blockchain =
      _rescan_blockchainPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  void set_trusted_daemon(
    bool arg,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _set_trusted_daemon(
      arg,
      error,
    );
  }

  late final _set_trusted_daemonPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Bool, ffi.Pointer<ErrorBox>)>>('set_trusted_daemon');
  late final _set_trusted_daemon = _set_trusted_daemonPtr
      .asFunction<void Function(bool, ffi.Pointer<ErrorBox>)>();

  bool trusted_daemon(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _trusted_daemon(
      error,
    );
  }

  late final _trusted_daemonPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ErrorBox>)>>(
          'trusted_daemon');
  late final _trusted_daemon =
      _trusted_daemonPtr.asFunction<bool Function(ffi.Pointer<ErrorBox>)>();

  int get_node_height(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_node_height(
      error,
    );
  }

  late final _get_node_heightPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<ErrorBox>)>>(
          'get_node_height');
  late final _get_node_height =
      _get_node_heightPtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  bool is_new_transaction_exist(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _is_new_transaction_exist(
      error,
    );
  }

  late final _is_new_transaction_existPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ErrorBox>)>>(
          'is_new_transaction_exist');
  late final _is_new_transaction_exist = _is_new_transaction_existPtr
      .asFunction<bool Function(ffi.Pointer<ErrorBox>)>();

  int get_syncing_height(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_syncing_height(
      error,
    );
  }

  late final _get_syncing_heightPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<ErrorBox>)>>(
          'get_syncing_height');
  late final _get_syncing_height =
      _get_syncing_heightPtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  int get_current_height(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_current_height(
      error,
    );
  }

  late final _get_current_heightPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<ErrorBox>)>>(
          'get_current_height');
  late final _get_current_height =
      _get_current_heightPtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  void rescan_spent(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _rescan_spent(
      error,
    );
  }

  late final _rescan_spentPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'rescan_spent');
  late final _rescan_spent =
      _rescan_spentPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  /// Get info
  ffi.Pointer<ffi.Int64> account_get_all(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _account_get_all(
      error,
    );
  }

  late final _account_get_allPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Int64> Function(
              ffi.Pointer<ErrorBox>)>>('account_get_all');
  late final _account_get_all = _account_get_allPtr
      .asFunction<ffi.Pointer<ffi.Int64> Function(ffi.Pointer<ErrorBox>)>();

  int account_size(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _account_size(
      error,
    );
  }

  late final _account_sizePtr =
      _lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ErrorBox>)>>(
          'account_size');
  late final _account_size =
      _account_sizePtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  void free_block_of_accounts(
    ffi.Pointer<ffi.Int64> handles,
    int size,
  ) {
    return _free_block_of_accounts(
      handles,
      size,
    );
  }

  late final _free_block_of_accountsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Int64>, ffi.Int32)>>('free_block_of_accounts');
  late final _free_block_of_accounts = _free_block_of_accountsPtr
      .asFunction<void Function(ffi.Pointer<ffi.Int64>, int)>();

  ffi.Pointer<ffi.Int64> subaddress_get_all(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _subaddress_get_all(
      error,
    );
  }

  late final _subaddress_get_allPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Int64> Function(
              ffi.Pointer<ErrorBox>)>>('subaddress_get_all');
  late final _subaddress_get_all = _subaddress_get_allPtr
      .asFunction<ffi.Pointer<ffi.Int64> Function(ffi.Pointer<ErrorBox>)>();

  int subaddress_size(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _subaddress_size(
      error,
    );
  }

  late final _subaddress_sizePtr =
      _lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ErrorBox>)>>(
          'subaddress_size');
  late final _subaddress_size =
      _subaddress_sizePtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  void free_block_of_subaddresses(
    ffi.Pointer<ffi.Int64> handles,
    int size,
  ) {
    return _free_block_of_subaddresses(
      handles,
      size,
    );
  }

  late final _free_block_of_subaddressesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Int64>,
              ffi.Int32)>>('free_block_of_subaddresses');
  late final _free_block_of_subaddresses = _free_block_of_subaddressesPtr
      .asFunction<void Function(ffi.Pointer<ffi.Int64>, int)>();

  ffi.Pointer<ffi.Char> get_address(
    int account_index,
    int address_index,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_address(
      account_index,
      address_index,
      error,
    );
  }

  late final _get_addressPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Uint32, ffi.Uint32, ffi.Pointer<ErrorBox>)>>('get_address');
  late final _get_address = _get_addressPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(int, int, ffi.Pointer<ErrorBox>)>();

  int get_full_balance(
    int account_index,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_full_balance(
      account_index,
      error,
    );
  }

  late final _get_full_balancePtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint64 Function(
              ffi.Uint32, ffi.Pointer<ErrorBox>)>>('get_full_balance');
  late final _get_full_balance = _get_full_balancePtr
      .asFunction<int Function(int, ffi.Pointer<ErrorBox>)>();

  int get_unlocked_balance(
    int account_index,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_unlocked_balance(
      account_index,
      error,
    );
  }

  late final _get_unlocked_balancePtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint64 Function(
              ffi.Uint32, ffi.Pointer<ErrorBox>)>>('get_unlocked_balance');
  late final _get_unlocked_balance = _get_unlocked_balancePtr
      .asFunction<int Function(int, ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_subaddress_label(
    int account_index,
    int address_index,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_subaddress_label(
      account_index,
      address_index,
      error,
    );
  }

  late final _get_subaddress_labelPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Uint32, ffi.Uint32,
              ffi.Pointer<ErrorBox>)>>('get_subaddress_label');
  late final _get_subaddress_label = _get_subaddress_labelPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(int, int, ffi.Pointer<ErrorBox>)>();

  /// SetInfo
  void account_add_row(
    ffi.Pointer<ffi.Char> label,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _account_add_row(
      label,
      error,
    );
  }

  late final _account_add_rowPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('account_add_row');
  late final _account_add_row = _account_add_rowPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  void account_set_label_row(
    int account_index,
    ffi.Pointer<ffi.Char> label,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _account_set_label_row(
      account_index,
      label,
      error,
    );
  }

  late final _account_set_label_rowPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Uint32, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('account_set_label_row');
  late final _account_set_label_row = _account_set_label_rowPtr.asFunction<
      void Function(int, ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  void subaddress_add_row(
    int account_index,
    ffi.Pointer<ffi.Char> label,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _subaddress_add_row(
      account_index,
      label,
      error,
    );
  }

  late final _subaddress_add_rowPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Uint32, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('subaddress_add_row');
  late final _subaddress_add_row = _subaddress_add_rowPtr.asFunction<
      void Function(int, ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  void subaddress_set_label(
    int account_index,
    int address_index,
    ffi.Pointer<ffi.Char> label,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _subaddress_set_label(
      account_index,
      address_index,
      label,
      error,
    );
  }

  late final _subaddress_set_labelPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Uint32, ffi.Uint32, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('subaddress_set_label');
  late final _subaddress_set_label = _subaddress_set_labelPtr.asFunction<
      void Function(int, int, ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  /// Refresh
  void account_refresh(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _account_refresh(
      error,
    );
  }

  late final _account_refreshPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'account_refresh');
  late final _account_refresh =
      _account_refreshPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  void subaddress_refresh(
    int account_index,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _subaddress_refresh(
      account_index,
      error,
    );
  }

  late final _subaddress_refreshPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Uint32, ffi.Pointer<ErrorBox>)>>('subaddress_refresh');
  late final _subaddress_refresh = _subaddress_refreshPtr
      .asFunction<void Function(int, ffi.Pointer<ErrorBox>)>();

  /// **********************************************************************************************************************************
  /// Transaction
  /// **********************************************************************************************************************************
  void transactions_refresh(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _transactions_refresh(
      error,
    );
  }

  late final _transactions_refreshPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'transactions_refresh');
  late final _transactions_refresh = _transactions_refreshPtr
      .asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Int64> transactions_get_all(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _transactions_get_all(
      error,
    );
  }

  late final _transactions_get_allPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Int64> Function(
              ffi.Pointer<ErrorBox>)>>('transactions_get_all');
  late final _transactions_get_all = _transactions_get_allPtr
      .asFunction<ffi.Pointer<ffi.Int64> Function(ffi.Pointer<ErrorBox>)>();

  int transactions_count(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _transactions_count(
      error,
    );
  }

  late final _transactions_countPtr =
      _lookup<ffi.NativeFunction<ffi.Int64 Function(ffi.Pointer<ErrorBox>)>>(
          'transactions_count');
  late final _transactions_count =
      _transactions_countPtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  void free_block_of_transactions(
    ffi.Pointer<ffi.Int64> handles,
    int size,
  ) {
    return _free_block_of_transactions(
      handles,
      size,
    );
  }

  late final _free_block_of_transactionsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Int64>,
              ffi.Int32)>>('free_block_of_transactions');
  late final _free_block_of_transactions = _free_block_of_transactionsPtr
      .asFunction<void Function(ffi.Pointer<ffi.Int64>, int)>();

  ffi.Pointer<ffi.Char> get_tx_key(
    ffi.Pointer<ffi.Char> tx_id,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_tx_key(
      tx_id,
      error,
    );
  }

  late final _get_tx_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('get_tx_key');
  late final _get_tx_key = _get_tx_keyPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  void transaction_create(
    ffi.Pointer<ffi.Char> address,
    ffi.Pointer<ffi.Char> payment_id,
    ffi.Pointer<ffi.Char> amount,
    int priority_raw,
    int subaddr_account,
    ffi.Pointer<ExternPendingTransactionRaw> pending_transaction,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _transaction_create(
      address,
      payment_id,
      amount,
      priority_raw,
      subaddr_account,
      pending_transaction,
      error,
    );
  }

  late final _transaction_createPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Uint8,
              ffi.Uint32,
              ffi.Pointer<ExternPendingTransactionRaw>,
              ffi.Pointer<ErrorBox>)>>('transaction_create');
  late final _transaction_create = _transaction_createPtr.asFunction<
      void Function(
          ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>,
          int,
          int,
          ffi.Pointer<ExternPendingTransactionRaw>,
          ffi.Pointer<ErrorBox>)>();

  void transaction_create_mult_dest(
    ffi.Pointer<ffi.Pointer<ffi.Char>> addresses,
    ffi.Pointer<ffi.Char> payment_id,
    ffi.Pointer<ffi.Pointer<ffi.Char>> amounts,
    int size,
    int priority,
    int subaddr_account,
    ffi.Pointer<ExternPendingTransactionRaw> pending_transaction,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _transaction_create_mult_dest(
      addresses,
      payment_id,
      amounts,
      size,
      priority,
      subaddr_account,
      pending_transaction,
      error,
    );
  }

  late final _transaction_create_mult_destPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Uint32,
              ffi.Uint8,
              ffi.Uint32,
              ffi.Pointer<ExternPendingTransactionRaw>,
              ffi.Pointer<ErrorBox>)>>('transaction_create_mult_dest');
  late final _transaction_create_mult_dest =
      _transaction_create_mult_destPtr.asFunction<
          void Function(
              ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Pointer<ffi.Char>>,
              int,
              int,
              int,
              ffi.Pointer<ExternPendingTransactionRaw>,
              ffi.Pointer<ErrorBox>)>();

  void transaction_commit(
    ffi.Pointer<ExternPendingTransactionRaw> transaction,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _transaction_commit(
      transaction,
      error,
    );
  }

  late final _transaction_commitPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ExternPendingTransactionRaw>,
              ffi.Pointer<ErrorBox>)>>('transaction_commit');
  late final _transaction_commit = _transaction_commitPtr.asFunction<
      void Function(
          ffi.Pointer<ExternPendingTransactionRaw>, ffi.Pointer<ErrorBox>)>();

  void freeze(
    ffi.Pointer<ffi.Char> key_image,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _freeze(
      key_image,
      error,
    );
  }

  late final _freezePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('freeze');
  late final _freeze = _freezePtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  void thaw(
    ffi.Pointer<ffi.Char> key_image,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _thaw(
      key_image,
      error,
    );
  }

  late final _thawPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('thaw');
  late final _thaw = _thawPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  bool frozen(
    ffi.Pointer<ffi.Char> key_image,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _frozen(
      key_image,
      error,
    );
  }

  late final _frozenPtr = _lookup<
      ffi.NativeFunction<
          ffi.Bool Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('frozen');
  late final _frozen = _frozenPtr.asFunction<
      bool Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  /// **********************************************************************************************************************************
  /// Multisig
  /// **********************************************************************************************************************************
  bool is_multisig(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _is_multisig(
      error,
    );
  }

  late final _is_multisigPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ErrorBox>)>>(
          'is_multisig');
  late final _is_multisig =
      _is_multisigPtr.asFunction<bool Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> prepare_multisig(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _prepare_multisig(
      error,
    );
  }

  late final _prepare_multisigPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('prepare_multisig');
  late final _prepare_multisig = _prepare_multisigPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_multisig_info(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_multisig_info(
      error,
    );
  }

  late final _get_multisig_infoPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_multisig_info');
  late final _get_multisig_info = _get_multisig_infoPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> exchange_multisig_keys(
    ffi.Pointer<ffi.Pointer<ffi.Char>> info,
    int size,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _exchange_multisig_keys(
      info,
      size,
      error,
    );
  }

  late final _exchange_multisig_keysPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Uint32, ffi.Pointer<ErrorBox>)>>('exchange_multisig_keys');
  late final _exchange_multisig_keys = _exchange_multisig_keysPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(
          ffi.Pointer<ffi.Pointer<ffi.Char>>, int, ffi.Pointer<ErrorBox>)>();

  bool is_multisig_import_needed(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _is_multisig_import_needed(
      error,
    );
  }

  late final _is_multisig_import_neededPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ErrorBox>)>>(
          'is_multisig_import_needed');
  late final _is_multisig_import_needed = _is_multisig_import_neededPtr
      .asFunction<bool Function(ffi.Pointer<ErrorBox>)>();

  int import_multisig_images(
    ffi.Pointer<ffi.Pointer<ffi.Char>> info,
    int size,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _import_multisig_images(
      info,
      size,
      error,
    );
  }

  late final _import_multisig_imagesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint32 Function(ffi.Pointer<ffi.Pointer<ffi.Char>>, ffi.Uint32,
              ffi.Pointer<ErrorBox>)>>('import_multisig_images');
  late final _import_multisig_images = _import_multisig_imagesPtr.asFunction<
      int Function(
          ffi.Pointer<ffi.Pointer<ffi.Char>>, int, ffi.Pointer<ErrorBox>)>();

  void export_multisig_images(
    ffi.Pointer<ffi.Pointer<ffi.Char>> info,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _export_multisig_images(
      info,
      error,
    );
  }

  late final _export_multisig_imagesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Pointer<ErrorBox>)>>('export_multisig_images');
  late final _export_multisig_images = _export_multisig_imagesPtr.asFunction<
      void Function(
          ffi.Pointer<ffi.Pointer<ffi.Char>>, ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> make_multisig(
    ffi.Pointer<ffi.Pointer<ffi.Char>> info,
    int size,
    int threshold,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _make_multisig(
      info,
      size,
      threshold,
      error,
    );
  }

  late final _make_multisigPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Uint32, ffi.Uint32, ffi.Pointer<ErrorBox>)>>('make_multisig');
  late final _make_multisig = _make_multisigPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Pointer<ffi.Char>>, int,
          int, ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> sign_multisig_tx_hex(
    ffi.Pointer<ffi.Char> multisig_tx_hex,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _sign_multisig_tx_hex(
      multisig_tx_hex,
      error,
    );
  }

  late final _sign_multisig_tx_hexPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('sign_multisig_tx_hex');
  late final _sign_multisig_tx_hex = _sign_multisig_tx_hexPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Pointer<ffi.Char>> submit_multisig_tx_hex(
    ffi.Pointer<ffi.Char> signed_multisig_tx_hex,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _submit_multisig_tx_hex(
      signed_multisig_tx_hex,
      error,
    );
  }

  late final _submit_multisig_tx_hexPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Pointer<ffi.Char>> Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('submit_multisig_tx_hex');
  late final _submit_multisig_tx_hex = _submit_multisig_tx_hexPtr.asFunction<
      ffi.Pointer<ffi.Pointer<ffi.Char>> Function(
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();
}

class ErrorBox extends ffi.Struct {
  @ffi.Int()
  external int code;

  external ffi.Pointer<ffi.Char> message;
}

class ExternPendingTransactionRaw extends ffi.Struct {
  @ffi.Int64()
  external int amount;

  @ffi.Int64()
  external int fee;

  external ffi.Pointer<ffi.Char> hex;

  external ffi.Pointer<ffi.Char> hash;

  external ffi.Pointer<ffi.Char> tx_key;

  external ffi.Pointer<ffi.Char> multisig_sign_data;

  @ffi.Int64()
  external int monero_transaction_handle;
}

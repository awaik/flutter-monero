// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings for `src/monero_ffi.h`.
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

  /// ************* Load/Save *************
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

  bool is_wallet_loaded() {
    return _is_wallet_loaded();
  }

  late final _is_wallet_loadedPtr =
      _lookup<ffi.NativeFunction<ffi.Bool Function()>>('is_wallet_loaded');
  late final _is_wallet_loaded =
      _is_wallet_loadedPtr.asFunction<bool Function()>();

  void restore_wallet_from_seed(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ffi.Char> seed,
    int network_type,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _restore_wallet_from_seed(
      path,
      password,
      seed,
      network_type,
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
              ffi.Pointer<ErrorBox>)>>('restore_wallet_from_seed');
  late final _restore_wallet_from_seed =
      _restore_wallet_from_seedPtr.asFunction<
          void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>, int, ffi.Pointer<ErrorBox>)>();

  void open_wallet_data(
    ffi.Pointer<ffi.Char> password,
    int network_type,
    ffi.Pointer<ffi.Uint8> keys_data,
    int keys_data_len,
    ffi.Pointer<ffi.Uint8> cache_data,
    int cache_data_len,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _open_wallet_data(
      password,
      network_type,
      keys_data,
      keys_data_len,
      cache_data,
      cache_data_len,
      error,
    );
  }

  late final _open_wallet_dataPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>,
              ffi.Int32,
              ffi.Pointer<ffi.Uint8>,
              ffi.Int32,
              ffi.Pointer<ffi.Uint8>,
              ffi.Int32,
              ffi.Pointer<ErrorBox>)>>('open_wallet_data');
  late final _open_wallet_data = _open_wallet_dataPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, int, ffi.Pointer<ffi.Uint8>, int,
          ffi.Pointer<ffi.Uint8>, int, ffi.Pointer<ErrorBox>)>();

  void load_wallet(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<ffi.Char> password,
    int network_type,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _load_wallet(
      path,
      password,
      network_type,
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

  ByteArray get_keys_data(
    ffi.Pointer<ffi.Char> password,
    bool view_only,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_keys_data(
      password,
      view_only,
      error,
    );
  }

  late final _get_keys_dataPtr = _lookup<
      ffi.NativeFunction<
          ByteArray Function(ffi.Pointer<ffi.Char>, ffi.Bool,
              ffi.Pointer<ErrorBox>)>>('get_keys_data');
  late final _get_keys_data = _get_keys_dataPtr.asFunction<
      ByteArray Function(ffi.Pointer<ffi.Char>, bool, ffi.Pointer<ErrorBox>)>();

  ByteArray get_cache_data(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_cache_data(
      error,
    );
  }

  late final _get_cache_dataPtr =
      _lookup<ffi.NativeFunction<ByteArray Function(ffi.Pointer<ErrorBox>)>>(
          'get_cache_data');
  late final _get_cache_data = _get_cache_dataPtr
      .asFunction<ByteArray Function(ffi.Pointer<ErrorBox>)>();

  void store(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _store(
      error,
    );
  }

  late final _storePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'store');
  late final _store =
      _storePtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

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

  /// ************* Multisig *************
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

  ffi.Pointer<ffi.Char> make_multisig(
    ffi.Pointer<ffi.Pointer<ffi.Char>> info,
    int size,
    int threshold,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _make_multisig(
      info,
      size,
      threshold,
      password,
      error,
    );
  }

  late final _make_multisigPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Uint32,
              ffi.Uint32,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('make_multisig');
  late final _make_multisig = _make_multisigPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Pointer<ffi.Char>>, int,
          int, ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> exchange_multisig_keys(
    ffi.Pointer<ffi.Pointer<ffi.Char>> info,
    int size,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _exchange_multisig_keys(
      info,
      size,
      password,
      error,
    );
  }

  late final _exchange_multisig_keysPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ffi.Pointer<ffi.Char>>,
              ffi.Uint32,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('exchange_multisig_keys');
  late final _exchange_multisig_keys = _exchange_multisig_keysPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Pointer<ffi.Char>>, int,
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

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

  /// ************* Sync *************
  void setup_node(
    ffi.Pointer<ffi.Char> address,
    ffi.Pointer<ffi.Char> login,
    ffi.Pointer<ffi.Char> password,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _setup_node(
      address,
      login,
      password,
      error,
    );
  }

  late final _setup_nodePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>>('setup_node');
  late final _setup_node = _setup_nodePtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  void set_restore_height(
    int restore_height,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _set_restore_height(
      restore_height,
      error,
    );
  }

  late final _set_restore_heightPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Uint64, ffi.Pointer<ErrorBox>)>>('set_restore_height');
  late final _set_restore_height = _set_restore_heightPtr
      .asFunction<void Function(int, ffi.Pointer<ErrorBox>)>();

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

  void stop_syncing(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _stop_syncing(
      error,
    );
  }

  late final _stop_syncingPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ErrorBox>)>>(
          'stop_syncing');
  late final _stop_syncing =
      _stop_syncingPtr.asFunction<void Function(ffi.Pointer<ErrorBox>)>();

  int get_start_height(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_start_height(
      error,
    );
  }

  late final _get_start_heightPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<ErrorBox>)>>(
          'get_start_height');
  late final _get_start_height =
      _get_start_heightPtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

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

  int get_end_height(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_end_height(
      error,
    );
  }

  late final _get_end_heightPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<ErrorBox>)>>(
          'get_end_height');
  late final _get_end_height =
      _get_end_heightPtr.asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  double get_percent_done(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_percent_done(
      error,
    );
  }

  late final _get_percent_donePtr =
      _lookup<ffi.NativeFunction<ffi.Double Function(ffi.Pointer<ErrorBox>)>>(
          'get_percent_done');
  late final _get_percent_done =
      _get_percent_donePtr.asFunction<double Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_listener_message(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_listener_message(
      error,
    );
  }

  late final _get_listener_messagePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_listener_message');
  late final _get_listener_message = _get_listener_messagePtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Pointer<ffi.Char>> get_public_nodes(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_public_nodes(
      error,
    );
  }

  late final _get_public_nodesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Pointer<ffi.Char>> Function(
              ffi.Pointer<ErrorBox>)>>('get_public_nodes');
  late final _get_public_nodes = _get_public_nodesPtr.asFunction<
      ffi.Pointer<ffi.Pointer<ffi.Char>> Function(ffi.Pointer<ErrorBox>)>();

  int get_single_block_tx_count(
    ffi.Pointer<ffi.Char> address,
    int block_height,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_single_block_tx_count(
      address,
      block_height,
      error,
    );
  }

  late final _get_single_block_tx_countPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint64 Function(ffi.Pointer<ffi.Char>, ffi.Uint64,
              ffi.Pointer<ErrorBox>)>>('get_single_block_tx_count');
  late final _get_single_block_tx_count =
      _get_single_block_tx_countPtr.asFunction<
          int Function(ffi.Pointer<ffi.Char>, int, ffi.Pointer<ErrorBox>)>();

  /// ************* Financial *************
  ffi.Pointer<ffi.Char> get_address(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_address(
      error,
    );
  }

  late final _get_addressPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_address');
  late final _get_address = _get_addressPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_receive_address(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_receive_address(
      error,
    );
  }

  late final _get_receive_addressPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_receive_address');
  late final _get_receive_address = _get_receive_addressPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  int get_confirmed_balance(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_confirmed_balance(
      error,
    );
  }

  late final _get_confirmed_balancePtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<ErrorBox>)>>(
          'get_confirmed_balance');
  late final _get_confirmed_balance = _get_confirmed_balancePtr
      .asFunction<int Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_all_transactions_json(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_all_transactions_json(
      error,
    );
  }

  late final _get_all_transactions_jsonPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_all_transactions_json');
  late final _get_all_transactions_json = _get_all_transactions_jsonPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> get_utxos_json(
    ffi.Pointer<ErrorBox> error,
  ) {
    return _get_utxos_json(
      error,
    );
  }

  late final _get_utxos_jsonPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<ErrorBox>)>>('get_utxos_json');
  late final _get_utxos_json = _get_utxos_jsonPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ErrorBox>)>();

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

  ffi.Pointer<ffi.Char> create_transaction(
    ffi.Pointer<ffi.Char> tx_config_json,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _create_transaction(
      tx_config_json,
      error,
    );
  }

  late final _create_transactionPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('create_transaction');
  late final _create_transaction = _create_transactionPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();

  ffi.Pointer<ffi.Char> describe_tx_set(
    ffi.Pointer<ffi.Char> tx_set_json,
    ffi.Pointer<ErrorBox> error,
  ) {
    return _describe_tx_set(
      tx_set_json,
      error,
    );
  }

  late final _describe_tx_setPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<ErrorBox>)>>('describe_tx_set');
  late final _describe_tx_set = _describe_tx_setPtr.asFunction<
      ffi.Pointer<ffi.Char> Function(
          ffi.Pointer<ffi.Char>, ffi.Pointer<ErrorBox>)>();
}

sealed class ErrorBox extends ffi.Struct {
  @ffi.Int()
  external int code;

  external ffi.Pointer<ffi.Char> message;
}

sealed class ByteArray extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> bytes;

  @ffi.Int32()
  external int length;
}
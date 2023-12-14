import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/exceptions/restore_wallet_from_keys_exception.dart';
import 'package:monero_flutter/exceptions/restore_wallet_from_seed_exception.dart';

import 'package:monero_flutter/monero_flutter.dart' as monero_flutter;

const int networkType = 0;

// *****************************************************************************
// is_wallet_exist
// *****************************************************************************

/// Checks if a Monero wallet exists at the specified path (async version).
///
/// Determines whether a Monero wallet exists at the given [path].
///
/// Parameters:
///   [path] - The path to the wallet file.
///
/// Returns:
///   A [Future] that completes with the boolean value, indicating whether the wallet exists.
Future<bool> isWalletExist({required String path}) =>
    compute(_isWalletExistSync, {'path': path});

bool _isWalletExistSync(Map args) {
  final path = args['path'] as String;
  return isWalletExistSync(path: path);
}

/// Checks if a Monero wallet exists at the specified path (sync version).
///
/// Determines whether a Monero wallet exists at the given [path].
///
/// Parameters:
///   [path] - The path to the wallet file.
///
/// Returns:
///   A boolean value indicating whether the wallet exists.
bool isWalletExistSync({required String path}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final isExist = monero_flutter.bindings.is_wallet_exist(pathPointer);

  calloc.free(pathPointer);

  return isExist;
}

// *****************************************************************************
// is_wallet_loaded
// *****************************************************************************

/// Mthod checks whether the wallet is loaded (async version).
///
/// Returns:
///   A [Future] that completes with the boolean value, indicating whether the wallet loaded.
Future<bool> isWalletLoaded() {
  return compute<Map<String, Object?>, bool>(_isWalletLoaded, {});
}

bool _isWalletLoaded(Map<String, dynamic> args) => isWalletLoadedSync();

/// Mthod checks whether the wallet is loaded (sync version).
///
/// Returns:
///   A boolean value, indicating whether the wallet loaded.
bool isWalletLoadedSync() {
  return monero_flutter.bindings.is_wallet_loaded();
}

// *****************************************************************************
// restore_wallet_from_seed
// *****************************************************************************

/// Restores a Monero wallet from a mnemonic seed (async version).
///
/// Restores a Monero wallet using the specified [path], [password], [seed].
///
/// Parameters:
///   [path] - The path to store the restored wallet file.
///   [password] - The password to encrypt the wallet.
///   [seed] - The mnemonic seed used to restore the wallet.
Future restoreWalletFromSeed(
    {required String path,
      required String password,
      required String seed}) async =>
    compute<Map<String, Object>, void>(_restoreWalletFromSeed, {
      'path': path,
      'password': password,
      'seed': seed
    });

void _restoreWalletFromSeed(Map<String, dynamic> args) {
  final path = args['path'] as String;
  final password = args['password'] as String;
  final seed = args['seed'] as String;

  restoreWalletFromSeedSync(
      path: path, password: password, seed: seed);
}

/// Restores a Monero wallet from a mnemonic seed (sync version).
///
/// Restores a Monero wallet using the specified [path], [password], [seed].
///
/// Parameters:
///   [path] - The path to store the restored wallet file.
///   [password] - The password to encrypt the wallet.
///   [seed] - The mnemonic seed used to restore the wallet.
void restoreWalletFromSeedSync({
  required String path,
  required String password,
  required String seed
}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final seedPointer = seed.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.restore_wallet_from_seed(
    pathPointer,
    passwordPointer,
    seedPointer,
    networkType,
    errorBoxPointer,
  );
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(seedPointer);

  if (0 != errorInfo.code) {
    throw RestoreWalletFromSeedException(message: errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// open_wallet_data
// *****************************************************************************

/// Opens a Monero wallet using the provided keys data and cache data as `Uint8List` (async version).
///
/// Opens a Monero wallet using the provided [password], [keysData] and [cacheData].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [keysData] - The keys data as a `Uint8List`.
///   [cacheData] - The cache data as a `Uint8List`.
///
/// Returns:
///   A [Future] that completes with no result.
Future openWalletData(
    String password,
    Uint8List keysData,
    Uint8List cacheData) {
  return compute<Map<String, Object?>, void>(_openWalletDataSync, {
    'password': password,
    'keysData': keysData,
    'cacheData': cacheData
  });
}

void _openWalletDataSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  final keysData = args['keysData'] as Uint8List;
  final cacheData = args['cacheData'] as Uint8List;

  openWalletDataSync(password, keysData, cacheData);
}

/// Opens a Monero wallet synchronously using the provided keys data and cache data as `Uint8List` (sync version).
///
/// Opens a Monero wallet synchronously using the provided [password], [keysData] and [cacheData].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [keysData] - The keys data as a `Uint8List`.
///   [cacheData] - The cache data as a `Uint8List`.
void openWalletDataSync(
    String password,
    Uint8List keysData,
    Uint8List cacheData) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final keysDataPointer = monero_flutter.toNativeByteArray(keysData);
  final cacheDataPointer = monero_flutter.toNativeByteArray(cacheData);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.open_wallet_data(
      passwordPointer,
      networkType,
      keysDataPointer,
      keysData.length,
      cacheDataPointer,
      cacheData.length,
      errorBoxPointer);

  calloc.free(passwordPointer);
  calloc.free(keysDataPointer);
  calloc.free(cacheDataPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// load_wallet
// *****************************************************************************

/// Loads an existing Monero wallet (async version).
///
/// Loads an existing Monero wallet from the specified [path] using the provided [password].
///
/// Parameters:
///   [path] - The path to the wallet file.
///   [password] - The password to decrypt the wallet.
Future loadWallet(
    {required String path,
      required String password}) async =>
    compute(_loadWallet, {'path': path, 'password': password});

void _loadWallet(Map<String, dynamic> args) {
  final path = args['path'] as String;
  final password = args['password'] as String;

  loadWalletSync(path: path, password: password);
}

/// Loads an existing Monero wallet (sync version).
///
/// Loads an existing Monero wallet from the specified [path] using the provided [password].
///
/// Parameters:
///   [path] - The path to the wallet file.
///   [password] - The password to decrypt the wallet.
void loadWalletSync(
    {required String path, required String password}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings
      .load_wallet(pathPointer, passwordPointer, networkType, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);

  if (0 != errorInfo.code) {
    throw RestoreWalletFromKeysException(message: errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// get_keys_data
// *****************************************************************************

/// Retrieves the keys data buffer for the currently opened Monero wallet (async version).
///
/// Retrieves the keys data buffer for the currently opened Monero wallet,
/// using the specified [password] and [viewOnly] flag.
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [viewOnly] - A boolean flag indicating whether to retrieve view-only keys.
///
/// Returns:
///   A [Future] that completes with the keys data buffer as a [Uint8List].
Future<Uint8List> getKeysDataBuffer(String password, bool viewOnly) {
  return compute<Map<String, Object?>, Uint8List>(
      _getKeysDataBufferSync, {'password': password, 'viewOnly': viewOnly});
}

Uint8List _getKeysDataBufferSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  final viewOnly = args['viewOnly'] as bool;

  return getKeysDataBufferSync(password, viewOnly);
}

/// Retrieves the keys data buffer synchronously for the currently opened Monero wallet (sync version).
///
/// Retrieves the keys data buffer synchronously for the currently opened Monero wallet,
/// using the specified [password] and [viewOnly] flag.
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [viewOnly] - A boolean flag indicating whether to retrieve view-only keys.
///
/// Returns:
///   The keys data buffer as a [Uint8List].
Uint8List getKeysDataBufferSync(String password, bool viewOnly) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final byteArray = monero_flutter.bindings
      .get_keys_data(passwordPointer, viewOnly, errorBoxPointer);
  calloc.free(passwordPointer);

  final buffer =
  Uint8List.fromList(byteArray.bytes.asTypedList(byteArray.length));

  if (byteArray.length > 0) {
    calloc.free(byteArray.bytes);
  }

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return buffer;
}

// *****************************************************************************
// get_cache_data
// *****************************************************************************

/// Retrieves the cache data buffer for the currently opened Monero wallet (async version).
///
/// Retrieves the cache data buffer for the currently opened Monero wallet.
///
/// Returns:
///   A [Future] that completes with the cache data buffer as a [Uint8List].
Future<Uint8List> getCacheDataBuffer() {
  return compute<Map<String, Object?>, Uint8List>(_getCacheDataBufferSync, {});
}

Uint8List _getCacheDataBufferSync(Map<String, Object?> args) {
  return getCacheDataBufferSync();
}

/// Retrieves the cache data buffer synchronously for the currently opened Monero wallet (sync version).
///
/// Retrieves the cache data buffer synchronously for the currently opened Monero wallet.
///
/// Returns:
///   The cache data buffer as a [Uint8List].
Uint8List getCacheDataBufferSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final byteArray =
  monero_flutter.bindings.get_cache_data(errorBoxPointer);

  final buffer =
  Uint8List.fromList(byteArray.bytes.asTypedList(byteArray.length));

  if (byteArray.length > 0) {
    calloc.free(byteArray.bytes);
  }

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return buffer;
}

// *****************************************************************************
// store
// *****************************************************************************

/// Stores the currently opened Monero wallet (async version).
Future store() => compute(_storeSync, {});

void _storeSync(Map args) {
  storeSync();
}

/// Stores the currently opened Monero wallet (sync version).
void storeSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.store(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// close_current_wallet
// *****************************************************************************

/// Closes the currently opened Monero wallet (async version).
///
/// Closes the currently opened Monero wallet.
/// After calling this function, the wallet is no longer available in memory.
Future closeCurrentWallet() => compute(_closeCurrentWalletSync, {});

void _closeCurrentWalletSync(Map args) {
  closeCurrentWalletSync();
}

/// Closes the currently opened Monero wallet (sync version).
///
/// Closes the currently opened Monero wallet.
/// After calling this function, the wallet is no longer available in memory.
void closeCurrentWalletSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.close_current_wallet(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}
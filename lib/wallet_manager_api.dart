import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'exceptions/wallet_creation_exception.dart';
import 'exceptions/wallet_restore_from_keys_exception.dart';
import 'exceptions/wallet_restore_from_seed_exception.dart';

import 'monero_flutter.dart' as monero_flutter;

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

/// Creates a new Monero wallet (async version).
///
/// Generates a new Monero wallet using the specified [path], [password], [language],
/// and optional [nettype].
///
/// Parameters:
///   [path] - The path to store the new wallet file.
///   [password] - The password to encrypt the wallet.
///   [language] - The language used for the wallet's mnemonic seed.
///   [nettype] - (Optional) The network type. Defaults to 0.
Future createWallet(
        {required String path,
        required String password,
        required String language,
        int nettype = 0}) async =>
    compute(_createWallet,
        {'path': path, 'password': password, 'language': language});

void _createWallet(Map<String, dynamic> args) {
  final path = args['path'] as String;
  final password = args['password'] as String;
  final language = args['language'] as String;

  createWalletSync(path: path, password: password, language: language);
}

/// Creates a new Monero wallet (sync version).
///
/// Generates a new Monero wallet using the specified [path], [password], [language],
/// and optional [nettype].
///
/// Parameters:
///   [path] - The path to store the new wallet file.
///   [password] - The password to encrypt the wallet.
///   [language] - The language used for the wallet's mnemonic seed.
///   [nettype] - (Optional) The network type. Defaults to 0.
void createWalletSync(
    {required String path,
    required String password,
    required String language,
    int nettype = 0}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final languagePointer = language.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.create_wallet(
      pathPointer, passwordPointer, languagePointer, nettype, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(languagePointer);

  if (0 != errorInfo.code) {
    throw WalletCreationException(message: errorInfo.getErrorMessage());
  }
}

/// Restores a Monero wallet from a mnemonic seed (async version).
///
/// Restores a Monero wallet using the specified [path], [password], [seed],
/// and optional [nettype] and [restoreHeight].
///
/// Parameters:
///   [path] - The path to store the restored wallet file.
///   [password] - The password to encrypt the wallet.
///   [seed] - The mnemonic seed used to restore the wallet.
///   [nettype] - (Optional) The network type. Defaults to 0.
///   [restoreHeight] - (Optional) The block height to restore from. Defaults to 0.
Future restoreWalletFromSeed(
        {required String path,
        required String password,
        required String seed,
        int nettype = 0,
        int restoreHeight = 0}) async =>
    compute<Map<String, Object>, void>(_restoreWalletFromSeed, {
      'path': path,
      'password': password,
      'seed': seed,
      'nettype': nettype,
      'restoreHeight': restoreHeight
    });

void _restoreWalletFromSeed(Map<String, dynamic> args) {
  final path = args['path'] as String;
  final password = args['password'] as String;
  final seed = args['seed'] as String;
  final restoreHeight = args['restoreHeight'] as int;

  restoreWalletFromSeedSync(
      path: path, password: password, seed: seed, restoreHeight: restoreHeight);
}

/// Restores a Monero wallet from a mnemonic seed (sync version).
///
/// Restores a Monero wallet using the specified [path], [password], [seed],
/// and optional [nettype] and [restoreHeight].
///
/// Parameters:
///   [path] - The path to store the restored wallet file.
///   [password] - The password to encrypt the wallet.
///   [seed] - The mnemonic seed used to restore the wallet.
///   [nettype] - (Optional) The network type. Defaults to 0.
///   [restoreHeight] - (Optional) The block height to restore from. Defaults to 0.
void restoreWalletFromSeedSync({
  required String path,
  required String password,
  required String seed,
  int nettype = 0,
  int restoreHeight = 0,
}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final seedPointer = seed.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.restore_wallet_from_seed(
    pathPointer,
    passwordPointer,
    seedPointer,
    nettype,
    restoreHeight,
    errorBoxPointer,
  );
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(seedPointer);

  if (0 != errorInfo.code) {
    throw WalletRestoreFromSeedException(message: errorInfo.getErrorMessage());
  }
}

/// Restores a Monero wallet from keys (async version).
///
/// Restores a Monero wallet using the specified [path], [password], [language],
/// [address], [viewKey], [spendKey], and optional [nettype] and [restoreHeight].
///
/// Parameters:
///   [path] - The path to store the restored wallet file.
///   [password] - The password to encrypt the wallet.
///   [language] - The language used for the wallet's mnemonic seed.
///   [address] - The address associated with the wallet.
///   [viewKey] - The view key of the wallet.
///   [spendKey] - The spend key of the wallet.
///   [nettype] - (Optional) The network type. Defaults to 0.
///   [restoreHeight] - (Optional) The block height to restore from. Defaults to 0.
Future restoreWalletFromKeys(
        {required String path,
        required String password,
        required String language,
        required String address,
        required String viewKey,
        required String spendKey,
        int nettype = 0,
        int restoreHeight = 0}) async =>
    compute<Map<String, Object>, void>(_restoreWalletFromKeys, {
      'path': path,
      'password': password,
      'language': language,
      'address': address,
      'viewKey': viewKey,
      'spendKey': spendKey,
      'nettype': nettype,
      'restoreHeight': restoreHeight
    });

void _restoreWalletFromKeys(Map<String, dynamic> args) {
  final path = args['path'] as String;
  final password = args['password'] as String;
  final language = args['language'] as String;
  final restoreHeight = args['restoreHeight'] as int;
  final address = args['address'] as String;
  final viewKey = args['viewKey'] as String;
  final spendKey = args['spendKey'] as String;

  restoreWalletFromKeysSync(
      path: path,
      password: password,
      language: language,
      restoreHeight: restoreHeight,
      address: address,
      viewKey: viewKey,
      spendKey: spendKey);
}

/// Restores a Monero wallet from keys (sync version).
///
/// Restores a Monero wallet using the specified [path], [password], [language],
/// [address], [viewKey], [spendKey], and optional [nettype] and [restoreHeight].
///
/// Parameters:
///   [path] - The path to store the restored wallet file.
///   [password] - The password to encrypt the wallet.
///   [language] - The language used for the wallet's mnemonic seed.
///   [address] - The address associated with the wallet.
///   [viewKey] - The view key of the wallet.
///   [spendKey] - The spend key of the wallet.
///   [nettype] - (Optional) The network type. Defaults to 0.
///   [restoreHeight] - (Optional) The block height to restore from. Defaults to 0.
void restoreWalletFromKeysSync({
  required String path,
  required String password,
  required String language,
  required String address,
  required String viewKey,
  required String spendKey,
  int nettype = 0,
  int restoreHeight = 0,
}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final languagePointer = language.toNativeUtf8().cast<Char>();
  final addressPointer = address.toNativeUtf8().cast<Char>();
  final viewKeyPointer = viewKey.toNativeUtf8().cast<Char>();
  final spendKeyPointer = spendKey.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.restore_wallet_from_keys(
    pathPointer,
    passwordPointer,
    languagePointer,
    addressPointer,
    viewKeyPointer,
    spendKeyPointer,
    nettype,
    restoreHeight,
    errorBoxPointer,
  );
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(languagePointer);
  calloc.free(addressPointer);
  calloc.free(viewKeyPointer);
  calloc.free(spendKeyPointer);

  if (0 != errorInfo.code) {
    throw WalletRestoreFromKeysException(message: errorInfo.getErrorMessage());
  }
}

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

/// Loads an existing Monero wallet (async version).
///
/// Loads an existing Monero wallet from the specified [path] using the provided [password].
///
/// Parameters:
///   [path] - The path to the wallet file.
///   [password] - The password to decrypt the wallet.
///   [nettype] - (Optional) The network type. Defaults to 0.
Future loadWallet(
        {required String path,
        required String password,
        int nettype = 0}) async =>
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
///   [nettype] - (Optional) The network type. Defaults to 0.
void loadWalletSync(
    {required String path, required String password, int nettype = 0}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings
      .load_wallet(pathPointer, passwordPointer, nettype, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);

  if (0 != errorInfo.code) {
    throw WalletRestoreFromKeysException(message: errorInfo.getErrorMessage());
  }
}

/// Closes the currently opened Monero wallet (async version).
///
/// Closes the currently opened Monero wallet, if any.
/// After calling this function, the wallet is no longer available in memory.
Future closeCurrentWallet() => compute(_closeCurrentWalletSync, {});

void _closeCurrentWalletSync(Map args) {
  closeCurrentWalletSync();
}

/// Closes the currently opened Monero wallet (sync version).
///
/// Closes the currently opened Monero wallet, if any.
/// After calling this function, the wallet is no longer available in memory.
void closeCurrentWalletSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.close_current_wallet(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Retrieves the secret view key of the currently opened Monero wallet (async version).
///
/// Returns:
///   A [Future] that completes with the secret view key of the wallet as a string.
Future<String> getSecretViewKey() => compute(_getSecretViewKeySync, {});

String _getSecretViewKeySync(Map args) {
  return getSecretViewKeySync();
}

/// Retrieves the secret view key of the currently opened Monero wallet (sync version).
///
/// Returns:
///   The secret view key of the wallet as a string.
String getSecretViewKeySync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final secretViewKeyPointer =
      monero_flutter.bindings.secret_view_key(errorBoxPointer);
  final secretViewKey = secretViewKeyPointer.cast<Utf8>().toDartString();
  calloc.free(secretViewKeyPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return secretViewKey;
}

/// Returns the public view key of the currently opened Monero wallet as a string (async version).
///
/// Returns:
///   A [Future] that completes with the public view key of the wallet as a string.
Future<String> getPublicViewKey() => compute(_getPublicViewKeySync, {});

String _getPublicViewKeySync(Map args) {
  return getPublicViewKeySync();
}

/// Returns the public view key of the currently opened Monero wallet as a string (sync version).
///
/// Returns:
///   The public view key of the wallet as a string.
String getPublicViewKeySync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final viewKeyPointer =
      monero_flutter.bindings.public_view_key(errorBoxPointer);
  final viewKey = viewKeyPointer.cast<Utf8>().toDartString();
  calloc.free(viewKeyPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return viewKey;
}

/// Returns the secret spend key of the currently opened Monero wallet as a string (async version).
///
/// Returns:
///   A [Future] that completes with the secret spend key of the wallet as a [String].
Future<String> getSecretSpendKey() => compute(_getSecretSpendKeySync, {});

String _getSecretSpendKeySync(Map args) {
  return getSecretSpendKeySync();
}

/// Returns the secret spend key of the currently opened Monero wallet as a string (sync version).
///
/// Returns:
///   The secret spend key of the wallet as a string.
String getSecretSpendKeySync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final secretSpendKeyPointer =
      monero_flutter.bindings.secret_spend_key(errorBoxPointer);
  final secretSpendKey = secretSpendKeyPointer.cast<Utf8>().toDartString();
  calloc.free(secretSpendKeyPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return secretSpendKey;
}

/// Returns the public spend key of the currently opened Monero wallet as a string (async version).
///
/// Returns:
///   A [Future] that completes with the public spend key of the wallet as a string.
Future<String> getPublicSpendKey() => compute(_getPublicSpendKeySync, {});

String _getPublicSpendKeySync(Map args) {
  return getPublicSpendKeySync();
}

/// Returns the public spend key of the currently opened Monero wallet as a string (sync version).
///
/// Returns:
///   The public spend key of the wallet as a string.
String getPublicSpendKeySync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final spendKeyPointer =
      monero_flutter.bindings.public_spend_key(errorBoxPointer);
  final spendKey = spendKeyPointer.cast<Utf8>().toDartString();
  calloc.free(spendKeyPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return spendKey;
}

/// Returns the mnemonic seed of the currently opened Monero wallet as a string (async version).
///
/// Returns:
///   A [Future] that completes with the mnemonic seed of the wallet as a [String].
@Deprecated('Use [getMnemonic] instead')
Future<String?> getSeed() => compute(_getSeedSync, {});

@Deprecated('Use [_getMnemonicSync] instead')
String? _getSeedSync(Map args) {
  return getSeedSync();
}

/// Returns the mnemonic seed of the currently opened Monero wallet as a string (sync version).
///
/// Returns:
///   The mnemonic seed of the wallet as a string.
@Deprecated('Use [getMnemonicSync] instead')
String? getSeedSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final seedPointer = monero_flutter.bindings.seed(errorBoxPointer);
  final seed = monero_flutter.extractString(seedPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return seed;
}

/// Returns the wallet's mnemonic phrase. If the wallet is in multisig mode, it returns a hexadecimal string (sync version).
///
/// Returns:
/// A [Future] that completes with the mnemonic phrase of the wallet as a string.
Future<String?> getMnemonic() => compute(_getMnemonicSync, {});

String? _getMnemonicSync(Map args) {
  return getMnemonicSync();
}

/// Returns the wallet's mnemonic phrase. If the wallet is in multisig mode, it returns a hexadecimal string (async version).
///
/// Returns:
/// The mnemonic phrase of the wallet as a string.
String? getMnemonicSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final mnemonicPointer = monero_flutter.bindings.get_mnemonic(errorBoxPointer);
  final mnemonic = monero_flutter.extractString(mnemonicPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return mnemonic;
}

/// Returns the filename of the currently opened Monero wallet as a string (async version).
///
/// Returns:
///   A [Future] that completes with the filename of the wallet as a string.
Future<String> getFilename() => compute(_getFilenameSync, {});

String _getFilenameSync(Map args) {
  return getFilenameSync();
}

/// Returns the filename of the currently opened Monero wallet as a string (sync version).
///
/// Returns:
///   The filename of the wallet as a string.
String getFilenameSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final filenamePointer = monero_flutter.bindings.get_filename(errorBoxPointer);
  final filename = filenamePointer.cast<Utf8>().toDartString();
  calloc.free(filenamePointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return filename;
}

/// Sets a new [password] for the currently opened Monero wallet (async version).
///
/// Parameters:
///   [password] - The new password for the wallet.
Future setPassword({required String password}) =>
    compute(_setPasswordSync, {'password': password});

void _setPasswordSync(Map args) {
  final password = args['password'] as String;
  setPasswordSync(password: password);
}

/// Sets a new [password] for the currently opened Monero wallet (sync version).
///
/// Parameters:
///   [password] - The new password for the wallet.
void setPasswordSync({required String password}) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.set_password(passwordPointer, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(passwordPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Stores the currently opened Monero wallet at the specified [path] (async version).
///
/// Parameters:
///   [path] - The path to store the wallet file.
Future store({required String path}) => compute(_storeSync, {'path': path});

void _storeSync(Map args) {
  final path = args['path'] as String;
  storeSync(path: path);
}

/// Stores the currently opened Monero wallet at the specified [path] (sync version).
///
/// Parameters:
///   [path] - The path to store the wallet file.
void storeSync({required String path}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.store(pathPointer, errorBoxPointer);

  calloc.free(pathPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Sets the flag indicating whether the currently opened Monero wallet is in recovery mode
/// from a seed (async version).
///
/// Parameters:
///   [isRecovery] - A boolean value indicating whether the wallet is in recovery mode.
Future setRecoveringFromSeed({required bool isRecovery}) =>
    compute(_setRecoveringFromSeedSync, {'isRecovery': isRecovery});

void _setRecoveringFromSeedSync(Map args) {
  final isRecovery = args['isRecovery'] as bool;
  setRecoveringFromSeedSync(isRecovery: isRecovery);
}

/// Sets the flag indicating whether the currently opened Monero wallet is in recovery mode
/// from a seed (sync version).
///
/// Parameters:
///   [isRecovery] - A boolean value indicating whether the wallet is in recovery mode.
void setRecoveringFromSeedSync({required bool isRecovery}) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.set_recovering_from_seed(isRecovery, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Retrieves the hexadecimal representation of the keys data for the currently opened Monero wallet (async version).
///
/// Retrieves the hexadecimal representation of the keys data for the currently opened Monero wallet,
/// using the specified [password] and [viewOnly] flag.
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [viewOnly] - A boolean flag indicating whether to retrieve view-only keys.
///
/// Returns:
///   A [Future] that completes with the hexadecimal representation of the keys data as a string.
Future<String> getKeysDataHex(String password, bool viewOnly) {
  return compute<Map<String, Object?>, String>(
      _getKeysDataHexSync, {'password': password, 'viewOnly': viewOnly});
}

String _getKeysDataHexSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  final viewOnly = args['viewOnly'] as bool;

  return getKeysDataHexSync(password, viewOnly);
}

/// Retrieves the hexadecimal representation of the keys data synchronously for the currently opened Monero wallet (sync version).
///
/// Retrieves the hexadecimal representation of the keys data synchronously for the currently opened Monero wallet,
/// using the specified [password] and [viewOnly] flag.
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [viewOnly] - A boolean flag indicating whether to retrieve view-only keys.
///
/// Returns:
///   The hexadecimal representation of the keys data as a string.
String getKeysDataHexSync(String password, bool viewOnly) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final hexPointer = monero_flutter.bindings
      .get_keys_data_hex(passwordPointer, viewOnly, errorBoxPointer);
  calloc.free(passwordPointer);

  String? hexString;

  if (nullptr != hexPointer) {
    hexString = hexPointer.cast<Utf8>().toDartString();
    calloc.free(hexPointer);
  }

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  if (null == hexString) {
    throw Exception("Empty response!");
  }

  return hexString;
}

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

/// Retrieves the hexadecimal representation of the cache data for the currently opened Monero wallet (async version).
///
/// Retrieves the hexadecimal representation of the cache data for the currently opened Monero wallet,
/// using the specified [password].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///
/// Returns:
///   A [Future] that completes with the hexadecimal representation of the cache data as a string.
Future<String> getCacheDataHex(String password) {
  return compute<Map<String, Object?>, String>(
      _getCacheDataHexSync, {'password': password});
}

String _getCacheDataHexSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  return getCacheDataHexSync(password);
}

/// Retrieves the hexadecimal representation of the cache data synchronously for the currently opened Monero wallet (sync version).
///
/// Retrieves the hexadecimal representation of the cache data synchronously for the currently opened Monero wallet,
/// using the specified [password].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///
/// Returns:
///   The hexadecimal representation of the cache data as a string.
String getCacheDataHexSync(String password) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final hexPointer = monero_flutter.bindings
      .get_cache_data_hex(passwordPointer, errorBoxPointer);
  calloc.free(passwordPointer);

  String? hexString;

  if (nullptr != hexPointer) {
    hexString = hexPointer.cast<Utf8>().toDartString();
    calloc.free(hexPointer);
  }

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  if (null == hexString) {
    throw Exception("Empty response!");
  }

  return hexString;
}

/// Retrieves the cache data buffer for the currently opened Monero wallet (async version).
///
/// Retrieves the cache data buffer for the currently opened Monero wallet,
/// using the specified [password].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///
/// Returns:
///   A [Future] that completes with the cache data buffer as a [Uint8List].
Future<Uint8List> getCacheDataBuffer(String password) {
  return compute<Map<String, Object?>, Uint8List>(
      _getCacheDataBufferSync, {'password': password});
}

Uint8List _getCacheDataBufferSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  return getCacheDataBufferSync(password);
}

/// Retrieves the cache data buffer synchronously for the currently opened Monero wallet (sync version).
///
/// Retrieves the cache data buffer synchronously for the currently opened Monero wallet,
/// using the specified [password].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///
/// Returns:
///   The cache data buffer as a [Uint8List].
Uint8List getCacheDataBufferSync(String password) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final byteArray =
      monero_flutter.bindings.get_cache_data(passwordPointer, errorBoxPointer);
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

/// Opens a Monero wallet using the provided keys data and cache data in hexadecimal format (async version).
///
/// Opens a Monero wallet using the provided [password], [testnet] flag, [keysDataHex], [cacheDataHex],
/// [daemonAddress], [daemonUsername], and [daemonPassword].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [testnet] - A boolean flag indicating whether to use the testnet.
///   [keysDataHex] - The hexadecimal representation of the keys data.
///   [cacheDataHex] - The hexadecimal representation of the cache data.
///   [daemonAddress] - The address of the Monero daemon.
///   [daemonUsername] - The username for the Monero daemon.
///   [daemonPassword] - The password for the Monero daemon.
///
/// Returns:
///   A [Future] that completes with no result.
Future openWalletDataHex(
    String password,
    bool testnet,
    String keysDataHex,
    String cacheDataHex,
    String daemonAddress,
    String daemonUsername,
    String daemonPassword) {
  return compute<Map<String, Object?>, void>(_openWalletDataHexSync, {
    'password': password,
    'testnet': testnet,
    'keysDataHex': keysDataHex,
    'cacheDataHex': cacheDataHex,
    'daemonAddress': daemonAddress,
    'daemonUsername': daemonUsername,
    'daemonPassword': daemonPassword
  });
}

void _openWalletDataHexSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  final testnet = args['testnet'] as bool;
  final keysDataHex = args['keysDataHex'] as String;
  final cacheDataHex = args['cacheDataHex'] as String;
  final daemonAddress = args['daemonAddress'] as String;
  final daemonUsername = args['daemonUsername'] as String;
  final daemonPassword = args['daemonPassword'] as String;

  openWalletDataHexSync(password, testnet, keysDataHex, cacheDataHex,
      daemonAddress, daemonUsername, daemonPassword);
}

/// Opens a Monero wallet synchronously using the provided keys data and cache data in hexadecimal format (sync version).
///
/// Opens a Monero wallet synchronously using the provided [password], [testnet] flag, [keysDataHex], [cacheDataHex],
/// [daemonAddress], [daemonUsername], and [daemonPassword].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [testnet] - A boolean flag indicating whether to use the testnet.
///   [keysDataHex] - The hexadecimal representation of the keys data.
///   [cacheDataHex] - The hexadecimal representation of the cache data.
///   [daemonAddress] - The address of the Monero daemon.
///   [daemonUsername] - The username for the Monero daemon.
///   [daemonPassword] - The password for the Monero daemon.
void openWalletDataHexSync(
    String password,
    bool testnet,
    String keysDataHex,
    String cacheDataHex,
    String daemonAddress,
    String daemonUsername,
    String daemonPassword) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final keysDataHexPointer = keysDataHex.toNativeUtf8().cast<Char>();
  final cacheDataHexPointer = cacheDataHex.toNativeUtf8().cast<Char>();
  final daemonAddressPointer = daemonAddress.toNativeUtf8().cast<Char>();
  final daemonUsernamePointer = daemonUsername.toNativeUtf8().cast<Char>();
  final daemonPasswordPointer = daemonPassword.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.open_wallet_data_hex(
      passwordPointer,
      testnet,
      keysDataHexPointer,
      cacheDataHexPointer,
      daemonAddressPointer,
      daemonUsernamePointer,
      daemonPasswordPointer,
      errorBoxPointer);

  calloc.free(passwordPointer);
  calloc.free(keysDataHexPointer);
  calloc.free(cacheDataHexPointer);
  calloc.free(daemonAddressPointer);
  calloc.free(daemonUsernamePointer);
  calloc.free(daemonPasswordPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Opens a Monero wallet using the provided keys data and cache data as `Uint8List` (async version).
///
/// Opens a Monero wallet using the provided [password], [testnet] flag, [keysData], [cacheData],
/// [daemonAddress], [daemonUsername], and [daemonPassword].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [testnet] - A boolean flag indicating whether to use the testnet.
///   [keysData] - The keys data as a `Uint8List`.
///   [cacheData] - The cache data as a `Uint8List`.
///   [daemonAddress] - The address of the Monero daemon.
///   [daemonUsername] - The username for the Monero daemon.
///   [daemonPassword] - The password for the Monero daemon.
///
/// Returns:
///   A [Future] that completes with no result.
Future openWalletData(
    String password,
    bool testnet,
    Uint8List keysData,
    Uint8List cacheData,
    String daemonAddress,
    String daemonUsername,
    String daemonPassword) {
  return compute<Map<String, Object?>, void>(_openWalletDataSync, {
    'password': password,
    'testnet': testnet,
    'keysData': keysData,
    'cacheData': cacheData,
    'daemonAddress': daemonAddress,
    'daemonUsername': daemonUsername,
    'daemonPassword': daemonPassword
  });
}

void _openWalletDataSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  final testnet = args['testnet'] as bool;
  final keysData = args['keysData'] as Uint8List;
  final cacheData = args['cacheData'] as Uint8List;
  final daemonAddress = args['daemonAddress'] as String;
  final daemonUsername = args['daemonUsername'] as String;
  final daemonPassword = args['daemonPassword'] as String;

  openWalletDataSync(password, testnet, keysData, cacheData, daemonAddress,
      daemonUsername, daemonPassword);
}

/// Opens a Monero wallet synchronously using the provided keys data and cache data as `Uint8List` (sync version).
///
/// Opens a Monero wallet synchronously using the provided [password], [testnet] flag, [keysData], [cacheData],
/// [daemonAddress], [daemonUsername], and [daemonPassword].
///
/// Parameters:
///   [password] - The password to decrypt the wallet.
///   [testnet] - A boolean flag indicating whether to use the testnet.
///   [keysData] - The keys data as a `Uint8List`.
///   [cacheData] - The cache data as a `Uint8List`.
///   [daemonAddress] - The address of the Monero daemon.
///   [daemonUsername] - The username for the Monero daemon.
///   [daemonPassword] - The password for the Monero daemon.
void openWalletDataSync(
    String password,
    bool testnet,
    Uint8List keysData,
    Uint8List cacheData,
    String daemonAddress,
    String daemonUsername,
    String daemonPassword) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final keysDataPointer = _toNativeByteArray(keysData);
  final cacheDataPointer = _toNativeByteArray(cacheData);
  final daemonAddressPointer = daemonAddress.toNativeUtf8().cast<Char>();
  final daemonUsernamePointer = daemonUsername.toNativeUtf8().cast<Char>();
  final daemonPasswordPointer = daemonPassword.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.open_wallet_data(
      passwordPointer,
      testnet,
      keysDataPointer,
      keysData.length,
      cacheDataPointer,
      cacheData.length,
      daemonAddressPointer,
      daemonUsernamePointer,
      daemonPasswordPointer,
      errorBoxPointer);

  calloc.free(passwordPointer);
  calloc.free(keysDataPointer);
  calloc.free(cacheDataPointer);
  calloc.free(daemonAddressPointer);
  calloc.free(daemonUsernamePointer);
  calloc.free(daemonPasswordPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Pointer<Uint8> _toNativeByteArray(Uint8List bytes) {
  final nativeData = calloc<Uint8>(bytes.length);
  nativeData.asTypedList(bytes.length).setAll(0, bytes);

  return nativeData;
}

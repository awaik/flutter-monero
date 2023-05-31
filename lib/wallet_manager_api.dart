import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'exceptions/wallet_creation_exception.dart';
import 'exceptions/wallet_restore_from_keys_exception.dart';
import 'exceptions/wallet_restore_from_seed_exception.dart';

import 'monero_flutter.dart' as monero_flutter;

Future<void> createWallet(
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

Future<void> restoreWalletFromSeed(
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

bool isWalletExist({required String path}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final isExist = monero_flutter.bindings.is_wallet_exist(pathPointer);

  calloc.free(pathPointer);

  return isExist;
}

Future<void> loadWallet(
        {required String path,
        required String password,
        int nettype = 0}) async =>
    compute(_loadWallet, {'path': path, 'password': password});

void _loadWallet(Map<String, dynamic> args) {
  final path = args['path'] as String;
  final password = args['password'] as String;

  loadWalletSync(path: path, password: password);
}

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

void closeCurrentWallet() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.close_current_wallet(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

String getSecretViewKey() {
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

String getPublicViewKey() {
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

String getSecretSpendKey() {
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

String getPublicSpendKey() {
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

String getSeed() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final seedPointer = monero_flutter.bindings.seed(errorBoxPointer);
  final seed = seedPointer.cast<Utf8>().toDartString();
  calloc.free(seedPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return seed;
}

String getFilename() {
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

void setPassword({required String password}) {
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.set_password(passwordPointer, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(passwordPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

void store({required String path}) {
  final pathPointer = path.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.store(pathPointer, errorBoxPointer);

  calloc.free(pathPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

void setRecoveringFromSeed({required bool isRecovery}) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.set_recovering_from_seed(isRecovery, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<String> getKeysDataHex(String password, bool viewOnly)
{
  return compute<Map<String, Object?>, String>(_getKeysDataHexSync, {'password': password, 'viewOnly': viewOnly});
}

String _getKeysDataHexSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  final viewOnly = args['viewOnly'] as bool;

  return getKeysDataHexSync(password, viewOnly);
}

String getKeysDataHexSync(String password, bool viewOnly)
{
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final hexPointer = monero_flutter.bindings.get_keys_data_hex(passwordPointer, viewOnly, errorBoxPointer);
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

Future<Uint8List> getKeysDataBuffer(String password, bool viewOnly) {
  return compute<Map<String, Object?>, Uint8List>(_getKeysDataBufferSync, {'password': password, 'viewOnly': viewOnly});
}

Uint8List _getKeysDataBufferSync(Map<String, Object?> args)
{
  final password = args['password'] as String;
  final viewOnly = args['viewOnly'] as bool;

  return getKeysDataBufferSync(password, viewOnly);
}

Uint8List getKeysDataBufferSync(String password, bool viewOnly)
{
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final byteArray = monero_flutter.bindings.get_keys_data(passwordPointer, viewOnly, errorBoxPointer);
  calloc.free(passwordPointer);

  final buffer = Uint8List.fromList(byteArray.bytes.asTypedList(byteArray.length));

  if (byteArray.length > 0) {
    calloc.free(byteArray.bytes);
  }

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return buffer;
}

Future<String> getCacheDataHex(String password) {
  return compute<Map<String, Object?>, String>(_getCacheDataHexSync, {'password': password });
}

String _getCacheDataHexSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  return getCacheDataHexSync(password);
}

String getCacheDataHexSync(String password)
{
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final hexPointer = monero_flutter.bindings.get_cache_data_hex(passwordPointer, errorBoxPointer);
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

Future<Uint8List> getCacheDataBuffer(String password) {
  return compute<Map<String, Object?>, Uint8List>(_getCacheDataBufferSync, {'password': password });
}

Uint8List _getCacheDataBufferSync(Map<String, Object?> args) {
  final password = args['password'] as String;
  return getCacheDataBufferSync(password);
}

Uint8List getCacheDataBufferSync(String password)
{
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final byteArray = monero_flutter.bindings.get_cache_data(passwordPointer, errorBoxPointer);
  calloc.free(passwordPointer);

  final buffer = Uint8List.fromList(byteArray.bytes.asTypedList(byteArray.length));

  if (byteArray.length > 0) {
    calloc.free(byteArray.bytes);
  }

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return buffer;
}

Future openWalletDataHex(String password,
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

void _openWalletDataHexSync (Map<String, Object?> args){
  final password = args['password'] as String;
  final testnet = args['testnet'] as bool;
  final keysDataHex = args['keysDataHex'] as String;
  final cacheDataHex = args['cacheDataHex'] as String;
  final daemonAddress = args['daemonAddress'] as String;
  final daemonUsername = args['daemonUsername'] as String;
  final daemonPassword = args['daemonPassword'] as String;

  openWalletDataHexSync(password, testnet, keysDataHex, cacheDataHex, daemonAddress, daemonUsername, daemonPassword);
}

void openWalletDataHexSync(String password,
    bool testnet,
    String keysDataHex,
    String cacheDataHex,
    String daemonAddress,
    String daemonUsername,
    String daemonPassword)
{
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final keysDataHexPointer = keysDataHex.toNativeUtf8().cast<Char>();
  final cacheDataHexPointer = cacheDataHex.toNativeUtf8().cast<Char>();
  final daemonAddressPointer = daemonAddress.toNativeUtf8().cast<Char>();
  final daemonUsernamePointer = daemonUsername.toNativeUtf8().cast<Char>();
  final daemonPasswordPointer = daemonPassword.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.open_wallet_data_hex(passwordPointer,
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

Future openWalletData(String password,
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

void _openWalletDataSync(Map<String, Object?> args){
  final password = args['password'] as String;
  final testnet = args['testnet'] as bool;
  final keysData = args['keysData'] as Uint8List;
  final cacheData = args['cacheData'] as Uint8List;
  final daemonAddress = args['daemonAddress'] as String;
  final daemonUsername = args['daemonUsername'] as String;
  final daemonPassword = args['daemonPassword'] as String;

  openWalletDataSync(password, testnet, keysData, cacheData, daemonAddress, daemonUsername, daemonPassword);
}

void openWalletDataSync(String password,
                      bool testnet,
                      Uint8List keysData,
                      Uint8List cacheData,
                      String daemonAddress,
                      String daemonUsername,
                      String daemonPassword)
{
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final keysDataPointer = _toNativeByteArray(keysData);
  final cacheDataPointer = _toNativeByteArray(cacheData);
  final daemonAddressPointer = daemonAddress.toNativeUtf8().cast<Char>();
  final daemonUsernamePointer = daemonUsername.toNativeUtf8().cast<Char>();
  final daemonPasswordPointer = daemonPassword.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.open_wallet_data(passwordPointer,
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

Pointer<Uint8> _toNativeByteArray(Uint8List bytes){

  final nativeData = calloc<Uint8>(bytes.length);
  nativeData.asTypedList(bytes.length).setAll(0, bytes);

  return nativeData;
}
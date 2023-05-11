import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'exceptions/wallet_creation_exception.dart';
import 'exceptions/wallet_restore_from_keys_exception.dart';
import 'exceptions/wallet_restore_from_seed_exception.dart';

import 'flutter_monero.dart' as flutter_monero;

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
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

  flutter_monero.bindings.create_wallet(pathPointer,
      passwordPointer, languagePointer, nettype, errorBoxPointer);
  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  calloc.free(pathPointer);
  calloc.free(passwordPointer);
  calloc.free(languagePointer);

  if (0 != errorInfo.code) {
    throw WalletCreationException(message: errorInfo.getErrorMessage());
  }
}

  Future<void> restoreWalletFromSeed({required String path,
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
        path: path,
        password: password,
        seed: seed,
        restoreHeight: restoreHeight);
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
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

    flutter_monero.bindings.restore_wallet_from_seed(
      pathPointer,
      passwordPointer,
      seedPointer,
      nettype,
      restoreHeight,
      errorBoxPointer,
    );
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    calloc.free(pathPointer);
    calloc.free(passwordPointer);
    calloc.free(seedPointer);

    if (0 != errorInfo.code) {
      throw WalletRestoreFromSeedException(
          message: errorInfo.getErrorMessage());
    }
  }

  Future restoreWalletFromKeys({required String path,
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
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

    flutter_monero.bindings.restore_wallet_from_keys(
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
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    calloc.free(pathPointer);
    calloc.free(passwordPointer);
    calloc.free(languagePointer);
    calloc.free(addressPointer);
    calloc.free(viewKeyPointer);
    calloc.free(spendKeyPointer);

    if (0 != errorInfo.code) {
      throw WalletRestoreFromKeysException(
          message: errorInfo.getErrorMessage());
    }
  }

  bool isWalletExist({required String path}) {
    final pathPointer = path.toNativeUtf8().cast<Char>();
    final isExist = flutter_monero.bindings.is_wallet_exist(pathPointer);

    calloc.free(pathPointer);

    return isExist;
  }

  Future<void> loadWallet({required String path,
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
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

    flutter_monero.bindings.load_wallet(
        pathPointer, passwordPointer, nettype, errorBoxPointer);
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    calloc.free(pathPointer);
    calloc.free(passwordPointer);

    if (0 != errorInfo.code) {
      throw WalletRestoreFromKeysException(
          message: errorInfo.getErrorMessage());
    }
  }

  void closeCurrentWallet() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    flutter_monero.bindings.close_current_wallet(errorBoxPointer);
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }
  }

  String getSecretViewKey() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    final secretViewKeyPointer = flutter_monero.bindings.secret_view_key(
        errorBoxPointer);
    final secretViewKey = secretViewKeyPointer.cast<Utf8>().toDartString();
    calloc.free(secretViewKeyPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    return secretViewKey;
  }

  String getPublicViewKey() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    final viewKeyPointer = flutter_monero.bindings.public_view_key(errorBoxPointer);
    final viewKey = viewKeyPointer.cast<Utf8>().toDartString();
    calloc.free(viewKeyPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    return viewKey;
  }

  String getSecretSpendKey() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    final secretSpendKeyPointer = flutter_monero.bindings.secret_spend_key(
        errorBoxPointer);
    final secretSpendKey = secretSpendKeyPointer.cast<Utf8>().toDartString();
    calloc.free(secretSpendKeyPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    return secretSpendKey;
  }

  String getPublicSpendKey() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    final spendKeyPointer = flutter_monero.bindings.public_spend_key(
        errorBoxPointer);
    final spendKey = spendKeyPointer.cast<Utf8>().toDartString();
    calloc.free(spendKeyPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    return spendKey;
  }

  String seed() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    final seedPointer = flutter_monero.bindings.seed(errorBoxPointer);
    final seed = seedPointer.cast<Utf8>().toDartString();
    calloc.free(seedPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    return seed;
  }

  String getFilename() {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    final filenamePointer = flutter_monero.bindings.get_filename(errorBoxPointer);
    final filename = filenamePointer.cast<Utf8>().toDartString();
    calloc.free(filenamePointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    return filename;
  }

  void setPassword({required String password}) {
    final passwordPointer = password.toNativeUtf8().cast<Char>();
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

    flutter_monero.bindings
        .set_password(passwordPointer, errorBoxPointer);
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    calloc.free(passwordPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }
  }

  void store({required String path}) {
    final pathPointer = path.toNativeUtf8().cast<Char>();
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    flutter_monero.bindings.store(pathPointer, errorBoxPointer);

    calloc.free(pathPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }
  }

  void setRecoveringFromSeed({required bool isRecovery}) {
    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    flutter_monero.bindings.set_recovering_from_seed(isRecovery, errorBoxPointer);
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }
  }
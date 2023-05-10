import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_api/sync_listener.dart';

import 'exceptions/setup_wallet_exception.dart';

import 'monero_api.dart' as monero_api;

void onStartup(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  monero_api.bindings.on_startup(errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future setupNode(
        {required String address,
        String? login,
        String? password,
        bool useSSL = false,
        bool isLightWallet = false}) =>
    compute<Map<String, Object?>, void>(_setupNodeSync, {
      'address': address,
      'login': login,
      'password': password,
      'useSSL': useSSL,
      'isLightWallet': isLightWallet
    });

bool _setupNodeSync(Map<String, Object?> args) {
  final address = args['address'] as String;
  final login = (args['login'] ?? '') as String;
  final password = (args['password'] ?? '') as String;
  final useSSL = args['useSSL'] as bool;
  final isLightWallet = args['isLightWallet'] as bool;

  return setupNodeSync(
      address: address,
      login: login,
      password: password,
      useSSL: useSSL,
      isLightWallet: isLightWallet);
}

bool setupNodeSync(
    {required String address,
    String? login,
    String? password,
    bool useSSL = false,
    bool isLightWallet = false}) {
  final addressPointer = address.toNativeUtf8().cast<Char>();
  Pointer<Char> loginPointer = (login != null)
      ? login.toNativeUtf8().cast<Char>()
      : Pointer<Char>.fromAddress(nullptr.address);
  Pointer<Char> passwordPointer = (password != null)
      ? password.toNativeUtf8().cast<Char>()
      : Pointer<Char>.fromAddress(nullptr.address);
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings.setup_node(
      addressPointer,
      loginPointer,
      passwordPointer,
      useSSL,
      isLightWallet,
      errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  calloc.free(addressPointer);

  if (loginPointer.address != nullptr.address) {
    calloc.free(loginPointer);
  }

  if (passwordPointer.address != nullptr.address) {
    calloc.free(passwordPointer);
  }

  if (0 != errorInfo.code) {
    throw SetupWalletException(message: errorInfo.getErrorMessage());
  }

  return true;
}

Future<int> getNodeHeight() => compute(_getNodeHeight, 0);

int _getNodeHeight(Object _) => getNodeHeightSync();

int getNodeHeightSync() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  int result = monero_api.bindings.get_node_height(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

SyncListener setListeners(void Function(int, int, double) onNewBlock,
    void Function() onNewTransaction) {
  final listener = SyncListener(onNewBlock, onNewTransaction);
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  monero_api.bindings.set_listener(errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return listener;
}

void connectToNode() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings.connect_to_node(errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<bool> isConnected() => compute(_isConnected, 0);

bool _isConnected(Object _) => isConnectedSync();

bool isConnectedSync(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.is_connected(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

bool isNeededToRefresh(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  var result = monero_api.bindings.is_needed_to_refresh(errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

void startRefresh(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  monero_api.bindings.start_refresh(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

void setRefreshFromBlockHeight({required int height}){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  monero_api.bindings.set_refresh_from_block_height(height, errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

void rescanBlockchain() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  monero_api.bindings.rescan_blockchain(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

void setTrustedDaemon(bool arg){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  monero_api.bindings.set_trusted_daemon(arg, errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

bool trustedDaemon(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.trusted_daemon(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

bool isNewTransactionExist() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.is_new_transaction_exist(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

int getSyncingHeight() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.get_syncing_height(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

int getCurrentHeight(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.get_current_height(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

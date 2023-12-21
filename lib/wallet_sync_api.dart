import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/exceptions/setup_wallet_exception.dart';

import 'package:monero_flutter/monero_flutter.dart' as monero_flutter;

// *****************************************************************************
// setup_node
// *****************************************************************************

/// Sets up the connection to a Monero node with the specified [address] for wallet synchronization (async version).
/// Optional parameters include [login] and [password] for authentication.
///
/// Parameters:
///   [address] - The address of the Monero node to connect to.
///   [login] - The login for authentication (optional).
///   [password] - The password for authentication (optional).
///
/// Returns:
///   A [Future] that completes with the boolean value, indicating if the setup was successful.
Future<bool> setupNode(
        {required String address, String? login, String? password}) =>
    compute(_setupNodeSync,
        {'address': address, 'login': login, 'password': password});

bool _setupNodeSync(Map<String, Object?> args) {
  final address = args['address'] as String;
  final login = (args['login'] ?? '') as String;
  final password = (args['password'] ?? '') as String;

  return setupNodeSync(address: address, login: login, password: password);
}

/// Sets up the connection to a Monero node for wallet synchronization synchronously (sync version).
///
/// Sets up the connection to a Monero node with the specified [address] for wallet synchronization synchronously.
/// Optional parameters include [login] and [password] for authentication.
///
/// Parameters:
///   [address] - The address of the Monero node to connect to.
///   [login] - The login for authentication (optional).
///   [password] - The password for authentication (optional).
///
/// Returns:
///   A boolean value indicating if the setup was successful.
bool setupNodeSync({required String address, String? login, String? password}) {
  final addressPointer = address.toNativeUtf8().cast<Char>();
  Pointer<Char> loginPointer = (login != null)
      ? login.toNativeUtf8().cast<Char>()
      : Pointer<Char>.fromAddress(nullptr.address);
  Pointer<Char> passwordPointer = (password != null)
      ? password.toNativeUtf8().cast<Char>()
      : Pointer<Char>.fromAddress(nullptr.address);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.setup_node(
      addressPointer, loginPointer, passwordPointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

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

// *****************************************************************************
// set_restore_height
// *****************************************************************************

/// Sets the restore height for a Monero wallet (async version).
///
/// This method sets the block height from which the wallet will start
/// scanning the blockchain. By specifying the [restoreHeight], it's possible
/// to avoid scanning earlier blocks, which can significantly speed up the
/// restoration process of the wallet.
///
/// The [restoreHeight] should be the block height at or before the first
/// transaction of the wallet was made. If the exact height is unknown, a
/// safe estimate should be used.
///
/// [restoreHeight] - The block height from which to start scanning.
Future setRestoreHeight(int restoreHeight) =>
    compute(_setRestoreHeightSync, {'restoreHeight': restoreHeight});

/// Sets the restore height for a Monero wallet (sync version).
///
/// This method sets the block height from which the wallet will start
/// scanning the blockchain. By specifying the [restoreHeight], it's possible
/// to avoid scanning earlier blocks, which can significantly speed up the
/// restoration process of the wallet.
///
/// The [restoreHeight] should be the block height at or before the first
/// transaction of the wallet was made. If the exact height is unknown, a
/// safe estimate should be used.
///
/// [restoreHeight] - The block height from which to start scanning.
void _setRestoreHeightSync(Map args) {
  final restoreHeight = args['restoreHeight'] as int;
  setRestoreHeightSync(restoreHeight);
}

void setRestoreHeightSync(int restoreHeight) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.set_restore_height(restoreHeight, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// start_refresh
// *****************************************************************************

/// Starts the wallet refresh process (async version).
///
/// This function initiates the wallet refresh process, which synchronizes the wallet's state
/// with the latest blockchain transactions and balances. It is necessary to call this function
/// to update the wallet's information after transactions have been made.
Future startRefresh() => compute(_startRefreshSync, {});

void _startRefreshSync(Map args) {
  startRefreshSync();
}

/// Starts the wallet refresh process (sync version).
///
/// This function initiates the wallet refresh process, which synchronizes the wallet's state
/// with the latest blockchain transactions and balances. It is necessary to call this function
/// to update the wallet's information after transactions have been made.
void startRefreshSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.start_refresh(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// stop_syncing
// *****************************************************************************

/// Stops the syncing process of the Monero wallet (async version).
///
/// This method is used to halt the ongoing synchronization of the wallet
/// with the Monero blockchain. It's particularly useful in scenarios where
/// the synchronization process needs to be interrupted due to changing
/// network conditions, user intervention, or when shutting down the wallet
/// application gracefully
Future stopSyncing() => compute(_stopSyncingSync, {});

void _stopSyncingSync(Map args) => getStartHeightSync();

/// Stops the syncing process of the Monero wallet (sync version).
///
/// This method is used to halt the ongoing synchronization of the wallet
/// with the Monero blockchain. It's particularly useful in scenarios where
/// the synchronization process needs to be interrupted due to changing
/// network conditions, user intervention, or when shutting down the wallet
/// application gracefully
void stopSyncingSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.stop_syncing(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// get_start_height
// *****************************************************************************

/// Returns the start syncing height of the wallet (async version).
Future<int> getStartHeight() => compute(_getStartHeightSync, {});

int _getStartHeightSync(Map args) => getStartHeightSync();

/// Returns the start syncing height of the wallet (sync version).
int getStartHeightSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_start_height(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

// *****************************************************************************
// get_current_height
// *****************************************************************************

/// Returns the current height of the wallet (async version).
///
/// This function retrieves the current height of the blockchain that the wallet has reached.
/// The height represents the number of blocks in the blockchain, indicating the level of
/// synchronization with the network. It returns an integer value representing the current height.
///
/// Throws an exception if there is an error while retrieving the current height.
Future<int> getCurrentHeight() => compute(_getCurrentHeightSync, {});

int _getCurrentHeightSync(Map args) {
  return getCurrentHeightSync();
}

/// Returns the current height of the wallet (sync version).
///
/// This function retrieves the current height of the blockchain that the wallet has reached.
/// The height represents the number of blocks in the blockchain, indicating the level of
/// synchronization with the network. It returns an integer value representing the current height.
///
/// Throws an exception if there is an error while retrieving the current height.
int getCurrentHeightSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final result = monero_flutter.bindings.get_current_height(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

// *****************************************************************************
// get_end_height
// *****************************************************************************

/// Retrieves the height of the connected Monero node asynchronously (async version).
///
/// Retrieves the height of the connected Monero node, which represents the current blockchain height.
///
/// Returns:
///   A [Future] that completes with an integer, representing the node height.
Future<int> getEndHeight() => compute(_getEndHeight, 0);

int _getEndHeight(Object _) => getEndHeightSync();

/// Returns the height of the Monero blockchain node, synchronously (sync version).
///
/// This function retrieves the height of the blockchain node in the Monero network
/// and returns it as an integer value. The height represents the number of blocks
/// in the blockchain, indicating the level of synchronization with the network.
int getEndHeightSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  int result = monero_flutter.bindings.get_end_height(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

// *****************************************************************************
// get_public_nodes
// *****************************************************************************

/// Retrieves a list of public nodes for the Monero network (async version).
///
/// Returns:
/// A future that resolves to a list of strings. Each string represents
/// the address of a public node on the Monero network.
///
/// Notes:
/// Ensure the wallet connection is active before calling to avoid unexpected behavior.
Future<List<String>> getPublicNodes() async =>
    compute<Map<String, Object?>, List<String>>(_getPublicNodesSync, {});

List<String> _getPublicNodesSync(Map<String, dynamic> args) {
  return getPublicNodesSync();
}

/// Retrieves a list of public nodes for the Monero network (sync version).
///
/// Returns:
/// A list of strings. Each string represents the address of a public node on the
/// Monero network.
///
/// Notes:
/// Ensure the wallet connection is active before calling to avoid unexpected behavior.
List<String> getPublicNodesSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer =
      monero_flutter.bindings.get_public_nodes(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  final result = monero_flutter.toList(resultPointer);

  return result;
}

// *****************************************************************************
// get_single_block_tx_count
// *****************************************************************************

/// Communicates with a specified node, fetches the block at the given block height,
/// and returns the count of transactions in that block (async version).
///
/// Parameters:
/// - `nodeAddress`: The address of the node to communicate with.
/// - `blockHeight`: The height of the block whose transactions count is to be retrieved.
///
/// Returns:
/// A future that resolves to an integer representing the number of transactions in the specified block.
Future getSingleBlockTxCount(String nodeAddress, int blockHeight) async =>
    compute(_getSingleBlockTxCountSync,
        {'nodeAddress': nodeAddress, 'blockHeight': blockHeight});

int _getSingleBlockTxCountSync(Map<String, dynamic> args) {
  final nodeAddress = args['nodeAddress'] as String;
  final blockHeight = args['blockHeight'] as int;

  return getSingleBlockTxCountSync(nodeAddress, blockHeight);
}

/// Communicates with a specified node, fetches the block at the given block height,
/// and returns the count of transactions in that block (sync version).
///
/// Parameters:
/// - `nodeAddress`: The address of the node to communicate with.
/// - `blockHeight`: The height of the block whose transactions count is to be retrieved.
///
/// Returns:
/// An integer, representing the number of transactions in the specified block.
int getSingleBlockTxCountSync(String nodeAddress, int blockHeight) {
  final nodeAddressPointer = nodeAddress.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_single_block_tx_count(
      nodeAddressPointer, blockHeight, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(nodeAddressPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

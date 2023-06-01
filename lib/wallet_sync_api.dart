import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/sync_listener.dart';

import 'exceptions/setup_wallet_exception.dart';
import 'monero_flutter.dart' as monero_flutter;

void onStartup() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.on_startup(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Sets up the connection to a Monero node with the specified [address] for wallet synchronization (async version).
/// Optional parameters include [login] and [password] for authentication,
/// [useSSL] to enable SSL/TLS encryption, and [isLightWallet] to indicate if it's a light wallet.
///
/// Parameters:
///   [address] - The address of the Monero node to connect to.
///   [login] - The login for authentication (optional).
///   [password] - The password for authentication (optional).
///   [useSSL] - Whether to use SSL/TLS encryption (default is false).
///   [isLightWallet] - Whether it's a light wallet (default is false).
///
/// Returns:
///   A [Future] that completes with no result.
Future setupNode(
        {required String address, String? login, String? password, bool useSSL = false, bool isLightWallet = false}) =>
    compute<Map<String, Object?>, void>(_setupNodeSync,
        {'address': address, 'login': login, 'password': password, 'useSSL': useSSL, 'isLightWallet': isLightWallet});

bool _setupNodeSync(Map<String, Object?> args) {
  final address = args['address'] as String;
  final login = (args['login'] ?? '') as String;
  final password = (args['password'] ?? '') as String;
  final useSSL = args['useSSL'] as bool;
  final isLightWallet = args['isLightWallet'] as bool;

  return setupNodeSync(
      address: address, login: login, password: password, useSSL: useSSL, isLightWallet: isLightWallet);
}

/// Sets up the connection to a Monero node for wallet synchronization synchronously (sync version).
///
/// Sets up the connection to a Monero node with the specified [address] for wallet synchronization synchronously.
/// Optional parameters include [login] and [password] for authentication,
/// [useSSL] to enable SSL/TLS encryption, and [isLightWallet] to indicate if it's a light wallet.
///
/// Parameters:
///   [address] - The address of the Monero node to connect to.
///   [login] - The login for authentication (optional).
///   [password] - The password for authentication (optional).
///   [useSSL] - Whether to use SSL/TLS encryption (default is false).
///   [isLightWallet] - Whether it's a light wallet (default is false).
///
/// Returns:
///   A boolean value indicating if the setup was successful.
bool setupNodeSync(
    {required String address, String? login, String? password, bool useSSL = false, bool isLightWallet = false}) {
  final addressPointer = address.toNativeUtf8().cast<Char>();
  Pointer<Char> loginPointer =
      (login != null) ? login.toNativeUtf8().cast<Char>() : Pointer<Char>.fromAddress(nullptr.address);
  Pointer<Char> passwordPointer =
      (password != null) ? password.toNativeUtf8().cast<Char>() : Pointer<Char>.fromAddress(nullptr.address);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings
      .setup_node(addressPointer, loginPointer, passwordPointer, useSSL, isLightWallet, errorBoxPointer);
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

/// Retrieves the height of the connected Monero node asynchronously (async version).
///
/// Retrieves the height of the connected Monero node, which represents the current blockchain height.
///
/// Returns:
///   A [Future] that completes with an integer representing the node height.
Future<int> getNodeHeight() => compute(_getNodeHeight, 0);

int _getNodeHeight(Object _) => getNodeHeightSync();

/// Returns the height of the Monero blockchain node, synchronously (sync version).
///
/// This function retrieves the height of the blockchain node in the Monero network
/// and returns it as an integer value. The height represents the number of blocks
/// in the blockchain, indicating the level of synchronization with the network.
int getNodeHeightSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  int result = monero_flutter.bindings.get_node_height(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Sets the listeners for the Monero wallet synchronization events. Call methods https://github.com/awaik/monero_flutter/blob/sample/lib/sync_listener.dart
///
/// [onNewBlock] is a callback function that takes three parameters:
/// - [int]: The current block height.
/// - [int]: The total number of blocks to be synchronized.
/// - [double]: The progress of the synchronization as a value between 0 and 1.
/// This function will be called when a new block is received during synchronization.
///
/// [onNewTransaction] is a callback function that takes no parameters.
/// This function will be called when a new transaction is received during synchronization.
///
/// Returns a [SyncListener] object.
SyncListener setListeners(void Function(int, int, double) onNewBlock, void Function() onNewTransaction) {
  final listener = SyncListener(onNewBlock, onNewTransaction);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.set_listener(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return listener;
}

/// Connects to the Monero blockchain node.
///
/// This function establishes a connection to a Monero blockchain node
/// in order to interact with the Monero network. Once connected, you can
/// perform various operations such as retrieving information or sending transactions.
void connectToNode() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.connect_to_node(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Checks if the wallet is connected to a Monero blockchain node.
///
/// This function verifies whether the wallet is currently connected
/// to a Monero blockchain node in the network. It returns a boolean
/// value indicating the connection status.
///
/// Returns true if the wallet is connected to a node, false otherwise.
Future<bool> isConnected() => compute(_isConnected, 0);

bool _isConnected(Object _) => isConnectedSync();

/// Checks if the wallet is connected to a Monero blockchain node synchronously.
///
/// This function verifies whether the wallet is currently connected
/// to a Monero blockchain node in the network. It returns a boolean
/// value indicating the connection status.
///
/// Returns true if the wallet is connected to a node, false otherwise.
bool isConnectedSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.is_connected(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Checks if the wallet needs to be refreshed.
///
/// This function checks whether the wallet requires a refresh. A refresh is typically
/// performed to synchronize the wallet's state with the latest blockchain transactions
/// and balances. It returns a boolean value indicating whether a refresh is needed.
///
/// Returns true if the wallet needs to be refreshed, false otherwise.
bool isNeededToRefresh() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.is_needed_to_refresh(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Starts the wallet refresh process.
///
/// This function initiates the wallet refresh process, which synchronizes the wallet's state
/// with the latest blockchain transactions and balances. It is necessary to call this function
/// to update the wallet's information after transactions have been made.
void startRefresh() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.start_refresh(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Pauses the wallet refresh process.
///
/// This function pauses the wallet refresh process, which temporarily halts the synchronization
/// of the wallet's state with the latest blockchain transactions and balances. Pausing the refresh
/// process can be useful in situations where you want to conserve system resources or perform
/// other tasks without interruption.
void pauseRefresh() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.pause_refresh(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Sets the refresh starting block height for the wallet.
///
/// This function sets the block height from which the wallet should start the refresh process.
/// By specifying the height, the wallet will synchronize its state with the blockchain transactions
/// starting from the specified block. This can be useful in situations where you want to refresh
/// the wallet from a specific point in the blockchain.
void setRefreshFromBlockHeight({required int height}) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.set_refresh_from_block_height(height, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Initiates a blockchain rescan for the wallet.
///
/// This function triggers a rescan of the blockchain for the wallet, which reevaluates
/// the wallet's state by scanning all blockchain transactions. This can be useful in situations
/// where you suspect that some transactions might have been missed or the wallet's state is not
/// up to date.
void rescanBlockchain() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.rescan_blockchain(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Sets the trusted daemon status for the wallet.
///
/// This function sets the trusted daemon status for the wallet. When the trusted daemon is enabled,
/// the wallet will only connect to specified trusted nodes for blockchain synchronization. This can
/// provide an additional layer of security by avoiding connections to potentially malicious nodes.
void setTrustedDaemon(bool arg) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.set_trusted_daemon(arg, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Returns the trusted daemon status for the wallet.
///
/// Returns true if the wallet is set to use a trusted daemon, false otherwise.
bool trustedDaemon() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.trusted_daemon(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Checks if there are new transactions for the wallet.
///
/// This function checks whether there are any new transactions for the wallet
/// that have not been processed yet. It returns a boolean value indicating whether
/// new transactions exist.
///
/// Returns true if new transactions exist, false otherwise.
bool isNewTransactionExist() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.is_new_transaction_exist(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Returns the current syncing height of the wallet.
///
/// This function retrieves the height of the blockchain that the wallet is currently syncing to.
/// The syncing height represents the progress of the wallet's synchronization with the blockchain.
/// It returns an integer value representing the current syncing height.
///
/// Throws an exception if there is an error while retrieving the syncing height.
int getSyncingHeight() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_syncing_height(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Returns the current height of the wallet.
///
/// This function retrieves the current height of the blockchain that the wallet has reached.
/// The height represents the number of blocks in the blockchain, indicating the level of
/// synchronization with the network. It returns an integer value representing the current height.
///
/// Throws an exception if there is an error while retrieving the current height.
int getCurrentHeight() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_current_height(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

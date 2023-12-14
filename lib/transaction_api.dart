import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'package:monero_flutter/monero_flutter.dart' as monero_flutter;

// *****************************************************************************
// get_address
// *****************************************************************************

/// Retrieves the default address of the currently opened Monero wallet (async version).
///
/// Returns:
///   A [Future] that completes with the address as a [String].
Future<String> getAddress({int accountIndex = 0, int addressIndex = 0}) =>
    compute(_getAddressSync, {});

String _getAddressSync(Map args) => getAddressSync();

/// Retrieves the default address of the currently opened Monero wallet (sync version).
///
/// Returns:
///   The address as a string.
String getAddressSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final addressPointer = monero_flutter.bindings
      .get_address(errorBoxPointer);

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return address;
}

// *****************************************************************************
// get_receive_address
// *****************************************************************************

/// Retrieves the receive address for the wallet. A new address is generated
/// after an output is received at the old address (async version).
///
/// Description:
/// The receive address is a subaddress belonging to account 0. If no subaddresses
/// have been manually created using `.createSubaddress()`, the next unused
/// subaddress will be returned. The subaddresses list is updated automatically
/// when an output is received by a subaddress or when `.addSubaddress()` is called.
///
/// Returns:
///   A [Future] that completes with the string, representing the receive address.
Future<String> getReceiveAddress({int accountIndex = 0, int addressIndex = 0}) =>
    compute(_getReceiveAddressSync, {});

String _getReceiveAddressSync(Map args) => getReceiveAddressSync();

/// Retrieves the receive address for the wallet. A new address is generated
/// after an output is received at the old address (sync version).
///
/// Description:
/// The receive address is a subaddress belonging to account 0. If no subaddresses
/// have been manually created using `.createSubaddress()`, the next unused
/// subaddress will be returned. The subaddresses list is updated automatically
/// when an output is received by a subaddress or when `.addSubaddress()` is called.
///
/// Returns:
///   A string representing the receive address.
String getReceiveAddressSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final addressPointer = monero_flutter.bindings
      .get_receive_address(errorBoxPointer);

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return address;
}

// *****************************************************************************
// get_confirmed_balance
// *****************************************************************************

/// Retrieves the total balance of the currently opened Monero wallet (async version).
///
/// Returns:
///   A [Future] that completes with the total balance of the account as an integer.
Future<int> getConfirmedBalance() =>
    compute(_getConfirmedBalanceSync, {});

int _getConfirmedBalanceSync(Map args) {
  return getConfirmedBalanceSync();
}

/// Retrieves the total balance of the currently opened Monero wallet (sync version).
///
/// Returns:
///   The total balance of the account as an integer.
int getConfirmedBalanceSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result =
  monero_flutter.bindings.get_confirmed_balance(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

// *****************************************************************************
// get_all_transactions_json
// *****************************************************************************

/// Retrieves all transfers as JSON (async version).
///
/// This function retrieves all transfers made by the wallet and returns them as a JSON string.
/// Each transfer represents a transaction involving the wallet, including both incoming and outgoing transfers.
///
/// Returns a [Future] that completes with the JSON string, containing all transfers.
Future<String> getAllTransfersAsJson() => compute(_getAllTransfersAsJsonSync, {});

String _getAllTransfersAsJsonSync(Map args) {
  return getAllTransfersAsJsonSync();
}

/// Retrieves all transfers as JSON (sync version).
///
/// This function retrieves all transfers made by the wallet and returns them as a JSON string.
/// Each transfer represents a transaction involving the wallet, including both incoming and outgoing transfers.
///
/// Returns a JSON string containing all transfers.
String getAllTransfersAsJsonSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.get_all_transactions_json(errorBoxPointer);
  final result = resultPointer.cast<Utf8>().toDartString();

  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

// *****************************************************************************
// get_utxos_json
// *****************************************************************************

/// Retrieves a list of all unspent transaction outputs (UTXOs) in JSON-form (async version).
Future<String> getUtxosAsJson() => compute(_getUtxosAsJsonSync, {});

String _getUtxosAsJsonSync(Map args) {
  return getUtxosAsJsonSync();
}

/// Retrieves a list of all unspent transaction outputs (UTXOs) in JSON-form (sync version).
String getUtxosAsJsonSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.get_utxos_json(errorBoxPointer);

  final jsonString = monero_flutter.extractString(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return jsonString!;
}

// *****************************************************************************
// thaw
// *****************************************************************************

/// Thaw a frozen output (async version).
///
/// Parameters:
///    [keyImage] - key image of the output to thaw.
Future thaw(String keyImage) => compute(_thawSync, {'keyImage': keyImage});

void _thawSync(Map args) {
  final keyImage = args['keyImage'] as String;
  thawSync(keyImage);
}

/// Thaw a frozen output (sync version).
///
/// Parameters:
///    [keyImage] - key image of the output to thaw.
void thawSync(String keyImage) {
  final keyImagePointer = keyImage.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.thaw(keyImagePointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// freeze
// *****************************************************************************

/// Freeze an output (async version).
///
/// Parameters:
///    [keyImage] - key image of the output to thaw.
Future freeze(String keyImage) => compute(_freezeSync, {'keyImage': keyImage});

void _freezeSync(Map args) {
  final keyImage = args['keyImage'] as String;
  freezeSync(keyImage);
}

/// Freeze an output (sync version).
///
/// Parameters:
///    [keyImage] - key image of the output to thaw.
void freezeSync(String keyImage) {
  final keyImagePointer = keyImage.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.freeze(keyImagePointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

// *****************************************************************************
// create_transaction
// *****************************************************************************

/// Creates a new transaction in JSON-format, specifying the extended info (async version).
///
/// To send a transaction to the network, use the [relayTransaction] function.
Future<String> createExtendedTransactionAsJson(String txConfigJson) =>
    compute(_createExtendedTransactionAsJsonSync, {'txConfigJson': txConfigJson});

String _createExtendedTransactionAsJsonSync(Map args) {
  final txConfigJson = args['txConfigJson'] as String;
  return createExtendedTransactionAsJsonSync(txConfigJson);
}

/// Creates a new transaction in JSON-format, specifying the extended info (sync version).
///
/// To send a transaction to the network, use the [relayTransactionSync] function.
String createExtendedTransactionAsJsonSync(String txConfigJson)
{
  final txConfigJsonPointer = txConfigJson.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer = monero_flutter.bindings.create_transaction(txConfigJsonPointer, errorBoxPointer);

  calloc.free(txConfigJsonPointer);

  final result = monero_flutter.extractString(resultPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

// *****************************************************************************
// describe_tx_set
// *****************************************************************************

/// Describe a tx set from multisig or unsigned tx hex in JSON-format (async version).
///
/// Parameters:
///   [jsonRequest] - multisig or unsigned tx hex in JSON-format.
///     Example of unsigned tx hex in JSON-format: { "unsignedTxHex": "28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}
///     Example of multisig tx hex in JSON-format: { "multisigTxHex": "28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}
///
/// Returns a [Future] that completes with the the tx set in JSON-format, containing structured transactions.
Future<String> describeTxSetAsJson(String jsonRequest) =>
    compute(_describeTxSetAsJsonSync, {'jsonRequest': jsonRequest});

String _describeTxSetAsJsonSync(Map args) {
  final jsonRequest = args['jsonRequest'] as String;
  return describeTxSetAsJsonSync(jsonRequest);
}

/// Describe a tx set from multisig or unsigned tx hex in JSON-format (sync version).
///
/// Parameters:
///   [jsonRequest] - multisig or unsigned tx hex in JSON-format.
///     Example of unsigned tx hex in JSON-format: { "unsignedTxHex": "28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}
///     Example of multisig tx hex in JSON-format: { "multisigTxHex": "28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}
///
/// Returns the tx set in JSON-format, containing structured transactions.
String describeTxSetAsJsonSync(String jsonRequest) {
  final jsonRequestPointer = jsonRequest.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.describe_tx_set(jsonRequestPointer, errorBoxPointer);

  final result = monero_flutter.extractString(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}
import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/entities/outputs_response.dart';
import 'package:monero_flutter/entities/txs_request.dart';

import 'entities/describe_tx_request.dart';
import 'entities/describe_tx_response.dart';
import 'entities/monero_output.dart';
import 'entities/outputs_request.dart';
import 'entities/pending_transaction.dart';
import 'entities/sweep_unlocked_request.dart';
import 'entities/sweep_unlocked_response.dart';
import 'entities/transaction_info_row.dart';
import 'entities/txs_response.dart';
import 'exceptions/creation_transaction_exception.dart';
import 'monero_flutter.dart' as monero_flutter;
import 'monero_flutter_bindings_generated.dart';

/// Initiates a refresh of the wallet's transactions.
///
/// This function triggers a refresh of the wallet's transaction history,
/// synchronizing it with the latest transactions on the blockchain. It is
/// useful to call this function when you want to update the wallet's transaction
/// data after new transactions have been made.
void transactionsRefresh() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.transactions_refresh(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Returns the count of transactions in the wallet.
///
/// This function retrieves the total number of transactions stored in the wallet.
///
/// Returns an integer value representing the count of transactions.
int transactionsCount() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.transactions_count(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves all transactions stored in the wallet.
///
/// This function retrieves all transactions stored in the wallet and returns them
/// as a list of [TransactionInfoRow] objects. Each [TransactionInfoRow] object represents
/// a single transaction with its associated details such as amount, date, sender, and recipient.
List<TransactionInfoRow> getAllTransactions() {
  final size = transactionsCount();

  if (0 == size) {
    return [];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final transactionsPointer =
      monero_flutter.bindings.transactions_get_all(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  final transactionsAddresses = transactionsPointer.asTypedList(size);

  var result = transactionsAddresses
      .map((addr) => Pointer<ExternalTransactionInfoRow>.fromAddress(addr).ref.buildTransactionInfoRow())
      .toList();

  monero_flutter.bindings.free_block_of_transactions(transactionsPointer, size);

  return result;
}

/// Creates a new transaction asynchronously.
///
/// This function creates a new transaction to send funds to the specified address.
/// It returns a [Future] that resolves to a [PendingTransactionDescription] object,
/// which contains information about the created transaction.
///
/// Parameters:
/// - address: The destination address for the transaction.
/// - priorityRaw: The priority for the transaction, represented as an integer value.
/// - amount: (Optional) The amount to send in the transaction. If not specified, the entire balance will be sent.
/// - paymentId: (Optional) The payment ID associated with the transaction.
/// - accountIndex: (Optional) The index of the account to use for the transaction. Default is 0.
Future<PendingTransactionDescription> createTransaction(
        {required String address,
        required int priorityRaw,
        String? amount,
        String paymentId = '',
        int accountIndex = 0}) =>
    compute(_createTransactionSync, {
      'address': address,
      'paymentId': paymentId,
      'amount': amount,
      'priorityRaw': priorityRaw,
      'accountIndex': accountIndex
    });

PendingTransactionDescription _createTransactionSync(Map args) {

  final address = args['address'] as String;
  final paymentId = args['paymentId'] as String;
  final amount = args['amount'] as String?;
  final priorityRaw = args['priorityRaw'] as int;
  final accountIndex = args['accountIndex'] as int;

  return createTransactionSync(
      address: address,
      paymentId: paymentId,
      amount: amount,
      priorityRaw: priorityRaw,
      subaddrAccount: accountIndex);
}

/// Creates a new transaction synchronously.
///
/// This function creates a new transaction to send funds to the specified address.
/// It returns a [PendingTransactionDescription] object that contains information about
/// the created transaction.
///
/// Parameters:
/// - address: The destination address for the transaction.
/// - amount: (Optional) The amount to send in the transaction. If not specified, the entire balance will be sent.
/// - paymentId: (Optional) The payment ID associated with the transaction.
/// - priorityRaw: The priority for the transaction, represented as an integer value.
/// - subaddrAccount: (Optional) The index of the subaddress account to use for the transaction. Default is 0.
PendingTransactionDescription createTransactionSync(
    {required String address,
    String? amount,
    String paymentId = '',
    int priorityRaw = 1,
    int subaddrAccount = 0}) {

  final addressPointer = address.toNativeUtf8().cast<Char>();
  final amountPointer = null != amount
      ? amount.toNativeUtf8().cast<Char>()
      : nullptr;
  final paymentIdPointer = paymentId.toNativeUtf8().cast<Char>();
  final pendingTransactionPointer = calloc<ExternPendingTransactionRaw>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.transaction_create(
      addressPointer,
      paymentIdPointer,
      amountPointer,
      priorityRaw,
      subaddrAccount,
      pendingTransactionPointer,
      errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  calloc.free(addressPointer);

  if (amountPointer != nullptr) {
    calloc.free(amountPointer);
  }

  calloc.free(paymentIdPointer);

  if (0 != errorInfo.code) {
    calloc.free(pendingTransactionPointer);
    throw CreationTransactionException(message: errorInfo.getErrorMessage());
  }

  final pendingTransactionDescription = _buildPendingTransactionDescription(
      pendingTransactionPointer);

  return pendingTransactionDescription;
}

/// Creates a new transaction with multiple destinations asynchronously.
///
/// This function creates a new transaction with multiple destinations using the specified outputs.
/// It returns a [Future] that resolves to a [PendingTransactionDescription] object, which contains
/// information about the created transaction.
///
/// Parameters:
/// - outputs: A list of [MoneroOutput] objects representing the destination addresses and amounts.
/// - priorityRaw: The priority for the transaction, represented as an integer value.
/// - paymentId: (Optional) The payment ID associated with the transaction.
/// - accountIndex: (Optional) The index of the account to use for the transaction. Default is 0.
Future<PendingTransactionDescription> createTransactionMultDest(
        {required List<MoneroOutput> outputs,
        required int priorityRaw,
        String paymentId = '',
        int accountIndex = 0}) =>
    compute(_createTransactionMultDestSync, {
      'outputs': outputs,
      'paymentId': paymentId,
      'priorityRaw': priorityRaw,
      'accountIndex': accountIndex
    });

PendingTransactionDescription _createTransactionMultDestSync(Map args) {
  final outputs = args['outputs'] as List<MoneroOutput>;
  final paymentId = args['paymentId'] as String;
  final priorityRaw = args['priorityRaw'] as int;
  final accountIndex = args['accountIndex'] as int;

  return createTransactionMultDestSync(
      outputs: outputs,
      paymentId: paymentId,
      priorityRaw: priorityRaw,
      accountIndex: accountIndex);
}

/// Creates a new transaction with multiple destinations synchronously.
///
/// This function creates a new transaction with multiple destinations using the specified outputs.
/// It returns a [PendingTransactionDescription] object that contains information about the created transaction.
///
/// Parameters:
/// - outputs: A list of [MoneroOutput] objects representing the destination addresses and amounts.
/// - paymentId: (Optional) The payment ID associated with the transaction.
/// - priorityRaw: The priority for the transaction, represented as an integer value.
/// - accountIndex: (Optional) The index of the account to use for the transaction. Default is 0.
PendingTransactionDescription createTransactionMultDestSync(
    {required List<MoneroOutput> outputs,
    required String paymentId,
    required int priorityRaw,
    int accountIndex = 0}) {

  final int size = outputs.length;
  final List<Pointer<Char>> addressesPointers = outputs
      .map((output) => output.address.toNativeUtf8().cast<Char>())
      .toList();
  final Pointer<Pointer<Char>> addressesPointerPointer = calloc(size);
  final List<Pointer<Char>> amountsPointers = outputs
      .map((output) => output.amount.toNativeUtf8().cast<Char>())
      .toList();
  final Pointer<Pointer<Char>> amountsPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    addressesPointerPointer[i] = addressesPointers[i];
    amountsPointerPointer[i] = amountsPointers[i];
  }

  final paymentIdPointer = paymentId.toNativeUtf8().cast<Char>();
  final pendingTransactionPointer = calloc<ExternPendingTransactionRaw>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.transaction_create_mult_dest(
      addressesPointerPointer,
      paymentIdPointer,
      amountsPointerPointer,
      size,
      priorityRaw,
      accountIndex,
      pendingTransactionPointer,
      errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  for (var element in addressesPointers) {
    calloc.free(element);
  }
  for (var element in amountsPointers) {
    calloc.free(element);
  }

  calloc.free(addressesPointerPointer);
  calloc.free(amountsPointerPointer);

  calloc.free(paymentIdPointer);

  if (0 != errorInfo.code) {
    calloc.free(pendingTransactionPointer);

    throw CreationTransactionException(message: errorInfo.getErrorMessage());
  }

  final pendingTransactionDescription = _buildPendingTransactionDescription(
      pendingTransactionPointer);

  return pendingTransactionDescription;
}

PendingTransactionDescription _buildPendingTransactionDescription(Pointer<ExternPendingTransactionRaw> pendingTransactionPointer){
  final pendingTransactionDescription = PendingTransactionDescription(
      amount: pendingTransactionPointer.ref.amount,
      fee: pendingTransactionPointer.ref.fee,
      hash: pendingTransactionPointer.ref.hash.cast<Utf8>().toDartString(),
      hex: pendingTransactionPointer.ref.hex.cast<Utf8>().toDartString(),
      txKey: pendingTransactionPointer.ref.tx_key.cast<Utf8>().toDartString(),
      multisigSignData: pendingTransactionPointer.ref.multisig_sign_data
          .cast<Utf8>()
          .toDartString(),
      pointerAddress: pendingTransactionPointer.address);

  calloc.free(pendingTransactionPointer.ref.hash);
  calloc.free(pendingTransactionPointer.ref.hex);
  calloc.free(pendingTransactionPointer.ref.tx_key);
  calloc.free(pendingTransactionPointer.ref.multisig_sign_data);
  calloc.free(pendingTransactionPointer);

  return pendingTransactionDescription;
}

/// Commits a pending transaction.
///
/// This function commits a pending transaction represented by the transactionDescription
/// parameter. It finalizes the transaction and sends the funds to the specified destinations.
/// The transactionDescription parameter should be a [PendingTransactionDescription] object
/// obtained from the createTransaction or createTransactionMultDest functions.
void transactionCommit(PendingTransactionDescription transactionDescription) {
  final pendingTransactionPointer =
      Pointer<ExternPendingTransactionRaw>.fromAddress(
          transactionDescription.pointerAddress);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings
      .transaction_commit(pendingTransactionPointer, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw CreationTransactionException(message: errorInfo.getErrorMessage());
  }
}

/// Retrieves the transaction key for a transaction.
///
/// This function retrieves the transaction key for the specified transactionId.
/// The transaction key is a unique identifier associated with a transaction, and it
/// can be used for various purposes such as verifying the transaction's authenticity
/// or performing further operations on the transaction.
///
/// Parameters:
/// - transactionId: The ID of the transaction for which to retrieve the transaction key.
String getTransactionKey(String transactionId) {
  Pointer<Char> transactionIdPointer =
      transactionId.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer =
      monero_flutter.bindings.get_tx_key(transactionIdPointer, errorBoxPointer);

  final result = monero_flutter.extractString(resultPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

OutputsResponse getUtxos()
{
  OutputsRequest request = OutputsRequest(isSpent: false, txQuery: OutputsRequestTxQuery(isLocked: false, isConfirmed: false));
  return getOutputs(request);
}

OutputsResponse getOutputs(OutputsRequest request)
{
  final jsonRequest = jsonEncode(request.toJson());
  final jsonResponse = getOutputsAsJson(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return OutputsResponse.fromJson(jsonMapResponse);
}

String getOutputsAsJson(String jsonRequest)
{
  final jsonRequestPointer = jsonRequest.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.get_outputs(jsonRequestPointer, errorBoxPointer);

  final jsonString = monero_flutter.extractString(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return jsonString!;
}

TxsResponse getTxs(TxsRequest request)
{
  final jsonRequest = jsonEncode(request.toJson());
  final jsonResponse = getTxsAsJson(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return TxsResponse.fromJson(jsonMapResponse);
}

// {
// "txs": [{"hash":"28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}]
// }
String getTxsAsJson(String jsonRequest) {
  final jsonRequestPointer = jsonRequest.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.get_txs(jsonRequestPointer, errorBoxPointer);

  final result = monero_flutter.extractString(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

DescribeTxResponse describeTxSet(DescribeTxRequest describeTxRequest) {
  final jsonRequest = describeTxRequest.toJsonString();
  final jsonResponse = describeTxSetAsJson(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return DescribeTxResponse.fromJson(jsonMapResponse);
}

// {
// "unsignedTxHex": "28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"
// }
// =================
// {
// "multisigTxHex": "28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"
// }
String describeTxSetAsJson(String jsonRequest) {
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

SweepUnlockedResponse sweepUnlocked(SweepUnlockedRequest request)
{
  final jsonRequest = jsonEncode(request.toJson());
  final jsonResponse = sweepUnlockedAsJson(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return SweepUnlockedResponse.fromJson(jsonMapResponse);
}

// {
// "destinations": [{"address":"86gwCboZti2hRP4m6pwFfVHwjtdptJVgFKhppuEQL6f2aJZZuJVaPzqK16NBfxWvPnFNDgKtAkptJPa1UCX1BnnUQsogxqA"}]
// }
String sweepUnlockedAsJson(String jsonRequest) {
  final jsonRequestPointer = jsonRequest.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.sweep_unlocked(jsonRequestPointer, errorBoxPointer);

  final result = monero_flutter.extractString(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

void thaw(String keyImage) {
  final keyImagePointer = keyImage.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.thaw(keyImagePointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

void freeze(String keyImage) {
  final keyImagePointer = keyImage.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.freeze(keyImagePointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

bool isFrozen(String keyImage) {
  final keyImagePointer = keyImage.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  bool result = monero_flutter.bindings.frozen(keyImagePointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves all transfers as JSON.
///
/// This function retrieves all transfers made by the wallet and returns them as a JSON string.
/// Each transfer represents a transaction involving the wallet, including both incoming and outgoing transfers.
///
/// Returns a JSON string containing all transfers.
String getAllTransfersAsJson() {

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.get_transfers(errorBoxPointer);
  final result = resultPointer.cast<Utf8>().toDartString();

  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

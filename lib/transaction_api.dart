import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/entities/outputs_response.dart';
import 'package:monero_flutter/entities/txs_request.dart';

import 'entities/create_transaction_request.dart';
import 'entities/create_transaction_response.dart';
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

export 'entities/outputs_request.dart';

/// Initiates a refresh of the wallet's transactions (async version).
///
/// This function triggers a refresh of the wallet's transaction history,
/// synchronizing it with the latest transactions on the blockchain. It is
/// useful to call this function when you want to update the wallet's transaction
/// data after new transactions have been made.
Future transactionsRefresh() => compute(_transactionsRefreshSync, {});

void _transactionsRefreshSync(Map args) => transactionsRefreshSync();

/// Initiates a refresh of the wallet's transactions (sync version).
///
/// This function triggers a refresh of the wallet's transaction history,
/// synchronizing it with the latest transactions on the blockchain. It is
/// useful to call this function when you want to update the wallet's transaction
/// data after new transactions have been made.
void transactionsRefreshSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.transactions_refresh(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Returns the count of transactions in the wallet (async version).
///
/// This function retrieves the total number of transactions stored in the wallet.
///
/// Returns a [Future] that completes with the integer value, representing the count of transactions.
Future<int> transactionsCount() => compute(_transactionsCountSync, {});

int _transactionsCountSync(Map args) => transactionsCountSync();

/// Returns the count of transactions in the wallet (sync version).
///
/// This function retrieves the total number of transactions stored in the wallet.
///
/// Returns an integer value representing the count of transactions.
int transactionsCountSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.transactions_count(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves all transactions stored in the wallet (async version).
///
/// This function retrieves all transactions stored in the wallet and returns them
/// as a list of [TransactionInfoRow] objects. Each [TransactionInfoRow] object represents
/// a single transaction with its associated details such as amount, date, sender, and recipient.
Future<List<TransactionInfoRow>> getAllTransactions() => compute(_getAllTransactionsSync, {});

List<TransactionInfoRow> _getAllTransactionsSync(Map args) => getAllTransactionsSync();

/// Retrieves all transactions stored in the wallet (sync version).
///
/// This function retrieves all transactions stored in the wallet and returns them
/// as a list of [TransactionInfoRow] objects. Each [TransactionInfoRow] object represents
/// a single transaction with its associated details such as amount, date, sender, and recipient.
List<TransactionInfoRow> getAllTransactionsSync() {
  final size = transactionsCountSync();

  if (0 == size) {
    return [];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final transactionsPointer = monero_flutter.bindings.transactions_get_all(errorBoxPointer);

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

/// Creates a new transaction asynchronously (async version).
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
      address: address, paymentId: paymentId, amount: amount, priorityRaw: priorityRaw, subaddrAccount: accountIndex);
}

/// Creates a new transaction synchronously (sync version).
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
    {required String address, String? amount, String paymentId = '', int priorityRaw = 1, int subaddrAccount = 0}) {
  final addressPointer = address.toNativeUtf8().cast<Char>();
  final amountPointer = null != amount ? amount.toNativeUtf8().cast<Char>() : nullptr;
  final paymentIdPointer = paymentId.toNativeUtf8().cast<Char>();
  final pendingTransactionPointer = calloc<ExternPendingTransactionRaw>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.transaction_create(addressPointer, paymentIdPointer, amountPointer, priorityRaw,
      subaddrAccount, pendingTransactionPointer, errorBoxPointer);

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

  final pendingTransactionDescription = _buildPendingTransactionDescription(pendingTransactionPointer);

  return pendingTransactionDescription;
}

/// Creates a new transaction with multiple destinations asynchronously (async version).
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
        {required List<MoneroOutput> outputs, required int priorityRaw, String paymentId = '', int accountIndex = 0}) =>
    compute(_createTransactionMultDestSync,
        {'outputs': outputs, 'paymentId': paymentId, 'priorityRaw': priorityRaw, 'accountIndex': accountIndex});

PendingTransactionDescription _createTransactionMultDestSync(Map args) {
  final outputs = args['outputs'] as List<MoneroOutput>;
  final paymentId = args['paymentId'] as String;
  final priorityRaw = args['priorityRaw'] as int;
  final accountIndex = args['accountIndex'] as int;

  return createTransactionMultDestSync(
      outputs: outputs, paymentId: paymentId, priorityRaw: priorityRaw, accountIndex: accountIndex);
}

/// Creates a new transaction with multiple destinations synchronously (sync version).
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
    {required List<MoneroOutput> outputs, required String paymentId, required int priorityRaw, int accountIndex = 0}) {
  final int size = outputs.length;
  final List<Pointer<Char>> addressesPointers =
      outputs.map((output) => output.address.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> addressesPointerPointer = calloc(size);
  final List<Pointer<Char>> amountsPointers =
      outputs.map((output) => output.amount.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> amountsPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    addressesPointerPointer[i] = addressesPointers[i];
    amountsPointerPointer[i] = amountsPointers[i];
  }

  final paymentIdPointer = paymentId.toNativeUtf8().cast<Char>();
  final pendingTransactionPointer = calloc<ExternPendingTransactionRaw>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.transaction_create_mult_dest(addressesPointerPointer, paymentIdPointer, amountsPointerPointer,
      size, priorityRaw, accountIndex, pendingTransactionPointer, errorBoxPointer);

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

  final pendingTransactionDescription = _buildPendingTransactionDescription(pendingTransactionPointer);

  return pendingTransactionDescription;
}

PendingTransactionDescription _buildPendingTransactionDescription(
    Pointer<ExternPendingTransactionRaw> pendingTransactionPointer) {
  final pendingTransactionDescription = PendingTransactionDescription(
      amount: pendingTransactionPointer.ref.amount,
      fee: pendingTransactionPointer.ref.fee,
      hash: pendingTransactionPointer.ref.hash.cast<Utf8>().toDartString(),
      hex: pendingTransactionPointer.ref.hex.cast<Utf8>().toDartString(),
      txKey: pendingTransactionPointer.ref.tx_key.cast<Utf8>().toDartString(),
      multisigSignData: pendingTransactionPointer.ref.multisig_sign_data.cast<Utf8>().toDartString(),
      pointerAddress: pendingTransactionPointer.address);

  calloc.free(pendingTransactionPointer.ref.hash);
  calloc.free(pendingTransactionPointer.ref.hex);
  calloc.free(pendingTransactionPointer.ref.tx_key);
  calloc.free(pendingTransactionPointer.ref.multisig_sign_data);
  calloc.free(pendingTransactionPointer);

  return pendingTransactionDescription;
}

/// Commits a pending transaction (async version).
///
/// This function commits a pending transaction represented by the transactionDescription
/// parameter. It finalizes the transaction and sends the funds to the specified destinations.
/// The transactionDescription parameter should be a [PendingTransactionDescription] object
/// obtained from the createTransaction or createTransactionMultDest functions.
Future transactionCommit(PendingTransactionDescription transactionDescription) =>
    compute(_transactionCommitSync, {'transactionDescription': transactionDescription});

void _transactionCommitSync(Map args) {
  final transactionDescription = args['transactionDescription'] as PendingTransactionDescription;
  transactionCommitSync(transactionDescription);
}

/// Commits a pending transaction (sync version).
///
/// This function commits a pending transaction represented by the transactionDescription
/// parameter. It finalizes the transaction and sends the funds to the specified destinations.
/// The transactionDescription parameter should be a [PendingTransactionDescription] object
/// obtained from the createTransaction or createTransactionMultDest functions.
void transactionCommitSync(PendingTransactionDescription transactionDescription) {
  final pendingTransactionPointer =
      Pointer<ExternPendingTransactionRaw>.fromAddress(transactionDescription.pointerAddress);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.transaction_commit(pendingTransactionPointer, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw CreationTransactionException(message: errorInfo.getErrorMessage());
  }
}

/// Creates a new transaction specifying the extended info (async version).
///
/// This function creates a new transaction to send funds to the specified address.
/// It returns a [Future] that resolves to a [CreateTransactionResponse] object,
/// which contains information about the created transaction.
///
/// To send a transaction to the network, use the [relayTransaction] function.
Future<CreateTransactionResponse> createExtendedTransaction(CreateTransactionRequest createTransactionRequest) async {
  final txConfigJson = jsonEncode(createTransactionRequest.toJson());
  final jsonResponse = await createExtendedTransactionAsJson(txConfigJson);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return CreateTransactionResponse.fromJson(jsonMapResponse);
}

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

  final resultPointer = monero_flutter.bindings.create_transactions(txConfigJsonPointer, errorBoxPointer);

  calloc.free(txConfigJsonPointer);

  final result = monero_flutter.extractString(resultPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

/// Sending a transaction to the network (async version).
///
/// This function is commonly used after calling createExtendedTransaction or
/// createExtendedTransactionAsJson functions.
Future<String> relayTransaction(String txMetadata) =>
    compute(_relayTransactionSync, {'txMetadata': txMetadata});

String _relayTransactionSync(Map args) {
  final txMetadata = args['txMetadata'] as String;
  return relayTransactionSync(txMetadata);
}

/// Sending a transaction to the network (sync version).
///
/// This function is commonly used after calling createExtendedTransactionSync or
/// createExtendedTransactionAsJsonSync functions.
String relayTransactionSync(String txMetadata)
{
  final txMetadataPointer = txMetadata.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer = monero_flutter.bindings.relay_transaction(txMetadataPointer, errorBoxPointer);

  calloc.free(txMetadataPointer);

  final result = monero_flutter.extractString(resultPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

/// Retrieves the transaction key for a transaction (async version).
///
/// This function retrieves the transaction key for the specified transactionId.
/// The transaction key is a unique identifier associated with a transaction, and it
/// can be used for various purposes such as verifying the transaction's authenticity
/// or performing further operations on the transaction.
///
/// Parameters:
/// - transactionId: The ID of the transaction for which to retrieve the transaction key.
Future<String> getTransactionKey(String transactionId) =>
    compute(_getTransactionKeySync, {'transactionId': transactionId});

String _getTransactionKeySync(Map args) {
  final transactionId = args['transactionId'] as String;
  return getTransactionKeySync(transactionId);
}

/// Retrieves the transaction key for a transaction (sync version).
///
/// This function retrieves the transaction key for the specified transactionId.
/// The transaction key is a unique identifier associated with a transaction, and it
/// can be used for various purposes such as verifying the transaction's authenticity
/// or performing further operations on the transaction.
///
/// Parameters:
/// - transactionId: The ID of the transaction for which to retrieve the transaction key.
String getTransactionKeySync(String transactionId) {
  Pointer<Char> transactionIdPointer = transactionId.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer = monero_flutter.bindings.get_tx_key(transactionIdPointer, errorBoxPointer);

  final result = monero_flutter.extractString(resultPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result!;
}

/// Retrieves a list of all unspent transaction outputs (UTXOs). Async version of method.
///
/// Returns:
///   A [Future] that completes with the response containing the unspent transaction outputs.
Future<OutputsResponse> getUtxos() => compute(_getUtxosSync, {});

OutputsResponse _getUtxosSync(Map args) {
  return getUtxosSync();
}

/// Retrieves a list of all unspent transaction outputs (UTXOs). Sync version of method.
///
/// Returns:
///   The unspent transaction outputs.
OutputsResponse getUtxosSync() {
  OutputsRequest request =
      OutputsRequest(isSpent: false, txQuery: OutputsRequestTxQuery(isLocked: false, isConfirmed: true));
  return getOutputsSync(request);
}

/// Get outputs which meet the criteria defined in a query object (async version).
///
/// Outputs must meet every criteria defined in the query in order to be
/// returned.  All criteria are optional and no filtering is applied when not
/// defined.
///
/// All supported query criteria:
/// - isSpent: get outputs that are spent or not (optional).
/// - txQuery: get outputs whose transaction meets this filter (optional).
///
/// Returns the queried outputs.
Future<OutputsResponse> getOutputs(OutputsRequest request) => compute(_getOutputsSync, {'request': request});

OutputsResponse _getOutputsSync(Map args) {
  final request = args['request'] as OutputsRequest;
  return getOutputsSync(request);
}

/// Get outputs which meet the criteria defined in a query object (sync version).
///
/// Outputs must meet every criteria defined in the query in order to be
/// returned.  All criteria are optional and no filtering is applied when not
/// defined.
///
/// All supported query criteria:
/// - isSpent: get outputs that are spent or not (optional).
/// - txQuery: get outputs whose transaction meets this filter (optional).
///
/// Returns the queried outputs.
OutputsResponse getOutputsSync(OutputsRequest request) {
  final jsonRequest = jsonEncode(request.toJson());
  final jsonResponse = getOutputsAsJsonSync(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return OutputsResponse.fromJson(jsonMapResponse);
}

/// Get outputs in JSON-form, which meet the criteria defined in a JSON-query (async version).
///
/// Outputs must meet every criteria defined in the query in order to be
/// returned.  All criteria are optional and no filtering is applied when not
/// defined.
///
/// All supported query criteria:
/// - isSpent: get outputs that are spent or not (optional).
/// - txQuery: get outputs whose transaction meets this filter (optional).
///
/// Returns the queried outputs in JSON-form.
Future<String> getOutputsAsJson(String jsonRequest) => compute(_getOutputsAsJsonSync, {'jsonRequest': jsonRequest});

String _getOutputsAsJsonSync(Map args) {
  final jsonRequest = args['jsonRequest'] as String;
  return getOutputsAsJsonSync(jsonRequest);
}

/// Get outputs in JSON-form, which meet the criteria defined in a JSON-query (sync version).
///
/// Outputs must meet every criteria defined in the query in order to be
/// returned.  All criteria are optional and no filtering is applied when not
/// defined.
///
/// All supported query criteria:
/// - isSpent: get outputs that are spent or not (optional).
/// - txQuery: get outputs whose transaction meets this filter (optional).
///
/// Returns the queried outputs in JSON-form.
String getOutputsAsJsonSync(String jsonRequest) {
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

/// Get wallet transactions by hash (async version).
///
/// Parameters:
///   [request] - The object contains are hashes of transactions to get.
///
/// Returns a [Future] that completes with the identified transactions or throw if a transaction is not found.
Future<TxsResponse> getTxs(TxsRequest request) => compute(_getTxsSync, {'request': request});

TxsResponse _getTxsSync(Map args) {
  final request = args['request'] as TxsRequest;
  return getTxsSync(request);
}

/// Get wallet transactions by hash (sync version).
///
/// Parameters:
///   [request] - The object contains are hashes of transactions to get.
///
/// Returns the identified transactions or throw if a transaction is not found.
TxsResponse getTxsSync(TxsRequest request) {
  final jsonRequest = jsonEncode(request.toJson());
  final jsonResponse = getTxsAsJsonSync(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return TxsResponse.fromJson(jsonMapResponse);
}

/// Get wallet transactions in JSON-format by hash (async version).
///
/// Parameters:
///   [request] - JSON string contains are hashes of transactions to get.
///     Example: { "txs": [{"hash":"28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}] }
///
/// Returns a [Future] that completes with the identified transactions in JSON-format or throw if
/// a transaction is not found.
Future<String> getTxsAsJson(String jsonRequest) => compute(_getTxsAsJsonSync, {'jsonRequest': jsonRequest});

String _getTxsAsJsonSync(Map args) {
  final jsonRequest = args['jsonRequest'] as String;
  return getTxsAsJsonSync(jsonRequest);
}

/// Get wallet transactions in JSON-format by hash (sync version).
///
/// Parameters:
///   [request] - JSON string contains are hashes of transactions to get.
///     Example: { "txs": [{"hash":"28d0825270cd06364f04c32992e3d918ad3fa3aceba66efa7ad3d6d1cc7ab4b6"}] }
///
/// Returns the identified transactions in JSON-format or throw if a transaction is not found.
String getTxsAsJsonSync(String jsonRequest) {
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

/// Describe a tx set from multisig or unsigned tx hex (async version).
///
/// Parameters:
///   [describeTxRequest] - [DescribeMultisigTxRequest] or [DescribeUnsignedTxRequest] object.
///
/// Returns a [Future] that completes with the the tx set, containing structured transactions.
Future<DescribeTxResponse> describeTxSet(DescribeTxRequest describeTxRequest) =>
    compute(_describeTxSetSync, {'describeTxRequest': describeTxRequest});

DescribeTxResponse _describeTxSetSync(Map args) {
  final describeTxRequest = args['describeTxRequest'] as DescribeTxRequest;
  return describeTxSetSync(describeTxRequest);
}

/// Describe a tx set from multisig or unsigned tx hex (sync version).
///
/// Parameters:
///   [describeTxRequest] - [DescribeMultisigTxRequest] or [DescribeUnsignedTxRequest] object.
///
/// Returns the tx set containing structured transactions.
DescribeTxResponse describeTxSetSync(DescribeTxRequest describeTxRequest) {
  final jsonRequest = describeTxRequest.toJsonString();
  final jsonResponse = describeTxSetAsJsonSync(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return DescribeTxResponse.fromJson(jsonMapResponse);
}

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

/// Sweep all unlocked funds according to the given config (sync version).
///
/// All supported query criteria:
///   address - single destination address (required)
///
/// Returns a [Future] that completes with the created transactions.
Future<SweepUnlockedResponse> sweepUnlocked(SweepUnlockedRequest request) =>
    compute(_sweepUnlockedSync, {'request': request});

SweepUnlockedResponse _sweepUnlockedSync(Map args) {
  final request = args['request'] as SweepUnlockedRequest;
  return sweepUnlockedSync(request);
}

/// Sweep all unlocked funds according to the given config (async version).
///
/// All supported query criteria:
///   address - single destination address (required)
///
/// Returns the created transactions.
SweepUnlockedResponse sweepUnlockedSync(SweepUnlockedRequest request) {
  final jsonRequest = jsonEncode(request.toJson());
  final jsonResponse = sweepUnlockedAsJsonSync(jsonRequest);
  final jsonMapResponse = jsonDecode(jsonResponse);

  return SweepUnlockedResponse.fromJson(jsonMapResponse);
}

/// Sweep all unlocked funds according to the given config in JSON-format (async version).
///
/// All supported query criteria:
///   address - single destination address (required).
///     Example: {"destinations": [{"address":"86gwCboZti2hRP4m6pwFfVHwjtdptJVgFKhppuEQL6f2aJZZuJVaPzqK16NBfxWvPnFNDgKtAkptJPa1UCX1BnnUQsogxqA"}]}
///
/// Returns a [Future] that completes with the created transactions in JSON-format.
Future<String> sweepUnlockedAsJson(String jsonRequest) =>
    compute(_sweepUnlockedAsJsonSync, {'jsonRequest': jsonRequest});

String _sweepUnlockedAsJsonSync(Map args) {
  final jsonRequest = args['jsonRequest'] as String;
  return sweepUnlockedAsJsonSync(jsonRequest);
}

/// Sweep all unlocked funds according to the given config in JSON-format (sync version).
///
/// All supported query criteria:
///   address - single destination address (required).
///     Example: {"destinations": [{"address":"86gwCboZti2hRP4m6pwFfVHwjtdptJVgFKhppuEQL6f2aJZZuJVaPzqK16NBfxWvPnFNDgKtAkptJPa1UCX1BnnUQsogxqA"}]}
///
/// Returns the created transactions in JSON-format.
String sweepUnlockedAsJsonSync(String jsonRequest) {
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

/// Check if an output is frozen (async version).
///
/// Parameters:
///    [keyImage] - key image of the output to thaw.
///
/// Returns a [Future] that completes with the true if the output is frozen, false otherwise.
Future<bool> isFrozen(String keyImage) => compute(_isFrozenSync, {'keyImage': keyImage});

bool _isFrozenSync(Map args) {
  final keyImage = args['keyImage'] as String;
  return isFrozenSync(keyImage);
}

/// Check if an output is frozen (async version).
///
/// Parameters:
///    [keyImage] - key image of the output to thaw.
///
/// Returns true if the output is frozen, false otherwise.
bool isFrozenSync(String keyImage) {
  final keyImagePointer = keyImage.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  bool result = monero_flutter.bindings.frozen(keyImagePointer, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

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
  final resultPointer = monero_flutter.bindings.get_transfers(errorBoxPointer);
  final result = resultPointer.cast<Utf8>().toDartString();

  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

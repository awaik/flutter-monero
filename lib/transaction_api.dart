import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'entities/monero_output.dart';
import 'entities/pending_transaction.dart';
import 'entities/transaction_info_row.dart';
import 'exceptions/creation_transaction_exception.dart';
import 'monero_flutter.dart' as monero_flutter;
import 'monero_flutter_bindings_generated.dart';

void transactionsRefresh() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  monero_flutter.bindings.transactions_refresh(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

int transactionsCount() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.transactions_count(errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

List<TransactionInfoRow> getAllTransactions() {
  final errorBoxPointer1 = monero_flutter.buildErrorBoxPointer();
  final size = monero_flutter.bindings.transactions_count(errorBoxPointer1);
  final errorInfo1 = monero_flutter.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = monero_flutter.buildErrorBoxPointer();
  final transactionsPointer =
      monero_flutter.bindings.transactions_get_all(errorBoxPointer2);
  final transactionsAddresses = transactionsPointer.asTypedList(size);
  final errorInfo2 = monero_flutter.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  var result = transactionsAddresses
      .map((addr) => Pointer<TransactionInfoRow>.fromAddress(addr).ref)
      .toList();

  monero_flutter.bindings.free_block_of_transactions(transactionsPointer, size);

  return result;
}

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

PendingTransactionDescription createTransactionSync(
    {required String address,
    String? amount,
    String paymentId = '',
    int priorityRaw = 1,
    int subaddrAccount = 0}) {
  final addressPointer = address.toNativeUtf8().cast<Char>();
  final amountPointer = null != amount
      ? amount.toNativeUtf8().cast<Char>()
      : Pointer<Char>.fromAddress(nullptr.address);
  final paymentIdPointer = paymentId.toNativeUtf8().cast<Char>();
  final pendingTransactionPointer = calloc<ExternPendingTransactionRaw>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.transaction_create(
      addressPointer,
      paymentIdPointer,
      amountPointer,
      priorityRaw,
      subaddrAccount, // TODO - глянуть имя!
      pendingTransactionPointer,
      errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);
  calloc.free(addressPointer);
  calloc.free(paymentIdPointer);

  if (amountPointer.address != nullptr.address) {
    calloc.free(amountPointer);
  }

  if (0 != errorInfo.code) {
    calloc.free(pendingTransactionPointer);
    throw CreationTransactionException(message: errorInfo.getErrorMessage());
  }

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

  return pendingTransactionDescription;
}

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

  return pendingTransactionDescription;
}

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

String getTransactionKey(String transactionId) {
  Pointer<Char> transactionIdPointer =
      transactionId.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer =
      monero_flutter.bindings.get_tx_key(transactionIdPointer, errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

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

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/entities/simplified_transaction_report.dart';
import 'package:monero_flutter/entities/utxo.dart';
import 'package:uuid/uuid.dart';

import 'entities/create_transaction_request.dart';
import 'entities/simplified_transaction_request.dart';
import 'monero_flutter.dart' as monero_flutter;

import 'package:monero_flutter/transaction_api.dart' as transaction_api;

/// Checks if the wallet is using a multisig scheme (async version).
///
/// This function checks whether the wallet is using a multisig scheme for transactions.
/// It returns a boolean value indicating whether the wallet is using multisig.
///
/// Returns:
///   A [Future] that completes as true, if the wallet is using multisig, false otherwise.
Future<bool> isMultisig() => compute(_isMultisigSync, {});

bool _isMultisigSync(Map args) => isMultisigSync();

/// Checks if the wallet is using a multisig scheme (sync version).
///
/// This function checks whether the wallet is using a multisig scheme for transactions.
/// It returns a boolean value indicating whether the wallet is using multisig.
///
/// Returns:
///   Returns true if the wallet is using multisig, false otherwise.
bool isMultisigSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.is_multisig(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Prepares the wallet for a multisig transaction (async version).
///
/// This function prepares the wallet for a multisig transaction by generating initialization data
/// and returning it as a string. Participants then send their initialization data manually to all
/// other participants over a secure channel.
/// The method is equivalent to the "prepare_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Returns a [Future] that completes with the string, containing the multisig initialization data (MultisigxV2R1...).
Future<String> prepareMultisig() => compute(_prepareMultisigSync, {});

String _prepareMultisigSync(Map args) => prepareMultisigSync();

/// Prepares the wallet for a multisig transaction (sync version).
///
/// This function prepares the wallet for a multisig transaction by generating initialization data
/// and returning it as a string. Participants then send their initialization data manually to all
/// other participants over a secure channel.
/// The method is equivalent to the "prepare_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Returns a string containing the multisig initialization data (MultisigxV2R1...).
String prepareMultisigSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer =
      monero_flutter.bindings.prepare_multisig(errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves initialization data of the current multisig setup (async version).
///
/// This function retrieves initialization data of the current multisig setup.
/// The output of method getMultisigInfo is similar to the output of method prepareMultisig.
///
/// Returns a [Future] that completes with the string, containing the multisig initialization data (MultisigxV2R1...).
Future<String> getMultisigInfo() => compute(_getMultisigInfoSync, {});

String _getMultisigInfoSync(Map args) => getMultisigInfoSync();

/// Retrieves initialization data of the current multisig setup (sync version).
///
/// This function retrieves initialization data of the current multisig setup.
/// The output of method getMultisigInfo is similar to the output of method prepareMultisig.
///
/// Returns a string containing the multisig initialization data (MultisigxV2R1...).
String getMultisigInfoSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer =
      monero_flutter.bindings.get_multisig_info(errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Method set the threshold and the initialization data from the other participants (async version).
/// The method is equivalent to the "make_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// [infoList] is a list of strings containing initialization data from the other participants.
/// Initialization data can be obtained using either functionprepareMultisig or getMultisigInfo.
/// [threshold] is an integer representing the minimum number of signatures required to sign transactions.
///
/// Returns a [Future] that completes with the [String], representing the second round of initialization data (MultisigxV2Rn...).
Future<String> makeMultisig(
        {required List<String> infoList, required int threshold}) =>
    compute(_makeMultisigSync, {'infoList': infoList, 'threshold': threshold});

String _makeMultisigSync(Map args) {
  final infoList = args['infoList'] as List<String>;
  final threshold = args['threshold'] as int;

  return makeMultisigSync(infoList: infoList, threshold: threshold);
}

/// Method set the threshold and the initialization data from the other participants (sync version).
/// The method is equivalent to the "make_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// [infoList] is a list of strings containing initialization data from the other participants.
/// Initialization data can be obtained using either functionprepareMultisig or getMultisigInfo.
/// [threshold] is an integer representing the minimum number of signatures required to sign transactions.
///
/// Returns a [String] representing the second round of initialization data (MultisigxV2Rn...).
String makeMultisigSync(
    {required List<String> infoList, required int threshold}) {
  final size = infoList.length;

  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  Pointer<Char> resultPointer = monero_flutter.bindings
      .make_multisig(infoPointerPointer, size, threshold, errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();

  for (var element in infoPointers) {
    calloc.free(element);
  }

  calloc.free(infoPointerPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// The method is equivalent to the "exchange_multisig_keys" command in the Monero command-line interface (monero-wallet-cli). Async version.
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing the second round of initialization data (MultisigxV2Rn...) each of the participants.
///
/// Returns a [Future] that completes with the [String] with multisig address.
Future<String> exchangeMultisigKeys({required List<String> infoList}) =>
    compute(_exchangeMultisigKeysSync, {'infoList': infoList});

String _exchangeMultisigKeysSync(Map args) {
  final infoList = args['infoList'] as List<String>;

  return exchangeMultisigKeysSync(infoList: infoList);
}

/// The method is equivalent to the "exchange_multisig_keys" command in the Monero command-line interface (monero-wallet-cli). Sync version.
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing the second round of initialization data (MultisigxV2Rn...) each of the participants.
///
/// Returns a [String] with multisig address.
String exchangeMultisigKeysSync({required List<String> infoList}) {
  final size = infoList.length;
  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings
      .exchange_multisig_keys(infoPointerPointer, size, errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();

  for (var element in infoPointers) {
    calloc.free(element);
  }
  calloc.free(infoPointerPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// The method checks whether there is a need to import a partial key image (async version).
///
/// Returns a [Future], that completes with the [bool] indicating whether importing multisig is needed or not.
Future<bool> isMultisigImportNeeded() =>
    compute(_isMultisigImportNeededSync, {});

bool _isMultisigImportNeededSync(Map args) => isMultisigImportNeededSync();

/// The method checks whether there is a need to import a partial key image (sync version).
///
/// Returns a [bool] indicating whether importing multisig is needed or not.
bool isMultisigImportNeededSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final result =
      monero_flutter.bindings.is_multisig_import_needed(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Import partial key image (async version).
/// The method is equivalent to the "import_multisig_info" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing partial key image(s) from the other participants.
/// Partial key image is produced by exportMultisigImages function.
///
/// Returns a [Future] that completes with the [int], which display how many new inputs it has verified.
Future<int> importMultisigImages({required List<String> infoList}) =>
    compute(_importMultisigImagesSync, {'infoList': infoList});

int _importMultisigImagesSync(Map args) {
  final infoList = args['infoList'] as List<String>;

  return importMultisigImagesSync(infoList: infoList);
}

/// Import partial key image (sync version).
/// The method is equivalent to the "import_multisig_info" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing partial key image(s) from the other participants.
/// Partial key image is produced by exportMultisigImages function.
///
/// Returns an [int] which display how many new inputs it has verified.
int importMultisigImagesSync({required List<String> infoList}) {
  final size = infoList.length;

  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  int result = monero_flutter.bindings
      .import_multisig_images(infoPointerPointer, size, errorBoxPointer);

  for (var element in infoPointers) {
    calloc.free(element);
  }
  calloc.free(infoPointerPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Exports partial key image (async version).
/// The method is equivalent to the "export_multisig_info" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// A [Future] that completes with the [String], containing a partial key image.
Future<String> exportMultisigImages() => compute(_exportMultisigImagesSync, {});

String _exportMultisigImagesSync(Map args) => exportMultisigImagesSync();

/// Exports partial key image (sync version).
/// The method is equivalent to the "export_multisig_info" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Returns a partial key image.
String exportMultisigImagesSync() {
  final infoPointer = ''.toNativeUtf8().cast<Char>();
  Pointer<Pointer<Char>> pointerToInfoPointer = calloc.call();
  pointerToInfoPointer.value = infoPointer;
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings
      .export_multisig_images(pointerToInfoPointer, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  String? info;

  if (0 == errorInfo.code) {
    info = pointerToInfoPointer.value.cast<Utf8>().toDartString();
  }

  // new value is not set in native code
  if (pointerToInfoPointer.value == infoPointer) {
    calloc.free(infoPointer);
  } else {
    calloc.free(pointerToInfoPointer.value);
    calloc.free(infoPointer);
  }

  calloc.free(pointerToInfoPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  if (null == info) {
    throw Exception("null == info");
  }

  return info;
}

/// Signs a multisig transaction in hexadecimal format (async version).
/// The method is equivalent to the "sign_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes [multisigTxHex] as a [String] representing the multisig transaction in hexadecimal format (PendingTransactionDescription.multisigSignData).
///
/// Returns a [Future] that completes with the [String], containing the signed multisig transaction.
Future<String> signMultisigTxHex(String multisigTxHex) =>
    compute(_signMultisigTxHexSync, {'multisigTxHex': multisigTxHex});

String _signMultisigTxHexSync(Map args) {
  final multisigTxHex = args['multisigTxHex'] as String;

  return signMultisigTxHexSync(multisigTxHex);
}

/// Signs a multisig transaction in hexadecimal format (sync version).
/// The method is equivalent to the "sign_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes [multisigTxHex] as a [String] representing the multisig transaction in hexadecimal format (PendingTransactionDescription.multisigSignData).
///
/// Returns a [String] containing the signed multisig transaction.
String signMultisigTxHexSync(String multisigTxHex) {
  Pointer<Char> multisigTxHexPointer =
      multisigTxHex.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  Pointer<Char> resultPointer = monero_flutter.bindings
      .sign_multisig_tx_hex(multisigTxHexPointer, errorBoxPointer);

  String hex = resultPointer.cast<Utf8>().toDartString();

  calloc.free(multisigTxHexPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return hex;
}

/// Submits a signed multisig transaction in hexadecimal format for processing (async version).
/// The method is equivalent to the "submit_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes [signedMultisigTxHex] as a [String] representing the signed multisig transaction in hexadecimal format.
///
/// Returns a [Future] that completes with the list of [String], containing identifiers of the submitted transactions.
Future<List<String>> submitMultisigTxHex(String signedMultisigTxHex) => compute(
    _submitMultisigTxHexSync, {'signedMultisigTxHex': signedMultisigTxHex});

List<String> _submitMultisigTxHexSync(Map args) {
  final signedMultisigTxHex = args['signedMultisigTxHex'] as String;

  return submitMultisigTxHexSync(signedMultisigTxHex);
}

/// Submits a signed multisig transaction in hexadecimal format for processing (sync version).
/// The method is equivalent to the "submit_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes [signedMultisigTxHex] as a [String] representing the signed multisig transaction in hexadecimal format.
///
/// Returns a [List<String>] containing identifiers of the submitted transactions.
List<String> submitMultisigTxHexSync(String signedMultisigTxHex) {
  Pointer<Char> signedMultisigTxHexPointer =
      signedMultisigTxHex.toNativeUtf8().cast<Char>();

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings
      .submit_multisig_tx_hex(signedMultisigTxHexPointer, errorBoxPointer);

  final result = _convertToList(resultPointer);

  calloc.free(signedMultisigTxHexPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

Future<SimplifiedTransactionReport> prepareTransaction(SimplifiedTransactionRequest request) async {

  const fee = 6000000;
  int totalSum = request.destinations.map((d) => d.amount).reduce((sum, amount) => sum + amount);
  totalSum += fee;

  final utxos = (await transaction_api.getUtxos());
  utxos.sort((a, b) => a.amount.compareTo(b.amount));

  List<Utxo> usedUtxos = [];

  for(final utxo in utxos)
  {
    usedUtxos.add(utxo);

    totalSum -= utxo.amount;

    if (totalSum <= 0) {
      break;
    }
  }

  if (totalSum > 0) {
    throw Exception("Not enough money!");
  }

  final destinations = request.destinations.map((d) => CreateTransactionRequestDestination(address: d.address, amount: d.amount)).toList();
  final subaddressIndices = usedUtxos.map((uu) => uu.subaddressIndex).toList();

  final createTransactionRequest = CreateTransactionRequest(destinations: destinations, accountIndex: 0, subaddressIndices: subaddressIndices);

  final createTransactionResponse = await transaction_api.createExtendedTransaction(createTransactionRequest);

  final assignedUtxos = usedUtxos.map((e) => SimplifiedTransactionReportUtxo(id: e.keyImage)).toList();

  String uuid = const Uuid().v4();

  final txTree = SimplifiedTransactionReportTxTree(rawTx: createTransactionResponse.multisigTxHex!, childTawTxs: []);
  final assignedTrade = SimplifiedTransactionReportTrade(id: uuid, txTree: txTree);
  final utxoGroup = SimplifiedTransactionReportUtxoGroup(assignedUtxos: assignedUtxos, assignedTrades: [assignedTrade]);

  return SimplifiedTransactionReport(utxoGroups: [utxoGroup]);
}

List<String> _convertToList(Pointer<Pointer<Char>> pointers) {

  if (nullptr == pointers) {
    return [];
  }

  final list = <String>[];

  var i = 0;

  while (true) {
    final pointer = pointers.elementAt(i).value;

    if (pointer == nullptr) {
      break;
    }

    final string = pointer.cast<Utf8>().toDartString();
    list.add(string);
    i++;
  }

  i = 0;
  while (true) {
    final pointer = pointers.elementAt(i).value;

    if (pointer == nullptr) {
      break;
    }

    calloc.free(pointer);
    i++;
  }

  calloc.free(pointers);

  return list;
}

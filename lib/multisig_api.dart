import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'monero_flutter.dart' as monero_flutter;

Future<bool> isMultisig() => compute(_isMultisigSync, {});

bool _isMultisigSync(Map args) => isMultisigSync();

/// Checks if the wallet is using a multisig scheme.
///
/// This function checks whether the wallet is using a multisig scheme for transactions.
/// It returns a boolean value indicating whether the wallet is using multisig.
///
/// Returns true if the wallet is using multisig, false otherwise.
bool isMultisigSync() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.is_multisig(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

Future<String> prepareMultisig() => compute(_prepareMultisigSync, {});

String _prepareMultisigSync(Map args) => prepareMultisigSync();

/// Prepares the wallet for a multisig transaction.
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

Future<String> getMultisigInfo() => compute(_getMultisigInfoSync, {});

String _getMultisigInfoSync(Map args) => getMultisigInfoSync();

/// Retrieves initialization data of the current multisig setup.
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

Future<String> makeMultisig(
        {required List<String> infoList, required int threshold}) =>
    compute(_makeMultisigSync, {'infoList': infoList, 'threshold': threshold});

String _makeMultisigSync(Map args) {
  final infoList = args['infoList'] as List<String>;
  final threshold = args['threshold'] as int;

  return makeMultisigSync(infoList: infoList, threshold: threshold);
}

/// Method set the threshold and the initialization data from the other participants.
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

Future<String> exchangeMultisigKeys(
    {required List<String> infoList}) =>
    compute(_exchangeMultisigKeysSync, {'infoList': infoList});

String _exchangeMultisigKeysSync(Map args) {
  final infoList = args['infoList'] as List<String>;

  return exchangeMultisigKeysSync(infoList: infoList);
}

/// The method is equivalent to the "exchange_multisig_keys" command in the Monero command-line interface (monero-wallet-cli).
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

Future<bool> isMultisigImportNeeded() => compute(_isMultisigImportNeededSync, {});

bool _isMultisigImportNeededSync(Map args) => isMultisigImportNeededSync();

/// The method checks whether there is a need to import a partial key image.
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

Future<int> importMultisigImages(
    {required List<String> infoList}) =>
    compute(_importMultisigImagesSync, {'infoList': infoList});

int _importMultisigImagesSync(Map args) {
  final infoList = args['infoList'] as List<String>;

  return importMultisigImagesSync(infoList: infoList);
}

/// Import partial key image.
/// The method is equivalent to the "import_multisig_info" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing partial key image(s) from the other participants.
/// Partial key image is produced by exportMultisigImages function.
///
/// Returns an [int], which display how many new inputs it has verified.
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

Future<String> exportMultisigImages() => compute(_exportMultisigImagesSync, {});

String _exportMultisigImagesSync(Map args) => exportMultisigImagesSync();

/// Exports partial key image.
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

Future<String> signMultisigTxHex(String multisigTxHex) =>
    compute(_signMultisigTxHexSync, {'multisigTxHex': multisigTxHex});

String _signMultisigTxHexSync(Map args) {
  final multisigTxHex = args['multisigTxHex'] as String;

  return signMultisigTxHexSync(multisigTxHex);
}

/// Signs a multisig transaction in hexadecimal format.
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

Future<List<String>> submitMultisigTxHex(String signedMultisigTxHex) =>
    compute(_submitMultisigTxHexSync, {'signedMultisigTxHex': signedMultisigTxHex});

List<String> _submitMultisigTxHexSync(Map args) {
  final signedMultisigTxHex = args['signedMultisigTxHex'] as String;

  return submitMultisigTxHexSync(signedMultisigTxHex);
}

/// Submits a signed multisig transaction in hexadecimal format for processing.
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
  final pointers = monero_flutter.bindings
      .submit_multisig_tx_hex(signedMultisigTxHexPointer, errorBoxPointer);
  final result = _convertToList(pointers);

  calloc.free(signedMultisigTxHexPointer);
  calloc.free(pointers);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

List<String> _convertToList(Pointer<Pointer<Char>> pointers) {
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

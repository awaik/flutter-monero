import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:monero_flutter/monero_flutter.dart' as monero_flutter;

// *****************************************************************************
// prepare_multisig
// *****************************************************************************

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

// *****************************************************************************
// make_multisig
// *****************************************************************************

/// Method set the threshold and the initialization data from the other participants (async version).
/// The method is equivalent to the "make_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// [infoList] is a list of strings containing initialization data from the other participants.
/// Initialization data can be obtained using either functionprepareMultisig or getMultisigInfo.
/// [threshold] is an integer representing the minimum number of signatures required to sign transactions.
/// [password] - wallet password.
///
/// Returns a [Future] that completes with the [String], representing the second round of initialization data (MultisigxV2Rn...).
Future<String> makeMultisig(
        {required List<String> infoList,
        required int threshold,
        required String password}) =>
    compute(_makeMultisigSync,
        {'infoList': infoList, 'threshold': threshold, 'password': password});

String _makeMultisigSync(Map args) {
  final infoList = args['infoList'] as List<String>;
  final threshold = args['threshold'] as int;
  final password = args['password'] as String;

  return makeMultisigSync(
      infoList: infoList, threshold: threshold, password: password);
}

/// Method set the threshold and the initialization data from the other participants (sync version).
/// The method is equivalent to the "make_multisig" command in the Monero command-line interface (monero-wallet-cli).
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// [infoList] is a list of strings containing initialization data from the other participants.
/// Initialization data can be obtained using either functionprepareMultisig or getMultisigInfo.
/// [threshold] is an integer representing the minimum number of signatures required to sign transactions.
/// [password] - wallet password.
///
/// Returns a [String] representing the second round of initialization data (MultisigxV2Rn...).
String makeMultisigSync(
    {required List<String> infoList,
    required int threshold,
    required password}) {
  final size = infoList.length;

  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);
  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  Pointer<Char> resultPointer = monero_flutter.bindings.make_multisig(
      infoPointerPointer, size, threshold, passwordPointer, errorBoxPointer);

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

// *****************************************************************************
// exchange_multisig_keys
// *****************************************************************************

/// The method is equivalent to the "exchange_multisig_keys" command in the Monero command-line interface (monero-wallet-cli). Async version.
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing the second round of initialization data (MultisigxV2Rn...) each of the participants.
///
/// Returns a [Future] that completes with the [String] with multisig address.
Future<String> exchangeMultisigKeys({required List<String> infoList, required String password}) =>
    compute(_exchangeMultisigKeysSync, {'infoList': infoList, 'password': password});

String _exchangeMultisigKeysSync(Map args) {
  final infoList = args['infoList'] as List<String>;
  final password = args['password'] as String;

  return exchangeMultisigKeysSync(infoList: infoList, password: password);
}

/// The method is equivalent to the "exchange_multisig_keys" command in the Monero command-line interface (monero-wallet-cli). Sync version.
/// See https://resilience365.com/monero-multisig-how-to/.
///
/// Takes a list of [infoList] strings containing the second round of initialization data (MultisigxV2Rn...) each of the participants.
///
/// Returns a [String] with multisig address.
String exchangeMultisigKeysSync({required List<String> infoList, required String password}) {
  final size = infoList.length;
  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final passwordPointer = password.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings
      .exchange_multisig_keys(infoPointerPointer, size, passwordPointer, errorBoxPointer);

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

// *****************************************************************************
// is_multisig_import_needed
// *****************************************************************************

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

// *****************************************************************************
// export_multisig_images
// *****************************************************************************

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

// *****************************************************************************
// import_multisig_images
// *****************************************************************************

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

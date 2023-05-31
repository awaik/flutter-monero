import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'monero_flutter.dart' as monero_flutter;

/// Checks if the wallet is using a multisig scheme.
///
/// This function checks whether the wallet is using a multisig scheme for transactions.
/// It returns a boolean value indicating whether the wallet is using multisig.
///
/// Example usage:
/// dart /// bool isMultisigWallet = isMultisig(); /// if (isMultisigWallet) { /// print('The wallet is using a multisig scheme.'); /// } else { /// print('The wallet is not using a multisig scheme.'); /// } /// ///
/// Returns true if the wallet is using multisig, false otherwise.
bool isMultisig(){
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  var result = monero_flutter.bindings.is_multisig(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Prepares the wallet for a multisig transaction.
///
/// This function prepares the wallet for a multisig transaction by generating the necessary data
/// and returning it as a string. This data is typically used by other participants in the multisig scheme
/// to complete the transaction.
///
/// Example usage:
/// dart /// String multisigData = prepareMultisig(); /// print('Multisig data: $multisigData'); /// ///
/// Returns a string containing the multisig data.
String prepareMultisig() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final resultPointer = monero_flutter.bindings.prepare_multisig(errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves information about the current multisig setup.
///
/// This function retrieves information about the current multisig setup, including the number
/// of participants, their addresses, and the threshold required for transaction signing.
/// It returns this information as a string in JSON format.
///
/// Example usage:
/// dart /// String multisigInfo = getMultisigInfo(); /// print('Multisig info: $multisigInfo'); /// ///
/// Returns a JSON string containing the multisig information.
String getMultisigInfo() {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer = monero_flutter.bindings.get_multisig_info(errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Generates and exchanges multisig keys with other participants.
///
/// Takes a list of [infoList] strings containing the necessary information for key exchange.
///
/// Returns a [String] representing the exchanged multisig keys.
String exchangeMultisigKeys(
    {required List<String> infoList}) {

  final size = infoList.length;
  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final resultPointer =
      monero_flutter.bindings.exchange_multisig_keys(infoPointerPointer, size, errorBoxPointer);

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

/// Checks if importing multisig is required.
///
/// Returns a [bool] indicating whether importing multisig is needed or not.
bool isMultisigImportNeeded(){
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final result = monero_flutter.bindings.is_multisig_import_needed(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Imports multisig images.
///
/// Takes a list of [infoList] strings containing the necessary information for importing multisig images.
///
/// Returns an [int] indicating the success of importing multisig images.
int importMultisigImages({required List<String> infoList}) {
  final size = infoList.length;

  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  int result =
      monero_flutter.bindings.import_multisig_images(infoPointerPointer, size, errorBoxPointer);

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

/// Exports multisig images.
///
/// Returns a [String] representing the exported multisig images.
String exportMultisigImages() {
  final infoPointer = ''.toNativeUtf8().cast<Char>();
  Pointer<Pointer<Char>> pointerToInfoPointer = calloc.call();
  pointerToInfoPointer.value = infoPointer;
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.export_multisig_images(pointerToInfoPointer, errorBoxPointer);
  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  String? info;

  if (0 == errorInfo.code) {
    info = pointerToInfoPointer.value.cast<Utf8>().toDartString();
  }

  // new value is not set in native code
  if (pointerToInfoPointer.value == infoPointer) {
    calloc.free(infoPointer);
  }
  else{
    calloc.free(pointerToInfoPointer.value);
    calloc.free(infoPointer);
  }

  calloc.free(pointerToInfoPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  if (null == info){
    throw Exception("null == info");
  }

  return info;
}

/// Generates a multisig wallet with the provided [infoList] and [threshold].
///
/// [infoList] is a list of strings containing the necessary information for generating the multisig wallet.
/// [threshold] is an integer representing the minimum number of signatures required to sign transactions.
///
/// Returns a [String] representing the generated multisig wallet.
String makeMultisig(
    {required List<String> infoList,
    required int threshold}) {
  final size = infoList.length;

  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  Pointer<Char> resultPointer =
      monero_flutter.bindings.make_multisig(infoPointerPointer, size, threshold, errorBoxPointer);

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

/// Signs a multisig transaction in hexadecimal format.
///
/// Takes [multisigTxHex] as a [String] representing the multisig transaction in hexadecimal format.
///
/// Returns a [String] containing the signed multisig transaction.
String signMultisigTxHex(String multisigTxHex)
{
  Pointer<Char> multisigTxHexPointer = multisigTxHex.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  Pointer<Char> resultPointer = monero_flutter.bindings.sign_multisig_tx_hex(multisigTxHexPointer, errorBoxPointer);

  String hex = resultPointer.cast<Utf8>().toDartString();

  calloc.free(multisigTxHexPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return hex;
}

/// Submits a signed multisig transaction in hexadecimal format for processing.
///
/// Takes [signedMultisigTxHex] as a [String] representing the signed multisig transaction in hexadecimal format.
///
/// Returns a [List<String>] containing the submission result or any error messages.
List<String> submitMultisigTxHex(String signedMultisigTxHex)
{
  Pointer<Char> signedMultisigTxHexPointer = signedMultisigTxHex.toNativeUtf8().cast<Char>();

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final pointers = monero_flutter.bindings.submit_multisig_tx_hex(signedMultisigTxHexPointer, errorBoxPointer);
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
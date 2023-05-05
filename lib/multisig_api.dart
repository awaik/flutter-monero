import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'monero_api.dart' as monero_api;

bool isMultisig(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  var result = monero_api.bindings.is_multisig(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String prepareMultisig() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  final resultPointer = monero_api.bindings.prepare_multisig(errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String getMultisigInfo() {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final resultPointer = monero_api.bindings.get_multisig_info(errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();
  calloc.free(resultPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String exchangeMultisigKeys(
    {required List<String> infoList, required int size}) {
  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final resultPointer =
      monero_api.bindings.exchange_multisig_keys(infoPointerPointer, size, errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();

  for (var element in infoPointers) {
    calloc.free(element);
  }
  calloc.free(infoPointerPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

bool isMultisigImportNeeded(){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  final result = monero_api.bindings.is_multisig_import_needed(errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}


int importMultisigImages({required List<String> infoList, required int size}) {
  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  int result =
      monero_api.bindings.import_multisig_images(infoPointerPointer, size, errorBoxPointer);

  for (var element in infoPointers) {
    calloc.free(element);
  }
  calloc.free(infoPointerPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String exportMultisigImages() {
  final infoPointer = ''.toNativeUtf8().cast<Char>();
  Pointer<Pointer<Char>> pointerToInfoPointer = calloc.call();
  pointerToInfoPointer.value = infoPointer;
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings.export_multisig_images(pointerToInfoPointer, errorBoxPointer);
  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  String? info;

  if (0 == errorInfo.code) {
    info = pointerToInfoPointer.value.cast<Utf8>().toDartString();
  }

  calloc.free(infoPointer);
  calloc.free(pointerToInfoPointer.value);
  calloc.free(pointerToInfoPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  if (null == info){
    throw Exception("null == info");
  }

  return info;
}

String makeMultisig(
    {required List<String> infoList,
    required int size,
    required int threshold}) {
  final List<Pointer<Char>> infoPointers =
      infoList.map((info) => info.toNativeUtf8().cast<Char>()).toList();
  final Pointer<Pointer<Char>> infoPointerPointer = calloc(size);
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  for (int i = 0; i < size; i++) {
    infoPointerPointer[i] = infoPointers[i];
  }

  Pointer<Char> resultPointer =
      monero_api.bindings.make_multisig(infoPointerPointer, size, threshold, errorBoxPointer);

  final result = resultPointer.cast<Utf8>().toDartString();

  for (var element in infoPointers) {
    calloc.free(element);
  }

  calloc.free(infoPointerPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String signMultisigTxHex(String multisigTxHex)
{
  Pointer<Char> multisigTxHexPointer = multisigTxHex.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  Pointer<Char> resultPointer = monero_api.bindings.sign_multisig_tx_hex(multisigTxHexPointer, errorBoxPointer);

  String hex = resultPointer.cast<Utf8>().toDartString();

  calloc.free(multisigTxHexPointer);
  calloc.free(resultPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return hex;
}

List<String> submitMultisigTxHex(String signedMultisigTxHex)
{
  Pointer<Char> signedMultisigTxHexPointer = signedMultisigTxHex.toNativeUtf8().cast<Char>();

  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final pointers = monero_api.bindings.submit_multisig_tx_hex(signedMultisigTxHexPointer, errorBoxPointer);
  final result = convertToList(pointers);

  calloc.free(signedMultisigTxHexPointer);
  calloc.free(pointers);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

List<String> convertToList(Pointer<Pointer<Char>> pointers) {

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
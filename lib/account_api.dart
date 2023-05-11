import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'entities/account_row.dart';
import 'entities/subaddress_row.dart';
import 'flutter_monero.dart' as flutter_monero;

bool isUpdating = false;

void refreshAccounts() {

  if (isUpdating) {
    return;
  }

  try {
    isUpdating = true;

    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    flutter_monero.bindings.account_refresh(errorBoxPointer);
    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    isUpdating = false;
  } catch (e) {
    isUpdating = false;
    rethrow;
  }
}

bool isSubaddressesUpdating = false;

void refreshSubaddresses({required int accountIndex}) {
  if (isSubaddressesUpdating) {
    return;
  }

  try {
    isSubaddressesUpdating = true;

    final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
    flutter_monero.bindings.subaddress_refresh(accountIndex, errorBoxPointer);

    final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    isSubaddressesUpdating = false;
  } catch (e) {
    isSubaddressesUpdating = false;
    rethrow;
  }
}

List<AccountRow> getAllAccount() {

  final errorBoxPointer1 = flutter_monero.buildErrorBoxPointer();
  final size = flutter_monero.bindings.account_size(errorBoxPointer1);

  final errorInfo1 = flutter_monero.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = flutter_monero.buildErrorBoxPointer();

  final errorInfo2 = flutter_monero.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  final accountAddressesPointer = flutter_monero.bindings.account_get_all(errorBoxPointer2);

  final accountAddresses = accountAddressesPointer.asTypedList(size);

  final result = accountAddresses
      .map((addr) => Pointer<AccountRow>.fromAddress(addr).ref)
      .toList();

  flutter_monero.bindings.free_block_of_accounts(accountAddressesPointer, size);

  return result;
}

List<SubaddressRow> getAllSubaddresses() {
  final errorBoxPointer1 = flutter_monero.buildErrorBoxPointer();

  final size = flutter_monero.bindings.subaddress_size(errorBoxPointer1);

  final errorInfo1 = flutter_monero.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = flutter_monero.buildErrorBoxPointer();

  final subaddressAddressesPointer = flutter_monero.bindings.subaddress_get_all(
      errorBoxPointer2);

  final errorInfo2 = flutter_monero.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  final subaddressAddresses = subaddressAddressesPointer.asTypedList(size);

  final result = subaddressAddresses
      .map((addr) => Pointer<SubaddressRow>.fromAddress(addr).ref)
      .toList();

  flutter_monero.bindings.free_block_of_subaddresses(subaddressAddressesPointer, size);

  return result;
}

Future<void> addAccount({required String label}) async {
  await compute(_addAccount, label);
  //await store();
}

void _addAccount(String label) => addAccountSync(label: label);

void addAccountSync({required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

  flutter_monero.bindings.account_add_row(labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<void> addSubaddress({required int accountIndex, required String label}) async {
  await compute<Map<String, Object>, void>(
      _addSubaddress, {'accountIndex': accountIndex, 'label': label});
  //await store();
}

void _addSubaddress(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  addSubaddressSync(accountIndex: accountIndex, label: label);
}

void addSubaddressSync({required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

  flutter_monero.bindings.subaddress_add_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<void> setLabelForAccount(
    {required int accountIndex, required String label}) async {
  await compute(
      _setLabelForAccount, {'accountIndex': accountIndex, 'label': label});
  //await store();
}

void _setLabelForAccount(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  setLabelForAccountSync(label: label, accountIndex: accountIndex);
}

void setLabelForAccountSync(
    {required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

  flutter_monero.bindings.account_set_label_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<void> setLabelForSubaddress(
    {required int accountIndex, required int addressIndex, required String label}) async {
  await compute<Map<String, Object>, void>(_setLabelForSubaddress, {
    'accountIndex': accountIndex,
    'addressIndex': addressIndex,
    'label': label
  });
  //await store();
}

void _setLabelForSubaddress(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;
  final addressIndex = args['addressIndex'] as int;

  setLabelForSubaddressSync(
      accountIndex: accountIndex, addressIndex: addressIndex, label: label);
}

void setLabelForSubaddressSync(
    {required int accountIndex,
    required int addressIndex,
    required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();

  flutter_monero.bindings
      .subaddress_set_label(accountIndex, addressIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

String getAddress({int accountIndex = 0, int addressIndex = 0}) {
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
  final addressPointer =
      flutter_monero.bindings.get_address(accountIndex, addressIndex, errorBoxPointer);

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return address;
}

int getFullBalance({int accountIndex = 0}){
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
  final result = flutter_monero.bindings.get_full_balance(accountIndex, errorBoxPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}


int getUnlockedBalance(int accountIndex){
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
  final result = flutter_monero.bindings.get_unlocked_balance(accountIndex, errorBoxPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String getSubaddressLabel(int accountIndex, int addressIndex) {
  final errorBoxPointer = flutter_monero.buildErrorBoxPointer();
  final labelPointer =
      flutter_monero.bindings.get_subaddress_label(accountIndex, addressIndex, errorBoxPointer);

  final label = labelPointer.cast<Utf8>().toDartString();
  calloc.free(labelPointer);

  final errorInfo = flutter_monero.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return label;
}

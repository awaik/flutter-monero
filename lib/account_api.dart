import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'entities/account_row.dart';
import 'entities/subaddress_row.dart';
import 'monero_flutter.dart' as monero_flutter;

bool isUpdating = false;

/// Refreshes the accounts of the currently opened Monero wallet.
///
/// Refreshes the accounts of the currently opened Monero wallet, updating the balances
/// and transaction history.
void refreshAccounts() {

  if (isUpdating) {
    return;
  }

  try {
    isUpdating = true;

    final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
    monero_flutter.bindings.account_refresh(errorBoxPointer);
    final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

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

/// Refreshes the subaddresses of a specific account in the currently opened Monero wallet.
///
/// Refreshes the subaddresses of the account specified by [accountIndex] in the currently opened Monero wallet,
/// updating their balances and transaction history.
///
/// Parameters:
///   [accountIndex] - The index of the account to refresh the subaddresses for.
void refreshSubaddresses({required int accountIndex}) {
  if (isSubaddressesUpdating) {
    return;
  }

  try {
    isSubaddressesUpdating = true;

    final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
    monero_flutter.bindings.subaddress_refresh(accountIndex, errorBoxPointer);

    final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    isSubaddressesUpdating = false;
  } catch (e) {
    isSubaddressesUpdating = false;
    rethrow;
  }
}

/// Retrieves the total number of accounts in the currently opened Monero wallet.
///
/// Retrieves the total number of accounts in the currently opened Monero wallet.
///
/// Returns:
///   The total number of accounts as an integer.
int getAccountCount() {

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.account_size(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves the total number of accounts in the currently opened Monero wallet.
///
/// Retrieves the total number of accounts in the currently opened Monero wallet.
///
/// Returns:
///   The total number of accounts as an integer.
List<AccountRow> getAllAccount() {

  final errorBoxPointer1 = monero_flutter.buildErrorBoxPointer();
  final size = monero_flutter.bindings.account_size(errorBoxPointer1);

  final errorInfo1 = monero_flutter.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = monero_flutter.buildErrorBoxPointer();

  final errorInfo2 = monero_flutter.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  final accountAddressesPointer = monero_flutter.bindings.account_get_all(errorBoxPointer2);

  final accountAddresses = accountAddressesPointer.asTypedList(size);

  final result = accountAddresses
      .map((addr) => Pointer<AccountRow>.fromAddress(addr).ref)
      .toList();

  monero_flutter.bindings.free_block_of_accounts(accountAddressesPointer, size);

  return result;
}

/// Retrieves the total number of subaddresses in the currently opened Monero wallet.
///
/// Retrieves the total number of subaddresses in the currently opened Monero wallet.
///
/// Returns:
///   The total number of subaddresses as an integer.
int getSubaddressesCount() {

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.subaddress_size(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves all the subaddresses in the currently opened Monero wallet.
///
/// Retrieves all the subaddresses in the currently opened Monero wallet and returns them as a list of [SubaddressRow] objects.
///
/// Returns:
///   A list of [SubaddressRow] objects representing the subaddresses in the wallet.
List<SubaddressRow> getAllSubaddresses() {
  final errorBoxPointer1 = monero_flutter.buildErrorBoxPointer();

  final size = monero_flutter.bindings.subaddress_size(errorBoxPointer1);

  final errorInfo1 = monero_flutter.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = monero_flutter.buildErrorBoxPointer();

  final subaddressAddressesPointer = monero_flutter.bindings.subaddress_get_all(
      errorBoxPointer2);

  final errorInfo2 = monero_flutter.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  final subaddressAddresses = subaddressAddressesPointer.asTypedList(size);

  final result = subaddressAddresses
      .map((addr) => Pointer<SubaddressRow>.fromAddress(addr).ref)
      .toList();

  monero_flutter.bindings.free_block_of_subaddresses(subaddressAddressesPointer, size);

  return result;
}

/// Adds a new account to the currently opened Monero wallet.
///
/// Adds a new account to the currently opened Monero wallet with the specified [label].
///
/// Parameters:
///   [label] - The label for the new account.
///
/// Returns:
///   A [Future] that completes with no result.
Future<void> addAccount({required String label}) async {
  await compute(_addAccount, label);
  //await store();
}

void _addAccount(String label) => addAccountSync(label: label);

/// Adds a new account synchronously to the currently opened Monero wallet.
///
/// Adds a new account synchronously to the currently opened Monero wallet with the specified [label].
///
/// Parameters:
///   [label] - The label for the new account.
void addAccountSync({required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.account_add_row(labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Adds a new subaddress to the specified account in the currently opened Monero wallet.
///
/// Adds a new subaddress to the account specified by [accountIndex] in the currently opened Monero wallet
/// with the specified [label].
///
/// Parameters:
///   [accountIndex] - The index of the account to add the subaddress to.
///   [label] - The label for the new subaddress.
///
/// Returns:
///   A [Future] that completes with no result.
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

/// Adds a new subaddress synchronously to the specified account in the currently opened Monero wallet.
///
/// Adds a new subaddress synchronously to the account specified by [accountIndex] in the currently opened Monero wallet
/// with the specified [label].
///
/// Parameters:
///   [accountIndex] - The index of the account to add the subaddress to.
///   [label] - The label for the new subaddress.
void addSubaddressSync({required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.subaddress_add_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Sets a label for the specified account in the currently opened Monero wallet.
///
/// Sets a [label] for the account specified by [accountIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account to set the label for.
///   [label] - The label to set for the account.
///
/// Returns:
///   A [Future] that completes with no result.
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

/// Sets a label synchronously for the specified account in the currently opened Monero wallet.
///
/// Sets a [label] synchronously for the account specified by [accountIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account to set the label for.
///   [label] - The label to set for the account.
void setLabelForAccountSync(
    {required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.account_set_label_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Sets a label for the specified subaddress in the currently opened Monero wallet.
///
/// Sets a [label] for the subaddress specified by [accountIndex] and [addressIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account that contains the subaddress.
///   [addressIndex] - The index of the subaddress to set the label for.
///   [label] - The label to set for the subaddress.
///
/// Returns:
///   A [Future] that completes with no result.
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

/// Sets a label synchronously for the specified subaddress in the currently opened Monero wallet.
///
/// Sets a [label] synchronously for the subaddress specified by [accountIndex] and [addressIndex]
/// in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account that contains the subaddress.
///   [addressIndex] - The index of the subaddress to set the label for.
///   [label] - The label to set for the subaddress.
void setLabelForSubaddressSync(
    {required int accountIndex,
    required int addressIndex,
    required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings
      .subaddress_set_label(accountIndex, addressIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

/// Retrieves the address for the specified account and subaddress in the currently opened Monero wallet.
///
/// Retrieves the address for the specified [accountIndex] and [addressIndex] in the currently opened Monero wallet.
/// The default values for [accountIndex] and [addressIndex] are 0, which correspond to the first account and subaddress.
///
/// Parameters:
///   [accountIndex] - The index of the account.
///   [addressIndex] - The index of the subaddress.
///
/// Returns:
///   The address as a string.
String getAddress({int accountIndex = 0, int addressIndex = 0}) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final addressPointer =
      monero_flutter.bindings.get_address(accountIndex, addressIndex, errorBoxPointer);

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return address;
}

/// Retrieves the total balance of the specified account in the currently opened Monero wallet.
///
/// Retrieves the total balance of the account specified by [accountIndex] in the currently opened Monero wallet.
/// The default value for [accountIndex] is 0, which corresponds to the first account.
///
/// Parameters:
///   [accountIndex] - The index of the account.
///
/// Returns:
///   The total balance of the account as an integer.
int getFullBalance({int accountIndex = 0}){
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_full_balance(accountIndex, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves the unlocked balance of the specified account in the currently opened Monero wallet.
///
/// Retrieves the unlocked balance of the account specified by [accountIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account.
///
/// Returns:
///   The unlocked balance of the account as an integer.
int getUnlockedBalance(int accountIndex){
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_unlocked_balance(accountIndex, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves the label of the specified subaddress in the currently opened Monero wallet.
///
/// Retrieves the label of the subaddress specified by [accountIndex] and [addressIndex]
/// in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account that contains the subaddress.
///   [addressIndex] - The index of the subaddress.
///
/// Returns:
///   The label of the subaddress as a string.
String getSubaddressLabel(int accountIndex, int addressIndex) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final labelPointer =
      monero_flutter.bindings.get_subaddress_label(accountIndex, addressIndex, errorBoxPointer);

  final label = labelPointer.cast<Utf8>().toDartString();
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return label;
}

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'entities/account_row.dart';
import 'entities/error_info.dart';
import 'entities/subaddress_row.dart';
import 'monero_flutter.dart' as monero_flutter;
import 'monero_flutter_bindings_generated.dart';

bool isUpdating = false;

/// Refreshes the accounts of the currently opened Monero wallet.
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
/// Refreshes the subaddresses of the account specified by [accountIndex] in the currently opened Monero wallet.
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

/// Retrieves accounts in the currently opened Monero wallet.
///
/// Returns:
///   The total number of accounts as an integer.
List<AccountRow> getAllAccount() {
  final size = getAccountCount();

  if (0 == size) {
    return [];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final accountAddressesPointer = monero_flutter.bindings.account_get_all(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  final accountAddresses = accountAddressesPointer.asTypedList(size);
  final result = accountAddresses.map((addr) => Pointer<ExternalAccountRow>.fromAddress(addr).ref.buildAccountRow()).toList();
  monero_flutter.bindings.free_block_of_accounts(accountAddressesPointer, size);

  return result;
}

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

/// `.getSubaddresses()` method returns a list of created subaddresses for an
/// account. A subaddress is added to the list either when `.createSubaddress()`
/// is called, or when an output is received by a subaddress. When an output
/// is received, account's subaddresses list will be populated with all the
/// subaddresses up to an index of the receiving subaddress. At index 0 of the
/// list is the account's primary address. Therefore, if we never manually call
/// `.createSubaddress()`, the length of this list tells us exactly the index of
/// the next unused subaddress, since the list has only been updated on address use.
List<SubaddressRow> getAllSubaddresses() {
  final size = getSubaddressesCount();

  if (0 == size) {
    return [];
  }

  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  final subaddressAddressesPointer = monero_flutter.bindings.subaddress_get_all(errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  final subaddressAddresses = subaddressAddressesPointer.asTypedList(size);
  final result = subaddressAddresses.map((addr) => Pointer<ExternalSubaddressRow>.fromAddress(addr).ref.buildSubaddressRow()).toList();
  monero_flutter.bindings.free_block_of_subaddresses(subaddressAddressesPointer, size);

  return result;
}

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
  await compute<Map<String, Object>, void>(_addSubaddress, {'accountIndex': accountIndex, 'label': label});
  //await store();
}

void _addSubaddress(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  addSubaddressSync(accountIndex: accountIndex, label: label);
}

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

/// Sets a [label] for the account specified by [accountIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account to set the label for.
///   [label] - The label to set for the account.
///
/// Returns:
///   A [Future] that completes with no result.
Future<void> setLabelForAccount({required int accountIndex, required String label}) async {
  await compute(_setLabelForAccount, {'accountIndex': accountIndex, 'label': label});
  //await store();
}

void _setLabelForAccount(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  setLabelForAccountSync(label: label, accountIndex: accountIndex);
}

/// Sets a [label] synchronously for the account specified by [accountIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account to set the label for.
///   [label] - The label to set for the account.
void setLabelForAccountSync({required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.account_set_label_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

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
  await compute<Map<String, Object>, void>(
      _setLabelForSubaddress, {'accountIndex': accountIndex, 'addressIndex': addressIndex, 'label': label});
  //await store();
}

void _setLabelForSubaddress(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;
  final addressIndex = args['addressIndex'] as int;

  setLabelForSubaddressSync(accountIndex: accountIndex, addressIndex: addressIndex, label: label);
}

/// Sets a [label] synchronously for the subaddress specified by [accountIndex] and [addressIndex]
/// in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account that contains the subaddress.
///   [addressIndex] - The index of the subaddress to set the label for.
///   [label] - The label to set for the subaddress.
void setLabelForSubaddressSync({required int accountIndex, required int addressIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();

  monero_flutter.bindings.subaddress_set_label(accountIndex, addressIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

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
  final addressPointer = monero_flutter.bindings.get_address(accountIndex, addressIndex, errorBoxPointer);

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return address;
}

/// Retrieves the total balance of the account specified by [accountIndex] in the currently opened Monero wallet.
/// The default value for [accountIndex] is 0, which corresponds to the first account.
///
/// Parameters:
///   [accountIndex] - The index of the account.
///
/// Returns:
///   The total balance of the account as an integer.
int getFullBalance({int accountIndex = 0}) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_full_balance(accountIndex, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

/// Retrieves the unlocked balance of the account specified by [accountIndex] in the currently opened Monero wallet.
///
/// Parameters:
///   [accountIndex] - The index of the account.
///
/// Returns:
///   The unlocked balance of the account as an integer.
int getUnlockedBalance(int accountIndex) {
  final errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final result = monero_flutter.bindings.get_unlocked_balance(accountIndex, errorBoxPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

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
  final labelPointer = monero_flutter.bindings.get_subaddress_label(accountIndex, addressIndex, errorBoxPointer);

  final label = labelPointer.cast<Utf8>().toDartString();
  calloc.free(labelPointer);

  final errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return label;
}

/// Retrieves the receive address for the wallet. A new address is generated
/// after an output is received at the old address.
///
/// Returns:
/// A string representing the receive address.
///
/// Description:
/// The receive address is a subaddress belonging to account 0. If no subaddresses
/// have been manually created using `.createSubaddress()`, the next unused
/// subaddress will be returned. The subaddresses list is updated automatically
/// when an output is received by a subaddress or when `.addSubaddress()` is called.
String getReceiveAddress() {
  Pointer<ErrorBox> errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final addressIndex = monero_flutter.bindings.get_num_subaddresses(0, errorBoxPointer);

  ErrorInfo errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  errorBoxPointer = monero_flutter.buildErrorBoxPointer();
  final addressPointer = monero_flutter.bindings.get_address(0, addressIndex, errorBoxPointer);

  errorInfo = monero_flutter.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  return address;
}
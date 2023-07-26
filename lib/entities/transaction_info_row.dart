import 'dart:ffi';

import 'package:ffi/ffi.dart';

final class ExternalTransactionInfoRow extends Struct {
  @Uint64()
  external int amount;

  @Uint64()
  external int fee;

  @Uint64()
  external int blockHeight;

  @Uint64()
  external int confirmations;

  @Uint32()
  external int subaddrAccount;

  @Int8()
  external int direction;

  @Int8()
  external int isPending;

  @Uint32()
  external int subaddrIndex;

  external Pointer<Utf8> hash;

  external Pointer<Utf8> paymentId;

  @Int64()
  external int datetime;

  TransactionInfoRow buildTransactionInfoRow() {
    return TransactionInfoRow(amount >= 0 ? amount : amount * -1, fee, blockHeight, confirmations, subaddrAccount,
        direction, isPending != 0, subaddrIndex, hash.toDartString(), paymentId.toDartString(), datetime);
  }
}

class TransactionInfoRow {
  final int _amount;
  final int _fee;
  final int _blockHeight;
  final int _confirmations;
  final int _subaddrAccount;
  final int _direction;
  final bool _isPending;
  final int _subaddrIndex;
  final String _hash;
  final String _paymentId;
  final int _datetime;

  int get amount {
    return _amount;
  }

  int get fee {
    return _fee;
  }

  int get blockHeight {
    return _blockHeight;
  }

  int get confirmations {
    return _confirmations;
  }

  int get subaddrAccount {
    return _subaddrAccount;
  }

  int get direction {
    return _direction;
  }

  bool get isPending {
    return _isPending;
  }

  int get subaddrIndex {
    return _subaddrIndex;
  }

  String get hash {
    return _hash;
  }

  String get paymentId {
    return _paymentId;
  }

  int get datetime {
    return _datetime;
  }

  TransactionInfoRow(
    this._amount,
    this._fee,
    this._blockHeight,
    this._confirmations,
    this._subaddrAccount,
    this._direction,
    this._isPending,
    this._subaddrIndex,
    this._hash,
    this._paymentId,
    this._datetime,
  );

  @override
  String toString() {
    return "(_amount: $_amount,_fee: $_fee,_blockHeight: $_blockHeight,_confirmations: $_confirmations,"
        "_subaddrAccount: $_subaddrAccount,_direction: $_direction,_isPending: $_isPending,_subaddrIndex: "
        "$_subaddrIndex,_hash: $_hash,_paymentId: $_paymentId,_datetime: $_datetime)";
  }
}

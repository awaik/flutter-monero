// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxsResponse _$TxsResponseFromJson(Map<String, dynamic> json) => TxsResponse(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => TxResponseBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxsResponseToJson(TxsResponse instance) =>
    <String, dynamic>{
      'blocks': instance.blocks.map((e) => e.toJson()).toList(),
    };

TxResponseBlock _$TxResponseBlockFromJson(Map<String, dynamic> json) =>
    TxResponseBlock(
      height: json['height'] as int,
      timestamp: json['timestamp'] as int,
      txs: (json['txs'] as List<dynamic>)
          .map((e) => TxResponseTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxResponseBlockToJson(TxResponseBlock instance) =>
    <String, dynamic>{
      'height': instance.height,
      'timestamp': instance.timestamp,
      'txs': instance.txs.map((e) => e.toJson()).toList(),
    };

TxResponseTransaction _$TxResponseTransactionFromJson(
        Map<String, dynamic> json) =>
    TxResponseTransaction(
      fee: json['fee'] as int,
      numConfirmations: json['numConfirmations'] as int,
      unlockHeight: json['unlockHeight'] as int,
      hash: json['hash'] as String,
      isMinerTx: json['isMinerTx'] as bool,
      relay: json['relay'] as bool,
      isRelayed: json['isRelayed'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
      inTxPool: json['inTxPool'] as bool,
      isDoubleSpendSeen: json['isDoubleSpendSeen'] as bool,
      isFailed: json['isFailed'] as bool,
      isIncoming: json['isIncoming'] as bool,
      isOutgoing: json['isOutgoing'] as bool,
      isLocked: json['isLocked'] as bool,
      incomingTransfers: (json['incomingTransfers'] as List<dynamic>)
          .map((e) =>
              TxResponseIncomingTransfer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxResponseTransactionToJson(
        TxResponseTransaction instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'numConfirmations': instance.numConfirmations,
      'unlockHeight': instance.unlockHeight,
      'hash': instance.hash,
      'isMinerTx': instance.isMinerTx,
      'relay': instance.relay,
      'isRelayed': instance.isRelayed,
      'isConfirmed': instance.isConfirmed,
      'inTxPool': instance.inTxPool,
      'isDoubleSpendSeen': instance.isDoubleSpendSeen,
      'isFailed': instance.isFailed,
      'isIncoming': instance.isIncoming,
      'isOutgoing': instance.isOutgoing,
      'isLocked': instance.isLocked,
      'incomingTransfers':
          instance.incomingTransfers.map((e) => e.toJson()).toList(),
    };

TxResponseIncomingTransfer _$TxResponseIncomingTransferFromJson(
        Map<String, dynamic> json) =>
    TxResponseIncomingTransfer(
      amount: json['amount'] as int,
      accountIndex: json['accountIndex'] as int,
      subaddressIndex: json['subaddressIndex'] as int,
      numSuggestedConfirmations: json['numSuggestedConfirmations'] as int,
      address: json['address'] as String,
    );

Map<String, dynamic> _$TxResponseIncomingTransferToJson(
        TxResponseIncomingTransfer instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'accountIndex': instance.accountIndex,
      'subaddressIndex': instance.subaddressIndex,
      'numSuggestedConfirmations': instance.numSuggestedConfirmations,
      'address': instance.address,
    };

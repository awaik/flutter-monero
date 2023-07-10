// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_tx_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxResponse _$TxResponseFromJson(Map<String, dynamic> json) => TxResponse(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => Block.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxResponseToJson(TxResponse instance) =>
    <String, dynamic>{
      'blocks': instance.blocks,
    };

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      height: json['height'] as int,
      timestamp: json['timestamp'] as int,
      txs: (json['txs'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'height': instance.height,
      'timestamp': instance.timestamp,
      'txs': instance.txs,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
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
          .map((e) => IncomingTransfer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
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
      'incomingTransfers': instance.incomingTransfers,
    };

IncomingTransfer _$IncomingTransferFromJson(Map<String, dynamic> json) =>
    IncomingTransfer(
      amount: json['amount'] as int,
      accountIndex: json['accountIndex'] as int,
      subaddressIndex: json['subaddressIndex'] as int,
      numSuggestedConfirmations: json['numSuggestedConfirmations'] as int,
      address: json['address'] as String,
    );

Map<String, dynamic> _$IncomingTransferToJson(IncomingTransfer instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'accountIndex': instance.accountIndex,
      'subaddressIndex': instance.subaddressIndex,
      'numSuggestedConfirmations': instance.numSuggestedConfirmations,
      'address': instance.address,
    };

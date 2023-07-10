// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutputsResponse _$OutputsResponseFromJson(Map<String, dynamic> json) =>
    OutputsResponse(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => Block.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutputsResponseToJson(OutputsResponse instance) =>
    <String, dynamic>{
      'blocks': instance.blocks,
    };

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      height: json['height'] as int,
      txs: (json['txs'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'height': instance.height,
      'txs': instance.txs,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      hash: json['hash'] as String,
      relay: json['relay'] as bool,
      isRelayed: json['isRelayed'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
      inTxPool: json['inTxPool'] as bool,
      isDoubleSpendSeen: json['isDoubleSpendSeen'] as bool,
      isFailed: json['isFailed'] as bool,
      outputs: (json['outputs'] as List<dynamic>)
          .map((e) => Output.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLocked: json['isLocked'] as bool,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'relay': instance.relay,
      'isRelayed': instance.isRelayed,
      'isConfirmed': instance.isConfirmed,
      'inTxPool': instance.inTxPool,
      'isDoubleSpendSeen': instance.isDoubleSpendSeen,
      'isFailed': instance.isFailed,
      'outputs': instance.outputs,
      'isLocked': instance.isLocked,
    };

Output _$OutputFromJson(Map<String, dynamic> json) => Output(
      amount: json['amount'] as int,
      index: json['index'] as int,
      stealthPublicKey: json['stealthPublicKey'] as String,
      keyImage: KeyImage.fromJson(json['keyImage'] as Map<String, dynamic>),
      accountIndex: json['accountIndex'] as int,
      subaddressIndex: json['subaddressIndex'] as int,
      isSpent: json['isSpent'] as bool,
      isFrozen: json['isFrozen'] as bool,
    );

Map<String, dynamic> _$OutputToJson(Output instance) => <String, dynamic>{
      'amount': instance.amount,
      'index': instance.index,
      'stealthPublicKey': instance.stealthPublicKey,
      'keyImage': instance.keyImage,
      'accountIndex': instance.accountIndex,
      'subaddressIndex': instance.subaddressIndex,
      'isSpent': instance.isSpent,
      'isFrozen': instance.isFrozen,
    };

KeyImage _$KeyImageFromJson(Map<String, dynamic> json) => KeyImage(
      hex: json['hex'] as String,
    );

Map<String, dynamic> _$KeyImageToJson(KeyImage instance) => <String, dynamic>{
      'hex': instance.hex,
    };

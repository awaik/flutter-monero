// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutputsResponse _$OutputsResponseFromJson(Map<String, dynamic> json) =>
    OutputsResponse(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => OutputsResponseBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutputsResponseToJson(OutputsResponse instance) =>
    <String, dynamic>{
      'blocks': instance.blocks,
    };

OutputsResponseBlock _$OutputsResponseBlockFromJson(
        Map<String, dynamic> json) =>
    OutputsResponseBlock(
      height: json['height'] as int,
      txs: (json['txs'] as List<dynamic>)
          .map((e) =>
              OutputsResponseTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutputsResponseBlockToJson(
        OutputsResponseBlock instance) =>
    <String, dynamic>{
      'height': instance.height,
      'txs': instance.txs,
    };

OutputsResponseTransaction _$OutputsResponseTransactionFromJson(
        Map<String, dynamic> json) =>
    OutputsResponseTransaction(
      hash: json['hash'] as String,
      relay: json['relay'] as bool,
      isRelayed: json['isRelayed'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
      inTxPool: json['inTxPool'] as bool,
      isDoubleSpendSeen: json['isDoubleSpendSeen'] as bool,
      isFailed: json['isFailed'] as bool,
      outputs: (json['outputs'] as List<dynamic>)
          .map((e) => OutputsResponseOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLocked: json['isLocked'] as bool,
    );

Map<String, dynamic> _$OutputsResponseTransactionToJson(
        OutputsResponseTransaction instance) =>
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

OutputsResponseOutput _$OutputsResponseOutputFromJson(
        Map<String, dynamic> json) =>
    OutputsResponseOutput(
      amount: json['amount'] as int,
      index: json['index'] as int,
      stealthPublicKey: json['stealthPublicKey'] as String,
      keyImage: OutputsResponseKeyImage.fromJson(
          json['keyImage'] as Map<String, dynamic>),
      accountIndex: json['accountIndex'] as int,
      subaddressIndex: json['subaddressIndex'] as int,
      isSpent: json['isSpent'] as bool,
      isFrozen: json['isFrozen'] as bool,
    );

Map<String, dynamic> _$OutputsResponseOutputToJson(
        OutputsResponseOutput instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'index': instance.index,
      'stealthPublicKey': instance.stealthPublicKey,
      'keyImage': instance.keyImage,
      'accountIndex': instance.accountIndex,
      'subaddressIndex': instance.subaddressIndex,
      'isSpent': instance.isSpent,
      'isFrozen': instance.isFrozen,
    };

OutputsResponseKeyImage _$OutputsResponseKeyImageFromJson(
        Map<String, dynamic> json) =>
    OutputsResponseKeyImage(
      hex: json['hex'] as String,
    );

Map<String, dynamic> _$OutputsResponseKeyImageToJson(
        OutputsResponseKeyImage instance) =>
    <String, dynamic>{
      'hex': instance.hex,
    };

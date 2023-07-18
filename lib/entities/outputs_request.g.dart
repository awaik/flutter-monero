// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutputsRequest _$OutputsRequestFromJson(Map<String, dynamic> json) =>
    OutputsRequest(
      minAmount: json['minAmount'] as int?,
      amount: json['amount'] as int?,
      maxAmount: json['maxAmount'] as int?,
      index: json['index'] as int?,
      accountIndex: json['accountIndex'] as int?,
      subaddressIndex: json['subaddressIndex'] as int?,
      keyImage: json['keyImage'] == null
          ? null
          : OutputsRequestKeyImage.fromJson(
              json['keyImage'] as Map<String, dynamic>),
      isSpent: json['isSpent'] as bool?,
      isFrozen: json['isFrozen'] as bool?,
      txQuery: json['txQuery'] == null
          ? null
          : OutputsRequestTxQuery.fromJson(
              json['txQuery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutputsRequestToJson(OutputsRequest instance) =>
    <String, dynamic>{
      'minAmount': instance.minAmount,
      'amount': instance.amount,
      'maxAmount': instance.maxAmount,
      'index': instance.index,
      'accountIndex': instance.accountIndex,
      'subaddressIndex': instance.subaddressIndex,
      'keyImage': instance.keyImage?.toJson(),
      'isSpent': instance.isSpent,
      'isFrozen': instance.isFrozen,
      'txQuery': instance.txQuery?.toJson(),
    };

OutputsRequestKeyImage _$OutputsRequestKeyImageFromJson(
        Map<String, dynamic> json) =>
    OutputsRequestKeyImage(
      hex: json['hex'] as String?,
      signature: json['signature'] as String?,
    );

Map<String, dynamic> _$OutputsRequestKeyImageToJson(
        OutputsRequestKeyImage instance) =>
    <String, dynamic>{
      'hex': instance.hex,
      'signature': instance.signature,
    };

OutputsRequestTxQuery _$OutputsRequestTxQueryFromJson(
        Map<String, dynamic> json) =>
    OutputsRequestTxQuery(
      isOutgoing: json['isOutgoing'] as bool?,
      isIncoming: json['isIncoming'] as bool?,
      isLocked: json['isLocked'] as bool?,
      isConfirmed: json['isConfirmed'] as bool?,
      isRelayed: json['isRelayed'] as bool?,
      isDoubleSpendSeen: json['isDoubleSpendSeen'] as bool?,
      inputSum: json['inputSum'] as int?,
      outputSum: json['outputSum'] as int?,
    );

Map<String, dynamic> _$OutputsRequestTxQueryToJson(
        OutputsRequestTxQuery instance) =>
    <String, dynamic>{
      'isOutgoing': instance.isOutgoing,
      'isIncoming': instance.isIncoming,
      'isLocked': instance.isLocked,
      'isConfirmed': instance.isConfirmed,
      'isRelayed': instance.isRelayed,
      'isDoubleSpendSeen': instance.isDoubleSpendSeen,
      'inputSum': instance.inputSum,
      'outputSum': instance.outputSum,
    };

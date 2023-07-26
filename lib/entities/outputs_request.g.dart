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

Map<String, dynamic> _$OutputsRequestToJson(OutputsRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('minAmount', instance.minAmount);
  writeNotNull('amount', instance.amount);
  writeNotNull('maxAmount', instance.maxAmount);
  writeNotNull('index', instance.index);
  writeNotNull('accountIndex', instance.accountIndex);
  writeNotNull('subaddressIndex', instance.subaddressIndex);
  writeNotNull('keyImage', instance.keyImage?.toJson());
  writeNotNull('isSpent', instance.isSpent);
  writeNotNull('isFrozen', instance.isFrozen);
  writeNotNull('txQuery', instance.txQuery?.toJson());
  return val;
}

OutputsRequestKeyImage _$OutputsRequestKeyImageFromJson(
        Map<String, dynamic> json) =>
    OutputsRequestKeyImage(
      hex: json['hex'] as String?,
      signature: json['signature'] as String?,
    );

Map<String, dynamic> _$OutputsRequestKeyImageToJson(
    OutputsRequestKeyImage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hex', instance.hex);
  writeNotNull('signature', instance.signature);
  return val;
}

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
    OutputsRequestTxQuery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isOutgoing', instance.isOutgoing);
  writeNotNull('isIncoming', instance.isIncoming);
  writeNotNull('isLocked', instance.isLocked);
  writeNotNull('isConfirmed', instance.isConfirmed);
  writeNotNull('isRelayed', instance.isRelayed);
  writeNotNull('isDoubleSpendSeen', instance.isDoubleSpendSeen);
  writeNotNull('inputSum', instance.inputSum);
  writeNotNull('outputSum', instance.outputSum);
  return val;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxQuery _$TxQueryFromJson(Map<String, dynamic> json) => TxQuery(
      isLocked: json['isLocked'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
    );

Map<String, dynamic> _$TxQueryToJson(TxQuery instance) => <String, dynamic>{
      'isLocked': instance.isLocked,
      'isConfirmed': instance.isConfirmed,
    };

OutputsRequest _$OutputsRequestFromJson(Map<String, dynamic> json) =>
    OutputsRequest(
      isSpent: json['isSpent'] as bool,
      txQuery: TxQuery.fromJson(json['txQuery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutputsRequestToJson(OutputsRequest instance) =>
    <String, dynamic>{
      'isSpent': instance.isSpent,
      'txQuery': instance.txQuery,
    };

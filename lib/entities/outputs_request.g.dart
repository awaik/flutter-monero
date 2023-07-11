// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutputsRequest _$OutputsRequestFromJson(Map<String, dynamic> json) =>
    OutputsRequest(
      isSpent: json['isSpent'] as bool,
      txQuery: OutputsRequestTxQuery.fromJson(
          json['txQuery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutputsRequestToJson(OutputsRequest instance) =>
    <String, dynamic>{
      'isSpent': instance.isSpent,
      'txQuery': instance.txQuery,
    };

OutputsRequestTxQuery _$OutputsRequestTxQueryFromJson(
        Map<String, dynamic> json) =>
    OutputsRequestTxQuery(
      isLocked: json['isLocked'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
    );

Map<String, dynamic> _$OutputsRequestTxQueryToJson(
        OutputsRequestTxQuery instance) =>
    <String, dynamic>{
      'isLocked': instance.isLocked,
      'isConfirmed': instance.isConfirmed,
    };

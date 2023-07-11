// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txs_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxsRequest _$TxsRequestFromJson(Map<String, dynamic> json) => TxsRequest(
      txs: (json['txs'] as List<dynamic>)
          .map((e) => TxsRequestBody.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxsRequestToJson(TxsRequest instance) =>
    <String, dynamic>{
      'txs': instance.txs,
    };

TxsRequestBody _$TxsRequestBodyFromJson(Map<String, dynamic> json) =>
    TxsRequestBody(
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$TxsRequestBodyToJson(TxsRequestBody instance) =>
    <String, dynamic>{
      'hash': instance.hash,
    };

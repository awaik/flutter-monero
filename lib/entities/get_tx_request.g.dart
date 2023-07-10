// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_tx_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxRequest _$TxRequestFromJson(Map<String, dynamic> json) => TxRequest(
      txs: (json['txs'] as List<dynamic>)
          .map((e) => Tx.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxRequestToJson(TxRequest instance) => <String, dynamic>{
      'txs': instance.txs,
    };

Tx _$TxFromJson(Map<String, dynamic> json) => Tx(
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$TxToJson(Tx instance) => <String, dynamic>{
      'hash': instance.hash,
    };

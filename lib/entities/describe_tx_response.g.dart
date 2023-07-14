// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'describe_tx_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DescribeTxResponse _$DescribeTxResponseFromJson(Map<String, dynamic> json) =>
    DescribeTxResponse(
      txs: (json['txs'] as List<dynamic>)
          .map((e) =>
              DescribeTxResponseTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DescribeTxResponseToJson(DescribeTxResponse instance) =>
    <String, dynamic>{
      'txs': instance.txs.map((e) => e.toJson()).toList(),
    };

DescribeTxResponseTransaction _$DescribeTxResponseTransactionFromJson(
        Map<String, dynamic> json) =>
    DescribeTxResponseTransaction(
      fee: json['fee'] as int,
      ringSize: json['ringSize'] as int,
      unlockHeight: json['unlockHeight'] as int,
      inputSum: json['inputSum'] as int,
      outputSum: json['outputSum'] as int,
      changeAmount: json['changeAmount'] as int,
      numDummyOutputs: json['numDummyOutputs'] as int,
      extraHex: json['extraHex'] as String,
      isOutgoing: json['isOutgoing'] as bool,
      outgoingTransfer: json['outgoingTransfer'] == null
          ? null
          : DescribeTxResponseOutgoingTransfer.fromJson(
              json['outgoingTransfer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DescribeTxResponseTransactionToJson(
        DescribeTxResponseTransaction instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'ringSize': instance.ringSize,
      'unlockHeight': instance.unlockHeight,
      'inputSum': instance.inputSum,
      'outputSum': instance.outputSum,
      'changeAmount': instance.changeAmount,
      'numDummyOutputs': instance.numDummyOutputs,
      'extraHex': instance.extraHex,
      'isOutgoing': instance.isOutgoing,
      'outgoingTransfer': instance.outgoingTransfer?.toJson(),
    };

DescribeTxResponseOutgoingTransfer _$DescribeTxResponseOutgoingTransferFromJson(
        Map<String, dynamic> json) =>
    DescribeTxResponseOutgoingTransfer(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) =>
              DescribeTxResponseDestination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DescribeTxResponseOutgoingTransferToJson(
        DescribeTxResponseOutgoingTransfer instance) =>
    <String, dynamic>{
      'destinations': instance.destinations.map((e) => e.toJson()).toList(),
    };

DescribeTxResponseDestination _$DescribeTxResponseDestinationFromJson(
        Map<String, dynamic> json) =>
    DescribeTxResponseDestination(
      amount: json['amount'] as int,
      address: json['address'] as String,
    );

Map<String, dynamic> _$DescribeTxResponseDestinationToJson(
        DescribeTxResponseDestination instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'address': instance.address,
    };

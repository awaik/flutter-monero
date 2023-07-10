// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'describe_tx_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxSet _$TxSetFromJson(Map<String, dynamic> json) => TxSet(
      txs: (json['txs'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxSetToJson(TxSet instance) => <String, dynamic>{
      'txs': instance.txs,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
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
          : OutgoingTransfer.fromJson(
              json['outgoingTransfer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
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
      'outgoingTransfer': instance.outgoingTransfer,
    };

OutgoingTransfer _$OutgoingTransferFromJson(Map<String, dynamic> json) =>
    OutgoingTransfer(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => Destination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutgoingTransferToJson(OutgoingTransfer instance) =>
    <String, dynamic>{
      'destinations': instance.destinations,
    };

Destination _$DestinationFromJson(Map<String, dynamic> json) => Destination(
      amount: json['amount'] as int,
      address: json['address'] as String,
    );

Map<String, dynamic> _$DestinationToJson(Destination instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'address': instance.address,
    };

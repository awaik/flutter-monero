// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simplified_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimplifiedTransactionRequest _$SimplifiedTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    SimplifiedTransactionRequest(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => SimplifiedTransactionRequestDestination.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SimplifiedTransactionRequestToJson(
        SimplifiedTransactionRequest instance) =>
    <String, dynamic>{
      'destinations': instance.destinations.map((e) => e.toJson()).toList(),
    };

SimplifiedTransactionRequestDestination
    _$SimplifiedTransactionRequestDestinationFromJson(
            Map<String, dynamic> json) =>
        SimplifiedTransactionRequestDestination(
          address: json['address'] as String,
          amount: json['amount'] as int,
        );

Map<String, dynamic> _$SimplifiedTransactionRequestDestinationToJson(
        SimplifiedTransactionRequestDestination instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': instance.amount,
    };

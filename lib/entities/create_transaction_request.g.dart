// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransactionRequest _$CreateTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionRequest(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => CreateTransactionRequestDestination.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      accountIndex: json['accountIndex'] as int?,
      subaddressIndices: (json['subaddressIndices'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      fee: json['fee'] as int?,
    );

Map<String, dynamic> _$CreateTransactionRequestToJson(
    CreateTransactionRequest instance) {
  final val = <String, dynamic>{
    'destinations': instance.destinations.map((e) => e.toJson()).toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('accountIndex', instance.accountIndex);
  writeNotNull('subaddressIndices', instance.subaddressIndices);
  writeNotNull('fee', instance.fee);
  return val;
}

CreateTransactionRequestDestination
    _$CreateTransactionRequestDestinationFromJson(Map<String, dynamic> json) =>
        CreateTransactionRequestDestination(
          address: json['address'] as String,
          amount: json['amount'] as int,
        );

Map<String, dynamic> _$CreateTransactionRequestDestinationToJson(
        CreateTransactionRequestDestination instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': instance.amount,
    };

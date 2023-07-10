// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sweep_unlocked_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SweepUnlockedRequest _$SweepUnlockedRequestFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedRequest(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => Destination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SweepUnlockedRequestToJson(
        SweepUnlockedRequest instance) =>
    <String, dynamic>{
      'destinations': instance.destinations,
    };

Destination _$DestinationFromJson(Map<String, dynamic> json) => Destination(
      address: json['address'] as String,
    );

Map<String, dynamic> _$DestinationToJson(Destination instance) =>
    <String, dynamic>{
      'address': instance.address,
    };

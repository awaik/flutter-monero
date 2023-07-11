// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sweep_unlocked_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SweepUnlockedRequest _$SweepUnlockedRequestFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedRequest(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => SweepUnlockedRequestDestination.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SweepUnlockedRequestToJson(
        SweepUnlockedRequest instance) =>
    <String, dynamic>{
      'destinations': instance.destinations,
    };

SweepUnlockedRequestDestination _$SweepUnlockedRequestDestinationFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedRequestDestination(
      address: json['address'] as String,
    );

Map<String, dynamic> _$SweepUnlockedRequestDestinationToJson(
        SweepUnlockedRequestDestination instance) =>
    <String, dynamic>{
      'address': instance.address,
    };

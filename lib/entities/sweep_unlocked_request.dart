import 'package:json_annotation/json_annotation.dart';
part 'sweep_unlocked_request.g.dart';

@JsonSerializable()
class SweepUnlockedRequest {
  List<Destination> destinations;

  SweepUnlockedRequest({
    required this.destinations,
  });

  factory SweepUnlockedRequest.fromJson(Map<String, dynamic> json) => _$SweepUnlockedRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedRequestToJson(this);
}

@JsonSerializable()
class Destination {
  String address;

  Destination({
    required this.address,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => _$DestinationFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationToJson(this);
}
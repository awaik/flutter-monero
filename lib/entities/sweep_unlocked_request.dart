import 'package:json_annotation/json_annotation.dart';
part 'sweep_unlocked_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SweepUnlockedRequest {
  List<SweepUnlockedRequestDestination> destinations;

  SweepUnlockedRequest({
    required this.destinations,
  });

  factory SweepUnlockedRequest.fromJson(Map<String, dynamic> json) => _$SweepUnlockedRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SweepUnlockedRequestDestination {
  String address;

  SweepUnlockedRequestDestination({
    required this.address,
  });

  factory SweepUnlockedRequestDestination.fromJson(Map<String, dynamic> json) => _$SweepUnlockedRequestDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedRequestDestinationToJson(this);
}
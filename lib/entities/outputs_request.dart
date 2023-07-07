import 'package:json_annotation/json_annotation.dart';
part 'outputs_request.g.dart';

@JsonSerializable()
class OutputsRequest {

  @JsonKey()
  String? hash;

  OutputsRequest(this.hash);

  factory OutputsRequest.fromJson(Map<String, dynamic> json) => _$OutputsRequest(json);
  Map<String, dynamic> toJson() => _$OutputsRequest(this);
}
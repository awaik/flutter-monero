import 'package:json_annotation/json_annotation.dart';
part 'outputs_request.g.dart';

@JsonSerializable()
class TxQuery {
  bool isLocked;
  bool isConfirmed;

  TxQuery({
    required this.isLocked,
    required this.isConfirmed,
  });

  factory TxQuery.fromJson(Map<String, dynamic> json) => _$TxQueryFromJson(json);
  Map<String, dynamic> toJson() => _$TxQueryToJson(this);
}

@JsonSerializable()
class OutputsRequest {

  bool isSpent;

  @JsonKey(name: "txQuery")
  TxQuery txQuery;

  OutputsRequest({
    required this.isSpent,
    required this.txQuery,
  });

  factory OutputsRequest.fromJson(Map<String, dynamic> json) => _$OutputsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsRequestToJson(this);
}
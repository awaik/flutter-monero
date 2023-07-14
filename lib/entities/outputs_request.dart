import 'package:json_annotation/json_annotation.dart';
part 'outputs_request.g.dart';

@JsonSerializable(explicitToJson: true)
class OutputsRequest {

  bool isSpent;

  @JsonKey(name: "txQuery")
  OutputsRequestTxQuery txQuery;

  OutputsRequest({
    required this.isSpent,
    required this.txQuery,
  });

  factory OutputsRequest.fromJson(Map<String, dynamic> json) => _$OutputsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OutputsRequestTxQuery {
  bool isLocked;
  bool isConfirmed;

  OutputsRequestTxQuery({
    required this.isLocked,
    required this.isConfirmed,
  });

  factory OutputsRequestTxQuery.fromJson(Map<String, dynamic> json) => _$OutputsRequestTxQueryFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsRequestTxQueryToJson(this);
}
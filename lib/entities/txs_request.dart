import 'package:json_annotation/json_annotation.dart';
part 'txs_request.g.dart';

@JsonSerializable()
class TxsRequest {
  List<TxsRequestBody> txs;

  TxsRequest({
    required this.txs,
  });

  factory TxsRequest.fromJson(Map<String, dynamic> json) => _$TxsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TxsRequestToJson(this);
}

@JsonSerializable()
class TxsRequestBody {
  String hash;

  TxsRequestBody({
    required this.hash,
  });

  factory TxsRequestBody.fromJson(Map<String, dynamic> json) => _$TxsRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$TxsRequestBodyToJson(this);
}
import 'package:json_annotation/json_annotation.dart';
part 'describe_tx_request.g.dart';

@JsonSerializable()
class DescribeTxRequest {
  String unsignedTxHex;

  DescribeTxRequest({
    required this.unsignedTxHex,
  });

  factory DescribeTxRequest.fromJson(Map<String, dynamic> json) => _$DescribeTxRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeTxRequestToJson(this);
}
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'describe_tx_request.dart';
part 'describe_unsigned_tx_request.g.dart';

@JsonSerializable(explicitToJson: true)
class DescribeUnsignedTxRequest extends DescribeTxRequest {
  String unsignedTxHex;

  DescribeUnsignedTxRequest({
    required this.unsignedTxHex,
  });

  factory DescribeUnsignedTxRequest.fromJson(Map<String, dynamic> json) => _$DescribeUnsignedTxRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeUnsignedTxRequestToJson(this);

  @override
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
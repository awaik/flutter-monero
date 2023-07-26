import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'describe_tx_request.dart';
part 'describe_multisig_tx_request.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class DescribeMultisigTxRequest extends DescribeTxRequest {
  String multisigTxHex;

  DescribeMultisigTxRequest({
    required this.multisigTxHex,
  });

  factory DescribeMultisigTxRequest.fromJson(Map<String, dynamic> json) => _$DescribeMultisigTxRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeMultisigTxRequestToJson(this);

  @override
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
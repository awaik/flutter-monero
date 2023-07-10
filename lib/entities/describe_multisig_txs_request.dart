import 'package:json_annotation/json_annotation.dart';
part 'describe_multisig_txs_request.g.dart';

@JsonSerializable()
class DescribeMultisigTxRequest {
  String multisigTxHex;

  DescribeMultisigTxRequest({
    required this.multisigTxHex,
  });

  factory DescribeMultisigTxRequest.fromJson(Map<String, dynamic> json) => _$DescribeMultisigTxRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeMultisigTxRequestToJson(this);
}
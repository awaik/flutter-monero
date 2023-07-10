import 'package:json_annotation/json_annotation.dart';
part 'get_tx_request.g.dart';

@JsonSerializable()
class TxRequest {
  List<Tx> txs;

  TxRequest({
    required this.txs,
  });

  factory TxRequest.fromJson(Map<String, dynamic> json) => _$TxRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TxRequestToJson(this);
}

@JsonSerializable()
class Tx {
  String hash;

  Tx({
    required this.hash,
  });

  factory Tx.fromJson(Map<String, dynamic> json) => _$TxFromJson(json);
  Map<String, dynamic> toJson() => _$TxToJson(this);
}
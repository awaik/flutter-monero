import 'package:json_annotation/json_annotation.dart';
part 'describe_tx_response.g.dart';

@JsonSerializable()
class DescribeTxResponse {
  List<DescribeTxResponseTransaction> txs;

  DescribeTxResponse({
    required this.txs,
  });

  factory DescribeTxResponse.fromJson(Map<String, dynamic> json) => _$DescribeTxResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeTxResponseToJson(this);
}

@JsonSerializable()
class DescribeTxResponseTransaction {
  int fee;
  int ringSize;
  int unlockHeight;
  int inputSum;
  int outputSum;
  int changeAmount;
  int numDummyOutputs;
  String extraHex;
  bool isOutgoing;
  DescribeTxResponseOutgoingTransfer? outgoingTransfer;

  DescribeTxResponseTransaction({
    required this.fee,
    required this.ringSize,
    required this.unlockHeight,
    required this.inputSum,
    required this.outputSum,
    required this.changeAmount,
    required this.numDummyOutputs,
    required this.extraHex,
    required this.isOutgoing,
    this.outgoingTransfer,
  });

  factory DescribeTxResponseTransaction.fromJson(Map<String, dynamic> json) => _$DescribeTxResponseTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeTxResponseTransactionToJson(this);
}

@JsonSerializable()
class DescribeTxResponseOutgoingTransfer {
  List<DescribeTxResponseDestination> destinations;

  DescribeTxResponseOutgoingTransfer({
    required this.destinations,
  });

  factory DescribeTxResponseOutgoingTransfer.fromJson(Map<String, dynamic> json) => _$DescribeTxResponseOutgoingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeTxResponseOutgoingTransferToJson(this);
}

@JsonSerializable()
class DescribeTxResponseDestination {
  int amount;
  String address;

  DescribeTxResponseDestination({
    required this.amount,
    required this.address,
  });

  factory DescribeTxResponseDestination.fromJson(Map<String, dynamic> json) => _$DescribeTxResponseDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$DescribeTxResponseDestinationToJson(this);
}

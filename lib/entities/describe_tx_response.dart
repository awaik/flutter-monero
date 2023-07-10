import 'package:json_annotation/json_annotation.dart';
part 'describe_tx_response.g.dart';

@JsonSerializable()
class TxSet {
  List<Transaction> txs;

  TxSet({
    required this.txs,
  });

  factory TxSet.fromJson(Map<String, dynamic> json) => _$TxSetFromJson(json);
  Map<String, dynamic> toJson() => _$TxSetToJson(this);
}

@JsonSerializable()
class Transaction {
  int fee;
  int ringSize;
  int unlockHeight;
  int inputSum;
  int outputSum;
  int changeAmount;
  int numDummyOutputs;
  String extraHex;
  bool isOutgoing;
  OutgoingTransfer? outgoingTransfer;

  Transaction({
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

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class OutgoingTransfer {
  List<Destination> destinations;

  OutgoingTransfer({
    required this.destinations,
  });

  factory OutgoingTransfer.fromJson(Map<String, dynamic> json) => _$OutgoingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$OutgoingTransferToJson(this);
}

@JsonSerializable()
class Destination {
  int amount;
  String address;

  Destination({
    required this.amount,
    required this.address,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => _$DestinationFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationToJson(this);
}

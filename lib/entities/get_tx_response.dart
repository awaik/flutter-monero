import 'package:json_annotation/json_annotation.dart';
part 'get_tx_response.g.dart';

@JsonSerializable()
class TxResponse {
  List<Block> blocks;

  TxResponse({
    required this.blocks,
  });

  factory TxResponse.fromJson(Map<String, dynamic> json) => _$TxResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TxResponseToJson(this);
}

@JsonSerializable()
class Block {
  int height;
  int timestamp;
  List<Transaction> txs;

  Block({
    required this.height,
    required this.timestamp,
    required this.txs,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}

@JsonSerializable()
class Transaction {
  int fee;
  int numConfirmations;
  int unlockHeight;
  String hash;
  bool isMinerTx;
  bool relay;
  bool isRelayed;
  bool isConfirmed;
  bool inTxPool;
  bool isDoubleSpendSeen;
  bool isFailed;
  bool isIncoming;
  bool isOutgoing;
  bool isLocked;
  List<IncomingTransfer> incomingTransfers;

  Transaction({
    required this.fee,
    required this.numConfirmations,
    required this.unlockHeight,
    required this.hash,
    required this.isMinerTx,
    required this.relay,
    required this.isRelayed,
    required this.isConfirmed,
    required this.inTxPool,
    required this.isDoubleSpendSeen,
    required this.isFailed,
    required this.isIncoming,
    required this.isOutgoing,
    required this.isLocked,
    required this.incomingTransfers,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class IncomingTransfer {
  int amount;
  int accountIndex;
  int subaddressIndex;
  int numSuggestedConfirmations;
  String address;

  IncomingTransfer({
    required this.amount,
    required this.accountIndex,
    required this.subaddressIndex,
    required this.numSuggestedConfirmations,
    required this.address,
  });

  factory IncomingTransfer.fromJson(Map<String, dynamic> json) => _$IncomingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingTransferToJson(this);
}
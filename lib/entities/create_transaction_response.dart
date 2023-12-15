import 'package:json_annotation/json_annotation.dart';

part 'create_transaction_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateTransactionResponse {
  String? unsignedTxHex;
  String? signedTxHex;
  String? multisigTxHex;

  List<CreateTransactionResponseTransaction> txs;

  CreateTransactionResponse({this.unsignedTxHex, this.signedTxHex, this.multisigTxHex, required this.txs});

  factory CreateTransactionResponse.fromJson(Map<String, dynamic> json) => _$CreateTransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateTransactionResponseKeyImage {
  String hex;

  CreateTransactionResponseKeyImage({required this.hex});

  factory CreateTransactionResponseKeyImage.fromJson(Map<String, dynamic> json) => _$CreateTransactionResponseKeyImageFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionResponseKeyImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateTransactionResponseInput {
  CreateTransactionResponseKeyImage keyImage;

  CreateTransactionResponseInput({required this.keyImage});

  factory CreateTransactionResponseInput.fromJson(Map<String, dynamic> json) => _$CreateTransactionResponseInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionResponseInputToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateTransactionResponseDestination {
  int amount;
  String address;

  CreateTransactionResponseDestination({required this.amount, required this.address});

  factory CreateTransactionResponseDestination.fromJson(Map<String, dynamic> json) => _$CreateTransactionResponseDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionResponseDestinationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateTransactionResponseOutgoingTransfer {
  int amount;
  int accountIndex;
  List<CreateTransactionResponseDestination> destinations;

  CreateTransactionResponseOutgoingTransfer({
    required this.amount,
    required this.accountIndex,
    required this.destinations,
  });

  factory CreateTransactionResponseOutgoingTransfer.fromJson(Map<String, dynamic> json) => _$CreateTransactionResponseOutgoingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionResponseOutgoingTransferToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateTransactionResponseTransaction {
  int fee;
  int ringSize;
  int numConfirmations;
  int unlockHeight;
  int weight;
  String hash;
  String key;
  String fullHex;
  String metadata;
  bool isMinerTx;
  bool relay;
  bool isRelayed;
  bool isConfirmed;
  bool inTxPool;
  bool isFailed;
  List<CreateTransactionResponseInput> inputs;
  bool isOutgoing;
  bool isLocked;
  CreateTransactionResponseOutgoingTransfer outgoingTransfer;

  CreateTransactionResponseTransaction({
    required this.fee,
    required this.ringSize,
    required this.numConfirmations,
    required this.unlockHeight,
    required this.weight,
    required this.hash,
    required this.key,
    required this.fullHex,
    required this.metadata,
    required this.isMinerTx,
    required this.relay,
    required this.isRelayed,
    required this.isConfirmed,
    required this.inTxPool,
    required this.isFailed,
    required this.inputs,
    required this.isOutgoing,
    required this.isLocked,
    required this.outgoingTransfer,
  });

  factory CreateTransactionResponseTransaction.fromJson(Map<String, dynamic> json) => _$CreateTransactionResponseTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionResponseTransactionToJson(this);
}
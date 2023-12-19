abstract class TransferInfo {
  final int height;
  final int timestamp;
  final int fee;
  final int numConfirmations;
  final int unlockTime;
  final String hash;
  final bool isMinerTx;
  final bool relay;
  final bool isRelayed;
  final bool isConfirmed;
  final bool inTxPool;
  final bool isDoubleSpendSeen;
  final bool isFailed;
  final bool isIncoming;
  final bool isOutgoing;
  final bool isLocked;

  TransferInfo({
    required this.height,
    required this.timestamp,
    required this.fee,
    required this.numConfirmations,
    required this.unlockTime,
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
  });
}

class IncomingTransferInfo extends TransferInfo {
  final int amount;
  final int accountIndex;
  final int subaddressIndex;
  final int numSuggestedConfirmations;
  final String address;

  IncomingTransferInfo(
      {required super.height,
      required super.timestamp,
      required super.fee,
      required super.numConfirmations,
      required super.unlockTime,
      required super.hash,
      required super.isMinerTx,
      required super.relay,
      required super.isRelayed,
      required super.isConfirmed,
      required super.inTxPool,
      required super.isDoubleSpendSeen,
      required super.isFailed,
      required super.isIncoming,
      required super.isOutgoing,
      required super.isLocked,
      required this.amount,
      required this.accountIndex,
      required this.subaddressIndex,
      required this.numSuggestedConfirmations,
      required this.address});
}

class OutgoingTransferInfo extends TransferInfo {
  final int amount;
  final int accountIndex;
  final List<int> subaddressIndices;
  final List<String> addresses;

  OutgoingTransferInfo({
    required super.height,
    required super.timestamp,
    required super.fee,
    required super.numConfirmations,
    required super.unlockTime,
    required super.hash,
    required super.isMinerTx,
    required super.relay,
    required super.isRelayed,
    required super.isConfirmed,
    required super.inTxPool,
    required super.isDoubleSpendSeen,
    required super.isFailed,
    required super.isIncoming,
    required super.isOutgoing,
    required super.isLocked,
    required this.amount,
    required this.accountIndex,
    required this.subaddressIndices,
    required this.addresses,
  });
}

class Utxo {
  int blockHeight;
  String transactionHash;
  int amount;
  int index;
  String stealthPublicKey;
  String? keyImage;
  int accountIndex;
  int subaddressIndex;
  bool isFrozen;

  Utxo({
    required this.blockHeight,
    required this.transactionHash,
    required this.amount,
    required this.index,
    required this.stealthPublicKey,
    this.keyImage,
    required this.accountIndex,
    required this.subaddressIndex,
    required this.isFrozen,
  });
}
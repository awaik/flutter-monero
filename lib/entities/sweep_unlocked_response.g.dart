// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sweep_unlocked_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      txSets: (json['txSets'] as List<dynamic>)
          .map((e) => TxSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'txSets': instance.txSets,
    };

TxSet _$TxSetFromJson(Map<String, dynamic> json) => TxSet(
      multisigTxHex: json['multisigTxHex'] as String,
      txs: (json['txs'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxSetToJson(TxSet instance) => <String, dynamic>{
      'multisigTxHex': instance.multisigTxHex,
      'txs': instance.txs,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      fee: json['fee'] as int,
      ringSize: json['ringSize'] as int,
      numConfirmations: json['numConfirmations'] as int,
      unlockHeight: json['unlockHeight'] as int,
      weight: json['weight'] as int,
      hash: json['hash'] as String,
      key: json['key'] as String,
      fullHex: json['fullHex'] as String,
      metadata: json['metadata'] as String,
      isMinerTx: json['isMinerTx'] as bool,
      relay: json['relay'] as bool,
      isRelayed: json['isRelayed'] as bool,
      isConfirmed: json['isConfirmed'] as bool,
      inTxPool: json['inTxPool'] as bool,
      isFailed: json['isFailed'] as bool,
      inputs: (json['inputs'] as List<dynamic>)
          .map((e) => Input.fromJson(e as Map<String, dynamic>))
          .toList(),
      isOutgoing: json['isOutgoing'] as bool,
      isLocked: json['isLocked'] as bool,
      outgoingTransfer: json['outgoingTransfer'] == null
          ? null
          : OutgoingTransfer.fromJson(
              json['outgoingTransfer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'ringSize': instance.ringSize,
      'numConfirmations': instance.numConfirmations,
      'unlockHeight': instance.unlockHeight,
      'weight': instance.weight,
      'hash': instance.hash,
      'key': instance.key,
      'fullHex': instance.fullHex,
      'metadata': instance.metadata,
      'isMinerTx': instance.isMinerTx,
      'relay': instance.relay,
      'isRelayed': instance.isRelayed,
      'isConfirmed': instance.isConfirmed,
      'inTxPool': instance.inTxPool,
      'isFailed': instance.isFailed,
      'inputs': instance.inputs,
      'isOutgoing': instance.isOutgoing,
      'isLocked': instance.isLocked,
      'outgoingTransfer': instance.outgoingTransfer,
    };

Input _$InputFromJson(Map<String, dynamic> json) => Input(
      keyImage: KeyImage.fromJson(json['keyImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
      'keyImage': instance.keyImage,
    };

KeyImage _$KeyImageFromJson(Map<String, dynamic> json) => KeyImage(
      hex: json['hex'] as String,
    );

Map<String, dynamic> _$KeyImageToJson(KeyImage instance) => <String, dynamic>{
      'hex': instance.hex,
    };

OutgoingTransfer _$OutgoingTransferFromJson(Map<String, dynamic> json) =>
    OutgoingTransfer(
      amount: json['amount'] as int,
      accountIndex: json['accountIndex'] as int,
      subaddressIndices: (json['subaddressIndices'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => Destination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutgoingTransferToJson(OutgoingTransfer instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'accountIndex': instance.accountIndex,
      'subaddressIndices': instance.subaddressIndices,
      'destinations': instance.destinations,
    };

Destination _$DestinationFromJson(Map<String, dynamic> json) => Destination(
      amount: json['amount'] as int,
      address: json['address'] as String,
    );

Map<String, dynamic> _$DestinationToJson(Destination instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'address': instance.address,
    };

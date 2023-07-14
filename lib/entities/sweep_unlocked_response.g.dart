// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sweep_unlocked_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SweepUnlockedResponse _$SweepUnlockedResponseFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedResponse(
      txSets: (json['txSets'] as List<dynamic>)
          .map((e) =>
              SweepUnlockedResponseTxSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SweepUnlockedResponseToJson(
        SweepUnlockedResponse instance) =>
    <String, dynamic>{
      'txSets': instance.txSets.map((e) => e.toJson()).toList(),
    };

SweepUnlockedResponseTxSet _$SweepUnlockedResponseTxSetFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedResponseTxSet(
      multisigTxHex: json['multisigTxHex'] as String,
      txs: (json['txs'] as List<dynamic>)
          .map((e) => SweepUnlockedResponseTransaction.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SweepUnlockedResponseTxSetToJson(
        SweepUnlockedResponseTxSet instance) =>
    <String, dynamic>{
      'multisigTxHex': instance.multisigTxHex,
      'txs': instance.txs.map((e) => e.toJson()).toList(),
    };

SweepUnlockedResponseTransaction _$SweepUnlockedResponseTransactionFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedResponseTransaction(
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
          .map((e) =>
              SweepUnlockedResponseInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      isOutgoing: json['isOutgoing'] as bool,
      isLocked: json['isLocked'] as bool,
      outgoingTransfer: json['outgoingTransfer'] == null
          ? null
          : SweepUnlockedResponseOutgoingTransfer.fromJson(
              json['outgoingTransfer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SweepUnlockedResponseTransactionToJson(
        SweepUnlockedResponseTransaction instance) =>
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
      'inputs': instance.inputs.map((e) => e.toJson()).toList(),
      'isOutgoing': instance.isOutgoing,
      'isLocked': instance.isLocked,
      'outgoingTransfer': instance.outgoingTransfer?.toJson(),
    };

SweepUnlockedResponseInput _$SweepUnlockedResponseInputFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedResponseInput(
      keyImage: SweepUnlockedResponseKeyImage.fromJson(
          json['keyImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SweepUnlockedResponseInputToJson(
        SweepUnlockedResponseInput instance) =>
    <String, dynamic>{
      'keyImage': instance.keyImage.toJson(),
    };

SweepUnlockedResponseKeyImage _$SweepUnlockedResponseKeyImageFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedResponseKeyImage(
      hex: json['hex'] as String,
    );

Map<String, dynamic> _$SweepUnlockedResponseKeyImageToJson(
        SweepUnlockedResponseKeyImage instance) =>
    <String, dynamic>{
      'hex': instance.hex,
    };

SweepUnlockedResponseOutgoingTransfer
    _$SweepUnlockedResponseOutgoingTransferFromJson(
            Map<String, dynamic> json) =>
        SweepUnlockedResponseOutgoingTransfer(
          amount: json['amount'] as int,
          accountIndex: json['accountIndex'] as int,
          subaddressIndices: (json['subaddressIndices'] as List<dynamic>)
              .map((e) => e as int)
              .toList(),
          destinations: (json['destinations'] as List<dynamic>)
              .map((e) => SweepUnlockedResponseDestination.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$SweepUnlockedResponseOutgoingTransferToJson(
        SweepUnlockedResponseOutgoingTransfer instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'accountIndex': instance.accountIndex,
      'subaddressIndices': instance.subaddressIndices,
      'destinations': instance.destinations.map((e) => e.toJson()).toList(),
    };

SweepUnlockedResponseDestination _$SweepUnlockedResponseDestinationFromJson(
        Map<String, dynamic> json) =>
    SweepUnlockedResponseDestination(
      amount: json['amount'] as int,
      address: json['address'] as String,
    );

Map<String, dynamic> _$SweepUnlockedResponseDestinationToJson(
        SweepUnlockedResponseDestination instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'address': instance.address,
    };

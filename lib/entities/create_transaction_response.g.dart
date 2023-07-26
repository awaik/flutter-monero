// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransactionResponse _$CreateTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionResponse(
      unsignedTxHex: json['unsignedTxHex'] as String?,
      signedTxHex: json['signedTxHex'] as String?,
      multisigTxHex: json['multisigTxHex'] as String?,
      txs: (json['txs'] as List<dynamic>)
          .map((e) => CreateTransactionResponseTransaction.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateTransactionResponseToJson(
        CreateTransactionResponse instance) =>
    <String, dynamic>{
      'unsignedTxHex': instance.unsignedTxHex,
      'signedTxHex': instance.signedTxHex,
      'multisigTxHex': instance.multisigTxHex,
      'txs': instance.txs.map((e) => e.toJson()).toList(),
    };

CreateTransactionResponseKeyImage _$CreateTransactionResponseKeyImageFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionResponseKeyImage(
      hex: json['hex'] as String,
    );

Map<String, dynamic> _$CreateTransactionResponseKeyImageToJson(
        CreateTransactionResponseKeyImage instance) =>
    <String, dynamic>{
      'hex': instance.hex,
    };

CreateTransactionResponseInput _$CreateTransactionResponseInputFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionResponseInput(
      keyImage: CreateTransactionResponseKeyImage.fromJson(
          json['keyImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateTransactionResponseInputToJson(
        CreateTransactionResponseInput instance) =>
    <String, dynamic>{
      'keyImage': instance.keyImage.toJson(),
    };

CreateTransactionResponseDestination
    _$CreateTransactionResponseDestinationFromJson(Map<String, dynamic> json) =>
        CreateTransactionResponseDestination(
          amount: json['amount'] as int,
          address: json['address'] as String,
        );

Map<String, dynamic> _$CreateTransactionResponseDestinationToJson(
        CreateTransactionResponseDestination instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'address': instance.address,
    };

CreateTransactionResponseOutgoingTransfer
    _$CreateTransactionResponseOutgoingTransferFromJson(
            Map<String, dynamic> json) =>
        CreateTransactionResponseOutgoingTransfer(
          amount: json['amount'] as int,
          accountIndex: json['accountIndex'] as int,
          destinations: (json['destinations'] as List<dynamic>)
              .map((e) => CreateTransactionResponseDestination.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$CreateTransactionResponseOutgoingTransferToJson(
        CreateTransactionResponseOutgoingTransfer instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'accountIndex': instance.accountIndex,
      'destinations': instance.destinations.map((e) => e.toJson()).toList(),
    };

CreateTransactionResponseTransaction
    _$CreateTransactionResponseTransactionFromJson(Map<String, dynamic> json) =>
        CreateTransactionResponseTransaction(
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
              .map((e) => CreateTransactionResponseInput.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
          isOutgoing: json['isOutgoing'] as bool,
          isLocked: json['isLocked'] as bool,
          outgoingTransfer: CreateTransactionResponseOutgoingTransfer.fromJson(
              json['outgoingTransfer'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateTransactionResponseTransactionToJson(
        CreateTransactionResponseTransaction instance) =>
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
      'outgoingTransfer': instance.outgoingTransfer.toJson(),
    };

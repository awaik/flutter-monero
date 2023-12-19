import 'dart:io';
import 'dart:typed_data';

import 'package:monero_flutter/exceptions/restore_wallet_from_keys_exception.dart';
import 'package:monero_flutter_example/test_result.dart';

import 'package:monero_flutter/wallet_manager_api.dart' as wallet_manager_api;
import 'package:monero_flutter/wallet_sync_api.dart' as sync_api;
import 'package:monero_flutter/transaction_api.dart' as transaction_api;

class WalletTests {
  List<TestFunction> get testFunctions => [
        _openWalletTest,
        _setupNodeTest,
        _startRefreshTest,
        _getAllTransfersAsJsonTest,
        _getUtxosAsJsonTest,
        _getAllTransfers,
        _getUtxos
      ];

  Future<TestResult> _loadWalletTest() async {
    const path = "/Users/dmytro/Documents/_WALLETS/v1/moneroWalletVer3";

    try {
      await wallet_manager_api.loadWallet(path: path, password: "");
    } on RestoreWalletFromKeysException catch (e) {
      return TestResult("Load Wallet", true, message: e.message);
    }

    return TestResult("Load Wallet", true);
  }

  Future<TestResult> _openWalletTest() async {
    const keysPath =
        "/Users/dmytro/Documents/_WALLETS/v1/moneroWalletVer3.keys";
    const cachePath = "/Users/dmytro/Documents/_WALLETS/v1/moneroWalletVer3";

    final keysData = await _readBytes(keysPath);
    final cacheData = await _readBytes(cachePath);

    await wallet_manager_api.openWalletData("", keysData, cacheData);

    return TestResult("Load Wallet", true);
  }

  Future<TestResult> _setupNodeTest() async {
    final result = await sync_api.setupNode(address: "http://xmrno.de:18089");
    return TestResult("Setup Node", result);
  }

  Future<TestResult> _startRefreshTest() async {
    final task1 = Future(() async {
      while (true) {
        int currentHeight = await sync_api.getCurrentHeight();
        int endHeight = await sync_api.getEndHeight();

        print("currentHeight=$currentHeight; endHeight=$endHeight");

        if (currentHeight == endHeight) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    });

    await sync_api.startRefresh();
    await wallet_manager_api.store();

    //await task1;

    return TestResult("Start Refresh", true);
  }

  Future<TestResult> _getAllTransfersAsJsonTest() async {
    final json = await transaction_api.getAllTransfersAsJson();
    return TestResult("Get All Transfers (JSON)", true,
        message: "\r\n$json\r\n");
  }

  Future<TestResult> _getUtxosAsJsonTest() async {
    final json = await transaction_api.getUtxosAsJson();
    return TestResult("Get Utxos (JSON)", true, message: "\r\n$json\r\n");
  }

  Future<TestResult> _getAllTransfers() async {
    final result = await transaction_api.getAllTransfers();
    return TestResult("Get All Transfers", true,
        message: "cnt=${result.length}");
  }

  Future<TestResult> _getUtxos() async {
    final result = await transaction_api.getUtxos();
    return TestResult("Get Utxos", true, message: "cnt=${result.length}");
  }

  Future<Uint8List> _readBytes(String path) async {
    var file = File(path);
    return await file.readAsBytes();
  }
}

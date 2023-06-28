import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:monero_flutter/exceptions/wallet_restore_from_keys_exception.dart';
import 'package:monero_flutter/wallet_manager_api.dart' as api;
import 'package:path_provider/path_provider.dart';

class WalletManagementPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  WalletManagementPage({super.key});

  Future<String> _getWalletPath({String name = "test5"}) async {
    final root = await getApplicationDocumentsDirectory();

    final walletsDir = Directory('${root.path}/wallets3');
    final walletDir = Directory('${walletsDir.path}/wallet_v3');

    //final walletDir = Directory("/Users/test/Documents/TEMP");

    if (!walletDir.existsSync()) {
      walletDir.createSync(recursive: true);
    }

    final walletPath = '${walletDir.path}/$name';

    return walletPath;
  }

  Future<bool> _checkIsWalletExist() async {
    final walletPath = await _getWalletPath();
    bool isWalletExist;

    String testResult;

    try {
      isWalletExist = api.isWalletExist(path: walletPath);
    } catch (e) {
      testResult = e.toString();

      _resultController.text = testResult;

      return false;
    }

    testResult = isWalletExist ? "Wallet exists!" : "Wallet doesn't exist!";

    _resultController.text = testResult;

    return isWalletExist;
  }

  void _isWalletExist() async {
    await _checkIsWalletExist();
  }

  void _createWallet() async {
    final walletPath = await _getWalletPath();
    bool isWalletExist;

    String testResult;

    try {
      isWalletExist = api.isWalletExist(path: walletPath);
    } catch (e) {
      testResult = e.toString();

      _resultController.text = testResult;

      return;
    }

    if (isWalletExist) {
      testResult = "Error: wallet already exist!";
    } else {
      try {
        var password = " ";

        await api.createWallet(
          path: walletPath,
          password: password,
          language: "Eng",
        );
        testResult = "Wallet have successfully created!";
      } catch (e) {
        testResult = e.toString();
      }
    }

    _resultController.text = testResult;
  }

  void _restoreWallet() async {
    final walletPath = await _getWalletPath();
    bool isWalletExist;

    String testResult;

    try {
      isWalletExist = api.isWalletExist(path: walletPath);
    } catch (e) {
      testResult = e.toString();

      _resultController.text = testResult;

      return;
    }

    // if (isWalletExist){
    //   await File(walletPath).delete();
    //   isWalletExist = false;
    // }

    if (isWalletExist) {
      testResult = "Error: wallet already exists!";
    } else {
      try {
        var password = " ";

        // final seed =
        //     "cell sonic farming toxic mechanic drunk terminal mayor maze fonts dove jazz truth attire october onto bomb molten twofold goggles voice liar loaded lush fonts";
        print('+++++++++++++++++++++++++++++++++++++11 0000');
        var seed =
            "point nerves ungainly gather loudly theatrics october misery aphid website attire erected shelter ouch hesitate nouns suede omnibus folding last fruit upbeat haystack hedgehog gather";

        api.restoreWalletFromSeedSync(
          path: walletPath,
          password: password,
          seed: seed,
        );
        testResult = "Wallet have recovered!";
      } catch (e) {
        testResult = e.toString();
      }
    }

    _resultController.text = testResult;
  }

  void _openWallet() async {
    // final walletPath = await _getWalletPath();
    // String testResult;
    //
    // try {
    //   var password = " ";
    //   api.loadWalletSync(path: walletPath, password: password);
    //   testResult = "Wallet opened successfully!";
    // } catch (e) {
    //
    //   WalletRestoreFromKeysException rwk = e as WalletRestoreFromKeysException;
    //
    //   testResult = e.message;
    // }
    //
    // _resultController.text = testResult;

    // final walletPath = await _getWalletPath();
    // String testResult;
    //
    // try {
    //   var password = " ";
    //   api.loadWalletSync(path: walletPath, password: password);
    //   testResult = "Wallet opened successfully!";
    // } catch (e) {
    //
    //   WalletRestoreFromKeysException rwk = e as WalletRestoreFromKeysException;
    //
    //   testResult = e.message;
    // }
    //
    // _resultController.text = testResult;final walletPath = await _getWalletPath();

    final walletPath = await _getWalletPath();

    bool isWalletExist;

    String testResult;

    try {
      isWalletExist = api.isWalletExist(path: walletPath);
    } catch (e) {
      testResult = e.toString();

      _resultController.text = testResult;

      return;
    }

    if (!isWalletExist) {
      testResult = "Error: wallet wasn't created!";
    } else {
      try {
        var password = "1234";
        api.loadWalletSync(path: walletPath, password: password);
        testResult = "Wallet opened successfully!";
      } catch (e) {
        WalletRestoreFromKeysException rwk = e as WalletRestoreFromKeysException;

        testResult = e.message;
      }
    }

    _resultController.text = testResult;
  }

  void _closeWallet() async {
    final walletPath = await _getWalletPath();
    bool isWalletExist;

    String testResult;

    try {
      isWalletExist = api.isWalletExist(path: walletPath);
    } catch (e) {
      testResult = e.toString();

      _resultController.text = testResult;

      return;
    }

    if (!isWalletExist) {
      testResult = "Error: wallet wasn't created!";
    } else {
      try {
        api.closeCurrentWallet();
        testResult = "Wallet have closed!";
      } catch (e) {
        testResult = e.toString();
      }
    }

    _resultController.text = testResult;
  }

  void _showSecret() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      testResult = "SecretViewKey=" + api.getSecretViewKey() + " | SecretSpendKey=" + api.getSecretSpendKey();
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _showInfo() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      testResult = "PublicViewKey=${api.getPublicViewKey()} | PublicSpendKey=${api.getPublicSpendKey()}";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _showSeed() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      testResult = api.getSeed();
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _setPassword() async {
    if (!await _checkIsWalletExist()) return;

    String testResult = '';

    try {
      api.setPassword(password: "1234");
      testResult = "Password 1234 set";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _showFileName() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      testResult = api.getFilename() + "\n";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _saveState() async {
    if (!await _checkIsWalletExist()) return;

    final walletPath = await _getWalletPath();

    String testResult;

    try {
      api.store(path: walletPath);
      testResult = "Saved!";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _setIsRecovery() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      api.setRecoveringFromSeed(isRecovery: true);
      testResult = "isRecovery: true";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _resetIsRecovery() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      api.setRecoveringFromSeed(isRecovery: false);
      testResult = "isRecovery: false";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  Uint8List? _keysFileBuffer;
  Uint8List? _cacheFileBuffer;

  String? _keysFileHex;
  String? _cacheFileHex;

  void _getKeysFileBuffer() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      _keysFileHex = await api.getKeysDataHex("1234", false);
      _keysFileBuffer = await api.getKeysDataBuffer("1234", false);

      var hex1 = _keysFileHex!;
      var hex2 = _keysFileBuffer!.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');

      testResult = "$hex1 $hex2";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _getCacheFileBuffer() async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      _cacheFileHex = await api.getCacheDataHex("1234");
      _cacheFileBuffer = await api.getCacheDataBuffer("1234");

      var hex1 = _cacheFileHex!;
      var hex2 = _cacheFileBuffer!.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');

      testResult = "${hex1.length} ${hex2.length}";
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _openWalletData() async {
    String testResult;

    // var keyHex = await File('/Users/test/Downloads/key-wallet-2023-06-09.txt')
    //     .readAsString();
    // var cacheHex = await File('/Users/test/Downloads/wallet-2023-06-09.txt')
    //     .readAsString();

    // final keysFileBuffer = hex.decode(keyHex) as Uint8List;
    // final cacheFileBuffer = hex.decode(cacheHex) as Uint8List;

    // await File('/Users/test/Documents/TEMP/test2.keys').writeAsBytes(keysFileBuffer);
    // await File('/Users/test/Documents/TEMP/test2').writeAsBytes(cacheFileBuffer);

    // Uint8List part = Uint8List(100);
    //
    // for (int i = 0; i < 100; i++){
    //   part[i] = cacheFileBuffer[i];
    // }
    //
    // final b64 = base64.encode(part);

    //testResult = b64;

    final keysFileBuffer = _keysFileBuffer!;
    final cacheFileBuffer = _cacheFileBuffer!;
    //final cacheFileBuffer = new Uint8List(0);

    try {
      await api.openWalletData("1234", false, keysFileBuffer, cacheFileBuffer, "node.moneroworld.com:18089",
          "Daemon username", "Daemon password");
      testResult = "OK";
    } catch (e) {
      testResult = e.toString();
    }

    // if (null == _keysFileBuffer || null == _cacheFileBuffer) {
    //   testResult = "keysFileBuffer or cacheFileBuffer is null!";
    // }
    // else {
    //   try {
    //     await api.openWalletData("1234",
    //         false,
    //         _keysFileBuffer!,
    //         _cacheFileBuffer!,
    //         "node.moneroworld.com:18089",
    //         "Daemon username",
    //         "Daemon password");
    //     testResult = "OK";
    //   } catch (e) {
    //     testResult = e.toString();
    //   }
    // }

    _resultController.text = testResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Wallet')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _resultController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Exist?", style: TextStyle(fontSize: 22)),
                      onPressed: _isWalletExist,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Create new", style: TextStyle(fontSize: 22)),
                      onPressed: _createWallet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Recover (from seed)", style: TextStyle(fontSize: 22)),
                      onPressed: _restoreWallet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Open", style: TextStyle(fontSize: 22)),
                      onPressed: _openWallet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Close", style: TextStyle(fontSize: 22)),
                      onPressed: _closeWallet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Secret keys", style: TextStyle(fontSize: 22)),
                      onPressed: _showSecret,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Public keys", style: TextStyle(fontSize: 22)),
                      onPressed: _showInfo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Password", style: TextStyle(fontSize: 22)),
                      onPressed: _showSeed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("File name", style: TextStyle(fontSize: 22)),
                      onPressed: _showFileName,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Set a password", style: TextStyle(fontSize: 22)),
                      onPressed: _setPassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Save", style: TextStyle(fontSize: 22)),
                      onPressed: _saveState,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("is_recovery=true", style: TextStyle(fontSize: 22)),
                      onPressed: _setIsRecovery,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("is_recovery=false", style: TextStyle(fontSize: 22)),
                      onPressed: _resetIsRecovery,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("get_keys_file_buffer", style: TextStyle(fontSize: 22)),
                      onPressed: _getKeysFileBuffer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("get_cache_file_buffer", style: TextStyle(fontSize: 22)),
                      onPressed: _getCacheFileBuffer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("open_wallet_data", style: TextStyle(fontSize: 22)),
                      onPressed: _openWalletData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

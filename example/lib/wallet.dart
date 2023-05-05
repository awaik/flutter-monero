import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

import 'package:monero_app/wallet_manager_api.dart' as api;

class WalletWidget extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  Future<String> _getWalletPath() async {
    final root = await getApplicationDocumentsDirectory();

    final walletsDir = Directory('${root.path}/wallets');
    final walletDir = Directory('${walletsDir.path}/wallet_v1');

    if (!walletDir.existsSync()) {
      walletDir.createSync(recursive: true);
    }

    final walletPath = '${walletDir.path}/test1';

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

    testResult =
        isWalletExist ? "Кошелек существует!" : "Кошелек НЕ существует!";

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
      testResult = "Ошибка: кошелек уже существует!";
    } else {
      try {
        final password = "1234";

        await api.createWallet(
            path: walletPath, password: password, language: "Eng");
        testResult = "Кошелек успешно создан!";
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

    if (isWalletExist) {
      testResult = "Ошибка: кошелек уже существует!";
    } else {
      try {
        final password = "1234";

        // final seed =
        //     "cell sonic farming toxic mechanic drunk terminal mayor maze fonts dove jazz truth attire october onto bomb molten twofold goggles voice liar loaded lush fonts";

        final seed =
            "tycoon odds launching anchor academy ought inflamed vivid payment large musical enhanced loincloth having wallets earth ditch thirsty somewhere himself pact village awoken basin tycoon";

        api.restoreWalletFromSeedSync(
            path: walletPath, password: password, seed: seed);
        testResult = "Кошелек успешно восстановлен!";
      } catch (e) {
        testResult = e.toString();
      }
    }

    _resultController.text = testResult;
  }

  void _openWallet() async {
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
      testResult = "Ошибка: кошелек не создан!";
    } else {
      try {
        final password = "1234";
        api.loadWalletSync(path: walletPath, password: password);
        testResult = "Кошелек успешно открыт!";
      } catch (e) {
        testResult = e.toString();
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
      testResult = "Ошибка: кошелек не создан!";
    } else {
      try {
        api.closeCurrentWallet();
        testResult = "Кошелек успешно закрыт!";
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
      testResult = "PublicViewKey=" + api.getPublicViewKey() + " | PublicSpendKey=" + api.getPublicSpendKey();
    } catch (e) {
      testResult = e.toString();
    }

    _resultController.text = testResult;
  }

  void _showSeed()async {
    if (!await _checkIsWalletExist()) return;

    String testResult;

    try {
      testResult = api.seed();
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
      testResult = "Пароль 1234 установлен";
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
      testResult = "Успешно сохранено!";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Кошелек')),
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
                      child: Text("Существует ли?",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Создать новый",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Восстановить (from seed)",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Открыть",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Закрыть",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Секретные ключи",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Открытые ключи",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Парольная фраза",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Имя файла",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Установить пароль",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Сохранить", style: TextStyle(fontSize: 22)),
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
                      child: Text("is_recovery=true",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("is_recovery=false",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _resetIsRecovery,
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

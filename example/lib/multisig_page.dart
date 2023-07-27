import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monero_flutter/entities/simplified_transaction_request.dart';
import 'package:monero_flutter/multisig_api.dart' as api;
import 'package:monero_flutter/transaction_api.dart' as transaction_api;
import 'package:monero_flutter/wallet_manager_api.dart' as wallet_manager_api;

class MultisigPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  MultisigPage({super.key});

  void _createOrOpenWallet(String walletPath) {
    const password = "password1";
    const language = "Eng";

    if (!wallet_manager_api.isWalletExistSync(path: walletPath)) {
      wallet_manager_api.createWalletSync(path: walletPath, password: password, language: language);
    }
    else {
      wallet_manager_api.loadWallet(path: walletPath, password: password);
    }
  }

  void _complexTest() async {
    try {

      final destination1 = SimplifiedTransactionRequestDestination(address: '473iFs45jPh4nDSKxGXAxrLi2NVApdBhESrDcreyjGA7G4AtsLcB6RjN8LsU9MTpGRZxeykKHErQ2fY2wcFnHor24AZRrmC', amount: 500000000);
      final destination2 = SimplifiedTransactionRequestDestination(address: '86jgL8oFUxmevDQ16SzEfFZjVYyWn6GGXMiZ5RomUyqYWRBrroauWtocVRNX5xrEf7CtxMhHjZjRcVHNv2NGo2nK42g2F8S', amount: 450000000);

      final request = SimplifiedTransactionRequest(destinations: [destination1, destination2]);

      final report = await api.prepareTransaction(request);

      final jsonText = jsonEncode(report.toJson());

      _resultController.text = jsonText;
    }
    catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _createPairTest() async {
    String wallet1Path = "/Users/dmytro/Documents/WALLET/mswallet1";
    String wallet2Path = "/Users/dmytro/Documents/WALLET/mswallet2";

    // wallet 1 (round 1)
    _createOrOpenWallet(wallet1Path);

    final round1Wallet1 = await api.prepareMultisig();
    //final multisigInfoWallet1 = await api.getMultisigInfo();
    wallet_manager_api.closeCurrentWallet();

    // wallet 2 (round 1 and 2)
    _createOrOpenWallet(wallet2Path);

    final round1Wallet2 = await api.prepareMultisig();
    //final multisigInfoWallet2 = await api.getMultisigInfo();
    final round2Wallet2 = await api.makeMultisig(infoList: [round1Wallet1], threshold: 2);
    wallet_manager_api.closeCurrentWallet();

    // wallet 1 (round 2 and 3)
    _createOrOpenWallet(wallet1Path);
    final round2Wallet1 = await api.makeMultisig(infoList: [round1Wallet2], threshold: 2);
    final round3Wallet1 = await api.exchangeMultisigKeys(infoList: [round2Wallet1, round2Wallet2]);
    wallet_manager_api.closeCurrentWallet();

    // wallet 2 (round 3)
    _createOrOpenWallet(wallet2Path);
    final round3Wallet2 = await api.exchangeMultisigKeys(infoList: [round2Wallet1, round3Wallet1]);
    wallet_manager_api.closeCurrentWallet();
    //
    // // wallet 1 (round 4)
    // _createOrOpenWallet(wallet1Path);
    //final round3Wallet2 = await api.exchangeMultisigKeys(infoList: [round3Wallet2]);
    //wallet_manager_api.closeCurrentWallet();

    //_resultController.text = "=$address=";
  }

  void _createWallet1() async {
    String wallet1Path = "/Users/dmytro/Documents/WALLET/mswallet1";
    _createOrOpenWallet(wallet1Path);
  }

  void _createWallet2() async {
    String wallet2Path = "/Users/dmytro/Documents/WALLET/mswallet2";
    _createOrOpenWallet(wallet2Path);
  }

  void _isMultisig() async {
    try {
      _resultController.text = (await api.isMultisig()).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _prepareMultisig() async {
    try {
      _resultController.text = await api.prepareMultisig();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _getMultisigInfo() async {
    try {
      _resultController.text = await api.getMultisigInfo();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _exchangeMultisigKeys() async {
    try {
      List<String> list = _resultController.text.split(" ");
      _resultController.text = await api.exchangeMultisigKeys(infoList: list);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _isMultisigImportNeeded() async {
    try {
      _resultController.text = (await api.isMultisigImportNeeded()).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _makeMultisig() async {
    try {
      List<String> list = [_resultController.text];
      _resultController.text = await api.makeMultisig(infoList: list,threshold: 2);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _importMultisigImages() async {
    try {
      List<String> list = [_resultController.text];
      _resultController.text = (await api.importMultisigImages(infoList: list)).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _exportMultisigImages() async {
    try {
      _resultController.text = await api.exportMultisigImages();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _createTransaction() {
    try {
      final result = transaction_api.createTransactionSync(
          address: "428vUehXqLfAG3udx8MgFNYjuMWs4dAEvZ2h5ttsHV711WLYhbU6Qto4VPoFcKxtYF4ugeMfbLmg2YhPKwC8aLJ2DWMTUkL",
          amount: "0.001");
      _resultController.text = result.multisigSignData;
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _signMultisigTxHex() async {
    try {
      final result =  await api.signMultisigTxHex(_resultController.text);
      _resultController.text = result;
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  Future<void> _submitMultisigTxHex() async {
    try {
      final result =  await api.submitMultisigTxHex(_resultController.text);
      _resultController.text = result[0];
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Multisig')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _resultController,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
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
                      child: Text("Complex Test", style: TextStyle(fontSize: 22)),
                      onPressed: _complexTest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Create wallet 1", style: TextStyle(fontSize: 22)),
                      onPressed: _createWallet1,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Create wallet 2", style: TextStyle(fontSize: 22)),
                      onPressed: _createWallet2,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Check multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _isMultisig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("1. Prepare_multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _prepareMultisig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("2. Get_multisig_info", style: TextStyle(fontSize: 22)),
                      onPressed: _getMultisigInfo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("3. Make_multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _makeMultisig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("4. Exchange_multisig_keys", style: TextStyle(fontSize: 22)),
                      onPressed: _exchangeMultisigKeys,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("is_multisig_import_needed", style: TextStyle(fontSize: 22)),
                      onPressed: _isMultisigImportNeeded,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("import_multisig_images", style: TextStyle(fontSize: 22)),
                      onPressed: _importMultisigImages,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("export_multisig_images", style: TextStyle(fontSize: 22)),
                      onPressed: _exportMultisigImages,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("sign_multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _signMultisigTxHex,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("submitMultisigTxHex", style: TextStyle(fontSize: 22)),
                      onPressed: _submitMultisigTxHex,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Create transaction", style: TextStyle(fontSize: 22)),
                      onPressed: _createTransaction,
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

import 'package:flutter/material.dart';
import 'package:monero_api_example/sync_wallet.dart';
import 'package:monero_api_example/wallet.dart';
import 'package:monero_api_example/wallet_accounts.dart';

import 'multisig.dart';

class MainScreen extends StatelessWidget {
  void _toWallet(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WalletWidget()));
  }

  void _toSync(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SyncWalletWidget()));
  }

  void _toAccount(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WalletAccountsWidget()));
  }

  void _toMultisig(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MultisigWidget()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero test v0.1')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text("Менеджер кошелька", style: TextStyle(fontSize: 22)),
              onPressed: () {
                _toWallet(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                minimumSize: Size(360, 60),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text("Синхронизация", style: TextStyle(fontSize: 22)),
              onPressed: () {
                _toSync(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                minimumSize: Size(360, 60),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text("Счета", style: TextStyle(fontSize: 22)),
              onPressed: () {
                _toAccount(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                minimumSize: Size(360, 60),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                _toMultisig(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(360, 60),
              ),
              child: const Text("Мультиподпись", style: TextStyle(fontSize: 22)),
            ),
          ),

        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
  ));
}

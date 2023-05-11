import 'package:flutter/material.dart';
import 'package:flutter_monero_example/sync_wallet_paga.dart';
import 'package:flutter_monero_example/wallet_accounts_page.dart';
import 'package:flutter_monero_example/wallet_management_page.dart';

import 'multisig.dart';

class MainScreen extends StatelessWidget {
  void _toWallet(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WalletManagementPage()));
  }

  void _toSync(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SyncWalletPage()));
  }

  void _toAccount(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WalletAccountsPage()));
  }

  void _toMultisig(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MultisigWidget()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero sample app')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text('Wallet management', style: TextStyle(fontSize: 22)),
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
              child: Text('Synchronize', style: TextStyle(fontSize: 22)),
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
              onPressed: () {
                _toAccount(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                minimumSize: Size(360, 60),
              ),
              child: const Text('Addresses & Balance', style: TextStyle(fontSize: 22)),
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
              child: const Text('Multisig', style: TextStyle(fontSize: 22)),
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

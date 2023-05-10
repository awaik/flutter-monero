import 'package:flutter/material.dart';

import 'package:monero_api/wallet_sync_api.dart' as api;

class SyncWalletWidget extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  void _onStartup(){
    api.onStartup();
  }

  void _setTrustedDaemon(){
    api.setTrustedDaemon(true);
  }

  void _setListener(){
    api.setListeners((p0, p1, p2) { }, () { });
  }

  void _isConnectedToNode() async{
    try {
      bool isConnected = await api.isConnected();
      _resultController.text = isConnected.toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _setupToNode(){
    try {
      api.setupNodeSync(address: "node.moneroworld.com:18089", login: "Daemon username", password: "Daemon password", useSSL: true, isLightWallet: false);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _startRefresh(){
    try {
      api.setRefreshFromBlockHeight(height: 2873657);
      api.startRefresh();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _connectToNode(){
    try {
      api.connectToNode();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getSyncingHeight(){
    try {
      _resultController.text = api.getSyncingHeight().toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Синхронизация')),
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
                      child: Text("On Startup",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _onStartup,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Set trusted daemon",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _setTrustedDaemon,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Set Listener",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _setListener,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Подключен ли?",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _isConnectedToNode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Установить ноду",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _setupToNode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Обновление начать",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _startRefresh,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Подключение",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _connectToNode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Сколько синхронизировано",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getSyncingHeight,
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

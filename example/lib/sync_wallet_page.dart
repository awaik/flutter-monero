import 'package:flutter/material.dart';
import 'package:monero_flutter/wallet_sync_api.dart' as api;

class SyncWalletPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  SyncWalletPage({super.key});

  void _onStartup() {
    api.onStartup();
  }

  void _setTrustedDaemon() {
    api.setTrustedDaemon(true);
  }

  void _setListener() {
    api.setListenersSync((p0, p1, p2) {}, () {});
  }

  void _isConnectedToNode() async {
    try {
      bool isConnected = await api.isConnected();
      _resultController.text = isConnected.toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _setupNode() async {
    try {
      _resultController.text = "please wait...";
      await api.setupNode(
          address: "node.moneroworld.com:18089",
          login: "Daemon username",
          password: "Daemon password",
          useSSL: true,
          isLightWallet: false);
      _resultController.text = "Setup completed successfully!";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _startRefresh() {
    try {
      //api.setRefreshFromBlockHeight(height: 2937580); // 2936804
      //
      //api.rescanBlockchain();
      api.startRefresh();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _pauseRefresh() {
    try {
      api.pauseRefresh();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _connectToNode() async {
    try {
      _resultController.text = "connecting...";
      await api.connectToNode();
      _resultController.text = "connected";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getSyncingHeight() async {
    try {
      _resultController.text = (await api.getSyncingHeight()).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getNodes() async {
    List<String> nodes;
    try {
      nodes = await api.getPublicNodes();
    } catch (e) {
      _resultController.text = e.toString();
      return;
    }

    _resultController.text = nodes.join("\r\n");
  }

  void _getTxCountOnNode() async {
    int txCount;

    try {
      txCount = await api.getSingleBlockTxCount(_resultController.text, 2996900);
    } catch (e) {
      _resultController.text = e.toString();
      return;
    }

    _resultController.text = txCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Synchronization')),
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
                      child: Text("On Startup", style: TextStyle(fontSize: 22)),
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
                      child: Text("Set trusted daemon", style: TextStyle(fontSize: 22)),
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
                      child: Text("Set Listener", style: TextStyle(fontSize: 22)),
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
                      child: Text("Connected?", style: TextStyle(fontSize: 22)),
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
                      child: Text("Set a node", style: TextStyle(fontSize: 22)),
                      onPressed: _setupNode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Start synchronization", style: TextStyle(fontSize: 22)),
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
                      child: Text("Pause synchronization", style: TextStyle(fontSize: 22)),
                      onPressed: _pauseRefresh,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Connect", style: TextStyle(fontSize: 22)),
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
                      child: Text("Synchronization progress", style: TextStyle(fontSize: 22)),
                      onPressed: _getSyncingHeight,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get nodes", style: TextStyle(fontSize: 22)),
                      onPressed: _getNodes,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get tx count on node", style: TextStyle(fontSize: 22)),
                      onPressed: _getTxCountOnNode,
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

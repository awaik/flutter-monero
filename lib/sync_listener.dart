import 'dart:async';

import 'package:monero_app/wallet_sync_api.dart' as wallet_sync_api;

class SyncListener {
  SyncListener(this.onNewBlock, this.onNewTransaction)
      : _cachedBlockchainHeight = 0,
        _lastKnownBlockHeight = 0,
        _initialSyncHeight = 0;

  void Function(int, int, double) onNewBlock;
  void Function() onNewTransaction;

  Timer? _updateSyncInfoTimer;
  int _cachedBlockchainHeight;
  int _lastKnownBlockHeight;
  int _initialSyncHeight;

  Future<int> getNodeHeightOrUpdate(int baseHeight) async {
    if (_cachedBlockchainHeight < baseHeight || _cachedBlockchainHeight == 0) {
      _cachedBlockchainHeight = await wallet_sync_api.getNodeHeight();
    }

    return _cachedBlockchainHeight;
  }

  void start() {
    _cachedBlockchainHeight = 0;
    _lastKnownBlockHeight = 0;
    _initialSyncHeight = 0;
    _updateSyncInfoTimer ??=
        Timer.periodic(const Duration(milliseconds: 1200), (_) async {
      if (wallet_sync_api.isNewTransactionExist()) {
        onNewTransaction();
      }

      var syncHeight = wallet_sync_api.getSyncingHeight();

      if (syncHeight <= 0) {
        syncHeight = wallet_sync_api.getCurrentHeight();
      }

      if (_initialSyncHeight <= 0) {
        _initialSyncHeight = syncHeight;
      }

      final bchHeight = await getNodeHeightOrUpdate(syncHeight);

      if (_lastKnownBlockHeight == syncHeight) {
        return;
      }

      _lastKnownBlockHeight = syncHeight;
      final track = bchHeight - _initialSyncHeight;
      final diff = track - (bchHeight - syncHeight);
      final ptc = diff <= 0 ? 0.0 : diff / track;
      final left = bchHeight - syncHeight;

      if (syncHeight < 0 || left < 0) {
        return;
      }

      // 1. Actual new height; 2. Blocks left to finish; 3. Progress in percents;
      onNewBlock.call(syncHeight, left, ptc);
    });
  }

  void stop() => _updateSyncInfoTimer?.cancel();
}

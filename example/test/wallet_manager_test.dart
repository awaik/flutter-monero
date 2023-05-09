// import 'dart:io';
//
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:monero_app_example/wallet.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:monero_app/wallet_manager_api.dart' as api;
//
// Future<String> _getWalletPath() async {
//   final root = await getApplicationDocumentsDirectory();
//
//   final walletsDir = Directory('${root.path}/wallets');
//   final walletDir = Directory('${walletsDir.path}/wallet_v1');
//
//   if (!walletDir.existsSync()) {
//     walletDir.createSync(recursive: true);
//   }
//
//   final walletPath = '${walletDir.path}/test1';
//
//   return walletPath;
// }
//
// void main() {
//
//   testWidgets('Wallet test 1', (WidgetTester tester) async {
//
//     await tester.pumpWidget(WalletWidget());
//
//     expect(find.text('Существует ли?'), findsOneWidget);
//
//     await tester.tap(find.text("Существует ли?"));
//     await tester.pump();
//
//     expect(find.text('Кошелек НЕ существует!'), findsOneWidget);
//   });
//
//   // WidgetsFlutterBinding.ensureInitialized();
//   //
//   // test('Wallet should be created', () async {
//   //
//   //   final walletPath = await _getWalletPath();
//   //   bool isWalletExist = api.isWalletExist(path: walletPath);
//   //
//   //   expect(false, isWalletExist);
//   // });
//
// }

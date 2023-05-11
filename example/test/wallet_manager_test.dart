// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_monero_example/wallet.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:flutter_monero/wallet_manager_api.dart' as api;
//
// Future<String> _getWalletPath() async {
//   // final root = await getApplicationDocumentsDirectory();
//   //
//   // final walletsDir = Directory('${root.path}/wallets');
//   // final walletDir = Directory('${walletsDir.path}/wallet_v1');
//   //
//   // if (!walletDir.existsSync()) {
//   //   walletDir.createSync(recursive: true);
//   // }
//   //
//   // final walletPath = '${walletDir.path}/test1';
//
//   return "/Users/dmytro/Documents/test/wallet1";
// }
//
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   WalletWidget.ensureInitialized();
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
//   // test('Wallet should be created', () async {
//   //
//   //   final walletPath = await _getWalletPath();
//   //   bool isWalletExist = api.isWalletExist(path: walletPath);
//   //
//   //   expect(false, isWalletExist);
//   // });
// }

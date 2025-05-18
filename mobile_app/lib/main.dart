import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_app/routes/router.dart';
import 'package:mobile_app/thema/theme.dart';

void main() async {
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // ganti 'id_ID' sesuai locale yg kamu pakai
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routes = router;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _routes,
      theme: softBlueTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

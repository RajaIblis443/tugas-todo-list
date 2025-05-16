import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/routes/router.dart';
import 'package:mobile/thema/theme.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routes = router;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _routes,
      theme: sageGreenTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

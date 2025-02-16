import 'package:flutter/material.dart';
import 'package:ncoisasdafono/config/dependencies.dart';
import 'package:ncoisasdafono/config/hive_config.dart';
import 'package:ncoisasdafono/routing/router.dart';
import 'package:ncoisasdafono/ui/themes/themes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HiveConfig.start();

  MultiProvider multiProvider = MultiProvider(
    providers: providers,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    ),
  );

  runApp(multiProvider);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router(),
    );
  }
}

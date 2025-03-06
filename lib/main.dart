import 'package:flutter/material.dart';
import 'package:ncoisasdafono/config/dependencies.dart';
import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/routing/router.dart';
import 'package:ncoisasdafono/ui/themes/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxDatabase.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: appRouter.router,
      ),
    );
  }
}

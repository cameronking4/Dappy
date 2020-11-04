import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:swapTech/constance/themes.dart';
import 'package:swapTech/providers/auth_provider.dart';
import 'package:swapTech/splash/splash.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          lazy: false,
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Swap Tech',
        theme: AppTheme.getThemeData(),
        home: SplashPage(),
      ),
    );
  }
}

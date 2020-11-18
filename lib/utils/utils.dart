import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swapTech/constance/themes.dart';

Future<void> lockPortraitOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void setSystemOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.getThemeData().scaffoldBackgroundColor,
    systemNavigationBarDividerColor: AppTheme.getThemeData().disabledColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

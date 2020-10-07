import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swapTech/constance/themes.dart';
import 'package:swapTech/homePage/homePage.dart';
import 'package:swapTech/loginPage/loginPage.dart';
import 'package:swapTech/model/playLoadNotification.dart';
import 'package:swapTech/profile/profile.dart';
import 'package:swapTech/profile/userProfile.dart';
import 'package:swapTech/splash/splash.dart';
import 'package:swapTech/welcome/welcomePage.dart';
import 'package:swapTech/constance/global.dart' as globals;

const debug = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(new MyApp()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    getFirestoreMessageDetail();
  }

  getFirestoreMessageDetail() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch message $message');
      },
      onMessage: (Map<String, dynamic> message) async {
        var allData = PlayLoadNotification.fromJson(message);
        print(allData.notification.title);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume message $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      globals.objProfile.token = token;
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.getThemeData().scaffoldBackgroundColor,
      systemNavigationBarDividerColor: AppTheme.getThemeData().disabledColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swap Tech',
      theme: AppTheme.getThemeData(),
      routes: routes,
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => SplashPage(),
    Routes.LOGIN: (BuildContext context) => LoginPage(),
    Routes.HOME: (BuildContext context) => HomePage(),
    Routes.PROFILE: (BuildContext context) => ProfilePage(),
    Routes.WELCOME: (BuildContext context) => WelcomePage(),
  };
}

class Routes {
  static const String SPLASH = "/";
  static const String LOGIN = "/loginPage/loginPage";
  static const String HOME = "/homePage/homePage";
  static const String PROFILE = "/profile/profile";
  static const String WELCOME = "/welcome/welcomePage";
}

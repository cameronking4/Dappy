import 'package:flutter/material.dart';
import 'package:swapTech/my_app.dart';
import 'package:swapTech/utils/utils.dart';

const debug = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await lockPortraitOrientation();
  runApp(MyApp());
}

// var routes = <String, WidgetBuilder>{
//   Routes.SPLASH: (BuildContext context) => SplashPage(),
//   Routes.LOGIN: (BuildContext context) => LoginPage(),
//   Routes.HOME: (BuildContext context) => HomePage(),
//   Routes.PROFILE: (BuildContext context) => ProfilePage(),
//   Routes.WELCOME: (BuildContext context) => WelcomePage(),
// };

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   Widget build(BuildContext context) {
//     setSystemOverlayStyle();
//   }
// }

class Routes {
  static const String SPLASH = "/";
  static const String LOGIN = "/loginPage/loginPage";
  static const String HOME = "/homePage/homePage";
  static const String PROFILE = "/profile/profile";
  static const String WELCOME = "/welcome/welcomePage";
}

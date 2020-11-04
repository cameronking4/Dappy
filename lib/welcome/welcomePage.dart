import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:swapTech/main.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/permission/permissions.dart';
import 'package:swapTech/providers/auth_provider.dart';

// class Application {
//   static final Algolia algolia = Algolia.init(
//     applicationId: 'FWP0S84P4F',
//     apiKey: '8d06024611f926be01b3a052f0ce0273',
//   );
// }

class WelcomePage extends StatefulWidget {
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  // Map<String, dynamic> user;

  // TabController mainTabController;

  // String qrCode;

  // FirebaseUser firebaseUser;

  // DocumentSnapshot swappedUser;

  // String avatar =
  //     'https://www.shareicon.net/data/512x512/2017/01/06/868320_people_512x512.png';

  // PermissionStatus permissionStatus;

  // bool isContactFound = false;
  // bool isProgress = false;

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    getNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, child) {
            return ModalProgressHUD(
              inAsyncCall: value,
              progressIndicator: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/attendant_welcome.png',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Welcome!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontFamily: 'Gotham-Medium',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Please allow access to your camera, \n contacts and push notification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Gotham-Medium',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "This is the fun part! \n Let's connect your \n accounts.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: 'Gotham-Medium',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0),
                      alignment: Alignment.topCenter,
                      child: RaisedButton(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 80.0, right: 80.0),
                        child: Text("Get Started",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Gotham-Light',
                                fontWeight: FontWeight.bold)),
                        onPressed: () => navigateToHomePage(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        textColor: Colors.white,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future getNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.restricted ||
        status == PermissionStatus.undetermined) {
      Timer(Duration(milliseconds: 3000), () async {
        _fcm.requestNotificationPermissions(const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
        _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
          print("Settings registered: $settings");
        });
      });
    } else {
      print(status);
      return;
    }
  }

  Future<bool> checkPermission() async {
    bool result = await Permissions().getPermission();
    if (result) {
      return true;
    } else {
      await Permissions().getPermission();
      return false;
    }
  }

  // Get started;
  navigateToHomePage() async {
    isLoading.value = true;
    await checkPermission();
    await Future.delayed(Duration(milliseconds: 500));
    isLoading.value = false;
    context
        .read<AuthProvider>()
        .navigateFromWelcomeScreen(); // final user = await FirebaseAuth.instance.currentUser();
    // setNaviget(user);
  }

  setNaviget(FirebaseUser user) async {
    if (user != null) {
      await Firestore.instance
          .collection('Users')
          .document(user.uid)
          .get()
          .then((snapshot) async {
        if (snapshot == null) {
          Navigator.pushReplacementNamed(context, Routes.LOGIN);
        } else {
          if (snapshot == null ||
              ProfileModel.parseSnapshot(snapshot).firstName == '') {
            Navigator.pushReplacementNamed(context, Routes.PROFILE);
          } else {
            Navigator.pushReplacementNamed(context, Routes.HOME);
          }
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    }
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/main.dart';
import 'package:swapTech/model/playLoadNotification.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/permission/permissions.dart';
import 'package:swapTech/requestPage/requestPage.dart';
import 'package:swapTech/searchPage/searchPage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // final Completer<bool> dynamicLinkCompleter = Completer<bool>();

  // Future<void> initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final Uri deepLink = dynamicLink?.link;
  //     print(deepLink.pathSegments);
  //     print("HERE IS THE DEEP LINK $deepLink");
  //     final userId = deepLink.pathSegments.first;
  //     print("USER ID $userId");
  //     var doc;
  //     try {
  //       doc =
  //           await Firestore.instance.collection("Users").document(userId).get();
  //     } catch (e) {
  //       print("ERROR $e");
  //     }
  //     print('HERE WE ARE');
  //     print(doc.data);
  //     final user = ProfileModel.parseSnapshot(doc);
  //     print(user);
  //     globals.objProfile = user;
  //     print('HERE WE ARE NAVIGATING');
  //     try {
  //       Get.to(RequestPage(
  //         objUserPhone: UserPhone(
  //           firstName: user?.firstName,
  //           lastName: user?.lastName,
  //           photoUrl: user.photoUrl,
  //           userId: user?.userId,
  //           userName: user?.userName,
  //           userPhone: user?.contactUserPhone?.isEmpty ?? true
  //               ? ""
  //               : user?.contactUserPhone?.first,
  //         ),
  //       ));
  //     } catch (e) {
  //       print("ERROR NAVIGATING");
  //     }
  //     print('HERE WE ARE AFTER NAVIGATING');
  //     dynamicLinkCompleter.complete(true);
  //     print('HERE WE ARE AFTER NAVIGATING');
  //   }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });

  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;
  //   print("HERE IS THE DEEP LINK2 $deepLink");
  //   dynamicLinkCompleter.complete(false);

  //   // if (deepLink == null) {
  //   //   dynamicLinkCompleter.complete(false);
  //   // }
  //   // Navigator.of(context).push(MaterialPageRoute(
  //   //   builder: (context) {
  //   //     return RequestPage();
  //   //   },
  //   // ));
  // }

  // void getFirestoreMessageDetail() async {
  //   _firebaseMessaging.requestNotificationPermissions();
  //   _firebaseMessaging.configure(
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('onLaunch message $message');
  //     },
  //     onMessage: (Map<String, dynamic> message) async {
  //       var allData = PlayLoadNotification.fromJson(message);
  //       print(allData.notification.title);
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('onResume message $message');
  //     },
  //   );

  //   final token = await _firebaseMessaging.getToken();
  //   globals.objProfile?.token = token;
  //   print(token);
  // }

  // @override
  // void initState() {
  //   getFirestoreMessageDetail();
  //   initDynamicLinks();
  //   dynamicLinkCompleter.future.then((value) {
  //     print("COMPLETER VALUE $value");
  //     if (!value) {
  //       gotoNextScreen();
  //     }
  //   });
  //   super.initState();
  // }

  // gotoNextScreen() async {
  //   final user = await FirebaseAuth.instance.currentUser();
  //   if (user == null) {
  //     Navigator.pushReplacementNamed(context, Routes.LOGIN);
  //   } else {
  //     setNaviget(user);
  //   }
  // }

  // setNaviget(FirebaseUser user) async {
  //   await Firestore.instance
  //       .collection('Users')
  //       .document(user.uid)
  //       .get()
  //       .then((snapshot) async {
  //     if (snapshot == null) {
  //       var newUser = ProfileModel();
  //       newUser.userId = user.uid;
  //       newUser.phone = user.phoneNumber;
  //       await ApiProvider().creatUserProfile(newUser);
  //     } else {
  //       globals.objProfile = ProfileModel.parseSnapshot(snapshot);

  //       if (globals.objProfile == null ||
  //           snapshot == null ||
  //           ProfileModel.parseSnapshot(snapshot).firstName == '') {
  //         var newUser = ProfileModel();
  //         newUser.userId = user.uid;
  //         newUser.phone = user.phoneNumber;
  //         await ApiProvider().creatUserProfile(newUser);
  //         Navigator.pushReplacementNamed(context, Routes.PROFILE);
  //       } else {
  //         await checkPermissions();
  //         Navigator.pushReplacementNamed(context, Routes.HOME);
  //       }
  //     }
  //   });
  // }

  // checkPermissions() async {
  //   bool result = await checkPermission();
  //   if (!result) {
  //     checkPermission();
  //   }
  // }

  // Future<bool> checkPermission() async {
  //   bool result = await Permissions().getPermission();
  //   if (result) {
  //     return true;
  //   } else {
  //     await Permissions().getPermission();
  //     return false;
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Image.asset(
          ConstanceData.appLogo,
        ),
      ),
    );
  }
}

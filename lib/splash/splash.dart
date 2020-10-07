import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/main.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/permission/permissions.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  BuildContext myContext;

  @override
  void initState() {
    super.initState();
    gotoNextScreen();
  }

  gotoNextScreen() async {
    final user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    } else {
      setNaviget(user);
    }
  }

  setNaviget(FirebaseUser user) async {
    await Firestore.instance.collection('Users').document(user.uid).get().then((snapshot) async {
      if (snapshot == null) {
        var newUser = ProfileModel();
        newUser.userId = user.uid;
        newUser.phone = user.phoneNumber;
        await ApiProvider().creatUserProfile(newUser);
      } else {
        globals.objProfile = ProfileModel.parseSnapshot(snapshot);

        if (globals.objProfile == null || snapshot == null || ProfileModel.parseSnapshot(snapshot).firstName == '') {
          var newUser = ProfileModel();
          newUser.userId = user.uid;
          newUser.phone = user.phoneNumber;
          await ApiProvider().creatUserProfile(newUser);
          Navigator.pushReplacementNamed(context, Routes.PROFILE);
        } else {
          await checkPermissions();
          Navigator.pushReplacementNamed(context, Routes.HOME);
        }
      }
    });
  }

  checkPermissions() async {
    bool result = await checkPermission();
    if (!result) {
      checkPermission();
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

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showPlatformDialogue({
  @required String title,
  Widget content,
  String action1Text,
  bool action1OnTap,
  String action2Text,
  bool action2OnTap,
}) async {
  return await Get.dialog(
    (Platform.isAndroid)
        ? AlertDialog(
            title: SelectableText(title),
            content: content,
            actions: <Widget>[
              if (action2Text != null && action2OnTap != null)
                FlatButton(
                  child: Text(action2Text ?? "NO"),
                  onPressed: () => Get.back(result: action2OnTap),
                ),
              FlatButton(
                child: Text(action1Text ?? "OK"),
                onPressed: () => Get.back(result: action1OnTap),
              ),
            ],
          )
        : CupertinoAlertDialog(
            content: content,
            title: Text(title),
            actions: <Widget>[
              if (action2Text != null && action2OnTap != null)
                CupertinoDialogAction(
                  child: Text(action2Text ?? "OK"),
                  onPressed: () => Get.back(result: action2OnTap),
                ),
              CupertinoDialogAction(
                child: Text(action1Text ?? "OK"),
                onPressed: () => Get.back(result: action1OnTap),
              ),
            ],
          ),
  );
}

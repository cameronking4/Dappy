import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/model/notificationModel.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/searchPage/searchPage.dart';

class ApiProvider {
  Future creatUserProfile(ProfileModel profile) async {
    profile.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;

    await Firestore.instance.collection('Users').document(profile.userId).get().then((onValue) async {
      if (onValue.exists) {
        globals.objProfile = ProfileModel.parseSnapshot(onValue);
        return;
      } else {
        await Firestore.instance.collection('Users').document(profile.userId).setData(profile.toJson()).then((value) async {
          globals.objProfile = profile;
          return;
        });
      }
    });
  }

  Future updateUserFields(ProfileModel profile) async {
    // profile.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    try {
      await Firestore.instance.collection('Users').document(profile.userId).updateData({
        "contactUserName": profile.contactUserName,
        "contactUserPhone": profile.contactUserPhone,
        "email": profile.email,
        "facebook": profile.facebook,
        "firstName": profile.firstName,
        "instagram": profile.instagram,
        "lastName": profile.lastName,
        "linkedin": profile.linkedin,
        "photoUrl": profile.photoUrl,
        "snapchat": profile.snapchat,
        "tiktok": profile.tiktok,
        "token": profile.token,
        // "updatedAt": profile.updatedAt,
        "userName": profile.userName,
        "venmo": profile.venmo,
      });
      globals.objProfile = profile;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> searchContactAdd() async {
    var data = {
      "token": globals.objProfile.token,
      "firstName": globals.objProfile.firstName,
      "lastName": globals.objProfile.lastName,
      "docId": globals.objProfile.userId,
      "contactUserName": globals.objProfile.contactUserName,
      "contactUserPhone": globals.objProfile.contactUserPhone,
      // "updatedAt": globals.objProfile.updatedAt,
      "justPhone": globals.objProfile.justPhone,
      "phone": globals.objProfile.phone,
      "userName": globals.objProfile.userName,
      "userId": globals.objProfile.userId,
    };

    try {
      Response response = await Dio().post(ConstanceData.SearchPhoneUrl, data: data).catchError((onError) {
        print(onError);
        return false;
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error");
        return false;
      }
    } catch (e) {
      print("remove_orders_by_rider_v1 issue");
      return false;
    }
  }

  Future updateEditProfileFields(ProfileModel profile) async {
    // profile.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    try {
      await Firestore.instance.collection('Users').document(profile.userId).updateData({
        "facebook": profile.facebook,
        "firstName": profile.firstName,
        "instagram": profile.instagram,
        "twitter": profile.twitter,
        "email": profile.email,
        "website": profile.website,
        "lastName": profile.lastName,
        "linkedin": profile.linkedin,
        "snapchat": profile.snapchat,
        "tiktok": profile.tiktok,
        "userName": profile.userName,
        "venmo": profile.venmo,
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateUserFCMToken() async {
    try {
      await Firestore.instance.collection('Users').document(globals.objProfile.userId).updateData({
        "token": globals.objProfile.token,
        "updatedAt": DateTime.now().toUtc().millisecondsSinceEpoch,
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateUser(ProfileModel profile) async {
    if (profile != null) {
      profile.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      try {
        await Firestore.instance.collection('Users').document(profile.userId).updateData(profile.toJson());
      } catch (e) {
        print(e);
      }
    }
  }

  Future<ProfileModel> getProfileDetail(String userId) async {
    var objProfileModel = ProfileModel();
    await Firestore.instance.collection('Users').where("userId", isEqualTo: userId).getDocuments().then((snapshot) {
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((snapshotdata) {
          objProfileModel = ProfileModel.parseSnapshot(snapshot.documents[0]);
        });
      }
    });
    return objProfileModel;
  }

  Future swapUserProfile(SwapModel swapModel) async {
    swapModel.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;

    await Firestore.instance
        .collection('Swap')
        .where("userId", isEqualTo: swapModel.userId)
        .where("swapuserId", isEqualTo: swapModel.swapuserId)
        .limit(1)
        .getDocuments()
        .then((onValue) async {
      if (onValue.documents.length > 0) {
        // Update
        try {
          await Firestore.instance.collection('Swap').document(onValue.documents[0].documentID).updateData({
            "locationAddreess": swapModel.locationAddreess,
            "updatedAt": DateTime.now().toUtc().millisecondsSinceEpoch,
            "isDismiss": false,
            "id": onValue.documents[0].documentID
          });
        } catch (e) {
          print(e);
        }
        return;
      } else {
        // Create
        await Firestore.instance
            .collection('Swap')
            .where("swapuserId", isEqualTo: swapModel.userId)
            .where("userId", isEqualTo: swapModel.swapuserId)
            .limit(1)
            .getDocuments()
            .then((value) async {
          if (value.documents.length > 0) {
            try {
              await Firestore.instance.collection('Swap').document(value.documents[0].documentID).updateData({
                "locationAddreess": swapModel.locationAddreess,
                "updatedAt": DateTime.now().toUtc().millisecondsSinceEpoch,
                "isDismiss": false,
                "id": value.documents[0].documentID
              });
            } catch (e) {
              print(e);
            }
            return;
          } else {
            await Firestore.instance.collection('Swap').document().setData(swapModel.toJson()).then((value) async {
              return;
            });
          }
        });
      }
    });
  }

  addNotification(NotificationModel objNotification) async {
    objNotification.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    try {
      await Firestore.instance.collection("Notifications").document().setData({
        "userId": objNotification.userId,
        "requestUserId": objNotification.requestUserId,
        "isAccept": false,
        "declined": false,
        "createdAt": objNotification.createdAt,
        "updatedAt": objNotification.updatedAt,
      });
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<List<UserPhone>> searchUser(String fieldName, String searchtext) async {
    bool isPhone = false;

    if (double.tryParse(searchtext) != null) isPhone = true;

    QuerySnapshot result;

    searchtext = searchtext.toLowerCase();

    try {
      if (!isPhone)
        result = await Firestore.instance
            .collection('Users')
            .where('userName', isGreaterThanOrEqualTo: searchtext.toLowerCase())
            .where('userName', isLessThan: searchtext + 'z')
            .limit(10)
            .getDocuments();

      if (isPhone)
        result = await Firestore.instance
            .collection('Users')
            .where('phone', isGreaterThanOrEqualTo: searchtext)
            .where('phone', isLessThan: searchtext + 'z')
            .limit(10)
            .getDocuments();

      if (result != null)
        result.documents.forEach((element) {
          print(element['userName']);
        });

      return result.documents.map((document) => UserPhone.fromFirestore(document)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> usernameCheck(String potentialId) async {
    final result = await Firestore.instance
        .collection('Users')
        .where('userName', isEqualTo: potentialId)
        .getDocuments();
    return result.documents.isEmpty;
  }

  Future<List<String>> getSwapLocation(userID) async {
    List<String> strings = [];
    try { //check userID
      await Firestore.instance
          .collection('Swap')
          .where("userId", isEqualTo: globals.objProfile.userId)
          .where("swapuserId", isEqualTo: userID)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = SwapModel.parseSnapshot(snapshotdata);
            strings.add(data.locationAddreess);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    try { //check swapuserId
      await Firestore.instance
          .collection('Swap')
          .where("swapuserId", isEqualTo: globals.objProfile.userId)
          .where("userId", isEqualTo: userID)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = SwapModel.parseSnapshot(snapshotdata);
            strings.add(data.locationAddreess);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    return strings;
  }

 Future<List<String>> getSwapsIds() async {
    List<String> strings = [];
    try { //check userID
      await Firestore.instance
          .collection('Swap')
          .where("userId", isEqualTo: globals.objProfile.userId)
          .orderBy('createdAt', descending: true)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = SwapModel.parseSnapshot(snapshotdata);
            strings.add(data.swapuserId);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    try { //check swapuserId
      await Firestore.instance
          .collection('Swap')
          .where("swapuserId", isEqualTo: globals.objProfile.userId)
          .orderBy('createdAt', descending: true)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = SwapModel.parseSnapshot(snapshotdata);
            strings.add(data.userId);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    return strings;
  }

  Future<List<SwapModel>> getRecentSwapDetail() async {
    List<SwapModel> lstSwapModel = [];
    try { //check userID
      await Firestore.instance
          .collection('Swap')
          .where("swapuserId", isEqualTo: globals.objProfile.userId)
          .orderBy('createdAt', descending: true)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = SwapModel.parseSnapshot(snapshotdata);
            lstSwapModel.add(data);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    try { //check swapuserId
      await Firestore.instance
          .collection('Swap')
          .where("userId", isEqualTo: globals.objProfile.userId)
          .orderBy('createdAt', descending: true)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = SwapModel.parseSnapshot(snapshotdata);
            lstSwapModel.add(data);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    return lstSwapModel;
  }

  Future dismissSwapReq(SwapModel swapModel) async {
    try {
      await Firestore.instance
          .collection('Swap')
          .where("userId", isEqualTo: swapModel.userId)
          .where("swapuserId", isEqualTo: swapModel.swapuserId)
          .getDocuments()
          .then((value) async {
        if (value.documents.length > 0) {
          await Firestore.instance.collection("Swap").document(value.documents[0].documentID).updateData({
            "updatedAt": DateTime.now().toUtc().millisecondsSinceEpoch,
            "isDismiss": true,
          });
        } else {
          await Firestore.instance
              .collection('Swap')
              .where("userId", isEqualTo: swapModel.swapuserId)
              .where("swapuserId", isEqualTo: swapModel.userId)
              .getDocuments()
              .then((data) async {
            if (data.documents.length > 0) {
              await Firestore.instance.collection("Swap").document(data.documents[0].documentID).updateData({
                "updatedAt": DateTime.now().toUtc().millisecondsSinceEpoch,
                "isDismiss": true,
              });
            }
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<NotificationModel>> notificationDetail() async {
    List<NotificationModel> lstNotification = [];

    try {
      await Firestore.instance
          .collection('Notifications')
          .where("requestUserId", isEqualTo: globals.objProfile.userId)
          .where("declined", isEqualTo: !true)
          .where("isAccept", isEqualTo: !true)
          .orderBy('createdAt', descending: true)
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.length > 0) {
          onValue.documents.forEach((snapshotdata) {
            final data = NotificationModel.parseSnapshot(snapshotdata);
            lstNotification.add(data);
          });
        }
      });
    } catch (e) {
      print(e);
    }
    return lstNotification;
  }

  // Future deleteNotification(NotificationModel objNotification) async {
  //  await Firestore.instance.collection('Notifications').document(objNotification.docId).delete();
  // }

  Future updateNotification(NotificationModel objNotification) async {
    objNotification.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    try {
      await Firestore.instance.collection('Notifications').document(objNotification.docId).updateData({
        "isAccept": objNotification.isAccept,
        "updatedAt": objNotification.updatedAt,
        "declined": objNotification.declined,
      });
    }
      catch (e) {
        print(e);
      }
    }
  }

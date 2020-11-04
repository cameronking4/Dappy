import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/themes.dart';
import 'package:swapTech/homePage/homePage.dart';
import 'package:swapTech/loginPage/loginPage.dart';
import 'package:swapTech/loginPage/verifyPage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/profile/profile.dart';
import 'package:swapTech/providers/base_provider.dart';
import 'package:swapTech/utils/platform_dialogue.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/welcome/welcomePage.dart';

class AuthProvider extends BaseProvider {
  FirebaseStorage firebaseStorage;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    firebaseStorage = FirebaseStorage.instance;
    firebaseStorage
        .setMaxUploadRetryTimeMillis(Duration(seconds: 5).inMilliseconds);
    //Splash Screen Logic
    Timer(Duration(seconds: 2), () async {
      navigateBasedOnCondition();
    });
  }

  Future navigateBasedOnCondition() async {
    _user = await _auth.currentUser();
    if (_user == null) {
      Get.offAll(LoginPage());
    } else {
      navigateFromWelcomeScreen();
    }
  }

  FirebaseAuth _auth;
  FirebaseUser _user;
  FirebaseUser get firebaseUser => _user;
  ProfileModel get user => globals.objProfile;
  set user(ProfileModel user) => globals.objProfile = user;

  File image;

  String verificationId;
  int forceResendingToken;
  String phoneNumber;
  String dialingCode;

  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      final verificationCompleted = (AuthCredential credential) async {
        print("\n\n\n verificationCompleted() CALLED");

        _user = (await _auth.signInWithCredential(credential)).user;
        if (!(await getUserData(_user))) {
          setViewState(false);
          Get.offAll(ProfilePage());
        } else {
          setViewState(false);
          navigateToTabsPage(_user);
        }
      };

      setViewState(true);
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        forceResendingToken: forceResendingToken,
        verificationFailed: (AuthException exception) {
          print("DONE");
          setViewState(false);
          print("\n\n\n verificationFailed() CALLED");

          print(exception);
          print(exception.code);
          print(exception.message);
          if (exception.code.contains("invalidCredential")) {
            showPlatformDialogue(title: "Invalid Phone Number" ?? "ERROR");
            return;
          }
          showPlatformDialogue(title: exception?.message ?? "ERROR");
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print("\n\n\n codeSent() CALLED");
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
          print("DONE");
          setViewState(false);
          Get.to(VerifyPage(
            phoneNumber: phoneNumber,
            dialingCode: dialingCode,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("\n\n\n codeAutoRetrievalTimeout() CALLED");
          this.verificationId = verificationId;
          // showPlatformDialogue(title: "Code Retrival Timed Out");
        },
      );
    } on SocketException catch (_) {
      setViewState(false);
      showPlatformDialogue(title: "Network Connection Error");
    } catch (e) {
      setViewState(false);
      print(e);
      if (e.code == "ERROR_INVALID_CREDENTIAL") {
        showPlatformDialogue(title: "Invalid Credentials");
      } else if (e.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        showPlatformDialogue(
          title: "You Already Have An Account",
          content: Text(
            "Try using the sign in method you used earlier to create account",
          ),
        );
      } else {
        showPlatformDialogue(title: e.code);
      }
    }
  }

  Future<void> verifyCode(String code) async {
    try {
      setViewState(true);
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: code);
      AuthResult result = await _auth.signInWithCredential(credential);
      _user = result.user;
      var newUser = ProfileModel();
      newUser.userId = _user.uid;
      newUser.phone = phoneNumber;
      newUser.countryCode = dialingCode;
      newUser.justPhone = phoneNumber.replaceAll(" ", "");
      await ApiProvider().creatUserProfile(newUser);
      Get.to(WelcomePage());
    } on SocketException catch (_) {
      setViewState(false);
      showPlatformDialogue(title: "Network Connection Error");
      return false;
    } catch (e) {
      print(e);
      setViewState(false);

      if (e.code == "ERROR_INVALID_CREDENTIAL") {
        showPlatformDialogue(title: "Invalid Credentials");
      } else if (e.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        showPlatformDialogue(
          title: "You Already Have An Account",
          content: Text(
            "Try using the sign in method you used earlier to create account",
          ),
        );
      } else if (e.code == "ERROR_INVALID_VERIFICATION_CODE") {
        showPlatformDialogue(
          title: "Wrong Code",
          content: Text(
            "Please enter the code sent to your phone number.",
          ),
        );
      } else {
        showPlatformDialogue(title: e.code);
      }
    }
  }

  Future navigateFromWelcomeScreen() async {
    final hasData = await getUserData(_user);
    if (!hasData) {
      signOut();
      return;
    }
    final noNameFound = globals.objProfile.firstName.isNullOrBlank;
    if (noNameFound) {
      Get.offAll(ProfilePage());
      return;
    } else {
      userDataStream(firebaseUser);
      Get.offAll(HomePage());
    }
  }

  // Future<void> signIn({String email, String password}) async {
  //   try {
  //     setViewState(true);
  //     final authResult = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     _user = authResult.user;
  //     setViewState(false);
  //     if (await isUser()) {
  //       navigateToTabsPage(_user);
  //     } else {
  //       showPlatformDialogue(title: "Account does not belong to user.");
  //       signOut(navigate: false);
  //     }
  //   } on SocketException catch (_) {
  //     showPlatformDialogue(title: "Network Connection Error");
  //   } catch (e) {
  //     setViewState(false);
  //     if (e.code == "ERROR_WRONG_PASSWORD") {
  //       showPlatformDialogue(title: "Wrong Password");
  //     } else if (e.code == "ERROR_USER_NOT_FOUND") {
  //       showPlatformDialogue(
  //         title: "User Not Found",
  //         content: Text("Please Check Your Email, Or Sign up"),
  //       );
  //     } else {
  //       showPlatformDialogue(title: e.code);
  //     }
  //   }
  // }

  // Future<void> signUp({String email, String password}) async {
  //   try {
  //     setViewState(true);
  //     final authResult = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     _user = authResult.user;
  //     setViewState(false);
  // Get.to(CreateProfilePage());
  //   } on SocketException catch (_) {
  //     setViewState(false);
  //     showPlatformDialogue(title: "Network Connection Error");
  //   } catch (e) {
  //     setViewState(false);
  //     if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
  //       showPlatformDialogue(title: "Email Already In Use");
  //     } else {
  //       showPlatformDialogue(title: e.code);
  //     }
  //   }
  // }

  Future<void> addUserDataToFirebase({@required String name}) async {
    setViewState(true);
    try {
      String imageUrl;
      if (image != null) {
        imageUrl = await uploadAndGetImageUrl();
      }
      if (imageUrl == null) return;
      user = ProfileModel(
          // name: name,
          // userId: firebaseUser.uid,
          // profilePicture: imageUrl,
          );
      await _user.updateProfile((UserUpdateInfo()
        ..displayName = name
        ..photoUrl = imageUrl));
      await Firestore.instance
          .collection("Users")
          .document(_user.uid)
          .setData(user.toJson());
      setViewState(false);
      navigateToTabsPage(firebaseUser);
    } on SocketException {
      setViewState(false);
      showPlatformDialogue(title: "Network Connection Error");
    } catch (e) {
      setViewState(false);
      print("ERROR ADDING DATA TO FIREBAE");
      print(e);
      print(e.runtimeType);
    }
  }

  void navigateToTabsPage(FirebaseUser firebaseUser) async {
    if (firebaseUser != null) {
      Get.offAll(WelcomePage());
    }
  }

  Future<bool> getUserData(FirebaseUser firebaseUser) async {
    print("GETUSERDATA()");
    final document = await Firestore.instance
        .collection("Users")
        .document(firebaseUser.uid)
        .get();

    if (document.exists) {
      user = ProfileModel.parseSnapshot(document);
      globals.objProfile = user;
      return true;
    }
    return false;
  }

  void userDataStream(FirebaseUser firebaseUser) {
    Firestore.instance
        .collection("Users")
        .document(firebaseUser.uid)
        .snapshots()
        .listen((document) {
      print("USER STREAM WMITTING VALUE");

      if (document.exists) {
        user = ProfileModel.parseSnapshot(document);
        print("NOTIFTING LISTENERS");
        notifyListeners();
      }
    });
  }

  signOut({bool navigate = true}) {
    _user = null;
    globals.objProfile = null;
    _auth.signOut();
    setViewState(false);
    if (navigate) Get.offAll(LoginPage());
  }

  Future<File> getProfilePicture(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage == null) return null;
    File imageFile = File(pickedImage.path);
    imageFile = await _cropImage(imageFile);
    image = imageFile;
    print(image);
    notifyListeners();
    return imageFile;
  }

  Future<String> uploadAndGetImageUrl([File file]) async {
    try {
      final filename =
          file?.path?.split("/")?.last ?? image.path.split("/").last;
      Directory tempDir = await getTemporaryDirectory();
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
          file?.path ?? image.path, tempDir.path + ".jpg");
      final storageReference =
          firebaseStorage.ref().child("profile_pictures").child(filename);
      final StorageUploadTask uploadTask =
          storageReference.putFile(compressedImage);
      final StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      final imageUrl = (await snapshot.ref.getDownloadURL()) as String;
      setViewState(false);
      return imageUrl;
    } on SocketException catch (_) {
      setViewState(false);
      showPlatformDialogue(title: "Network Connection Error");
      return null;
    } catch (e) {
      print(e);
      setViewState(false);
      return null;
    }
  }

  Future<void> updateProfilePicture(ImageSource imageSource) async {
    final image = await getProfilePicture(imageSource);
    if (image == null) return;
    final imageUrl = await uploadAndGetImageUrl(image);
    if (imageUrl == null) return;
    final doc = Firestore.instance.collection("Users").document(_user.uid);
    doc.updateData({"profilePicture": imageUrl});
  }

  Future<File> _cropImage(File file) async {
    return await ImageCropper.cropImage(
      sourcePath: file?.path ?? image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Profile Picture',
        toolbarColor: AppTheme.getThemeData().primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(title: 'Crop Profile Picture'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/main.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/permission/permissions.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _snapchatController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();
  TextEditingController _venmoController = TextEditingController();
  TextEditingController _tiktokController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  bool isLoginProsses = false;
  String firstName = '';
  String lastName = '';
  String userName = '';
  String email = '';
  String phone = '';
  String typedInstagram = '';
  String typedSnapchat = '';
  String typedFacebook = '';
  String typedLinkedin = '';
  String typedVenmo = '';
  String typedTikTok = '';

  FirebaseUser firebaseUser;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  Contact contactsService = Contact();
  List<String> lstuserName = [];
  List<String> lstuserPhone = [];

  contactPermission() async {
    bool permissionStatus = await checkPermission();
    if (permissionStatus) {
      //upload Contact
      Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      List<Contact> contactsList = contacts.toList();

      contactsList.forEach((element) {
        try {
          if (element != null &&
              element.phones != null &&
              element.phones.length > 0 &&
              element.phones.first != null &&
              element.phones.first.value != null &&
              element.phones.first.value != "" &&
              element.displayName != null) {
            lstuserName.add(element.displayName);
            lstuserPhone.add(element.phones.first.value);
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      await checkPermission();
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

  ProfileModel profile = ProfileModel();

  @override
  void initState() {
    _firstNameController.addListener(_typedFirstname);
    _usernameController.addListener(_typedUsername);
    _lastNameController.addListener(_typedLastname);
    _emailController.addListener(_typedEmail);
    _instagramController.addListener(_typedInstagram);
    _snapchatController.addListener(_typedSnapchat);
    _facebookController.addListener(_typedFacebook);
    _linkedinController.addListener(_typedLinkedin);
    _venmoController.addListener(_typedVenmo);
    _tiktokController.addListener(_typedTikTok);
    contactPermission();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _snapchatController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    _venmoController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoginProsses,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.black,
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Image.asset(
                        ConstanceData.appLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).padding.bottom + 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Profile & Connect Socials',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gotham-Light',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.angular, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Your Firstname',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                            center: Alignment.centerLeft,
                            radius: 6.0,
                            colors: [
                              this.firstName == '' ? Colors.grey : Colors.purple,
                              this.firstName == '' ? Colors.grey : Colors.purple,
                            ],
                            tileMode: TileMode.clamp,
                          ).createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.addressCard, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Your Lastname',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 6.0,
                                  colors: [
                                    this.lastName == '' ? Colors.grey : Colors.purple,
                                    this.lastName == '' ? Colors.grey : Colors.purple,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.addressCard, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Your UserName',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 6.0,
                                  colors: [
                                    this.userName == '' ? Colors.grey : Colors.purple,
                                    this.userName == '' ? Colors.grey : Colors.purple,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.mailBulk, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Your Email',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 6.0,
                                  colors: [
                                    this.email == '' ? Colors.grey : Colors.blue,
                                    this.email == '' ? Colors.grey : Colors.blue,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.instagram, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _instagramController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Instagram Username',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 6.0,
                                  colors: [
                                    this.typedInstagram == '' ? Colors.grey : Colors.orange,
                                    this.typedInstagram == '' ? Colors.grey : Colors.purple,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.snapchat, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _snapchatController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Snapchat Username',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.center,
                                  radius: 12.0,
                                  colors: [
                                    this.typedSnapchat == '' ? Colors.grey : Colors.yellow,
                                    this.typedSnapchat == '' ? Colors.grey : Colors.black,
                                  ],
                                  tileMode: TileMode.repeated)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.facebookF, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _facebookController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Facebook ID',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 10.0,
                                  colors: [
                                    this.typedFacebook == '' ? Colors.grey : Colors.lightBlue,
                                    this.typedFacebook == '' ? Colors.grey : Colors.purple,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _linkedinController,
                                    decoration: InputDecoration(
                                      hintText: 'Type LinkedIn ID',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 8.0,
                                  colors: [
                                    this.typedLinkedin == '' ? Colors.grey : Colors.lightBlueAccent,
                                    this.typedLinkedin == '' ? Colors.grey : Colors.blue,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.vimeoSquare, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _venmoController,
                                    decoration: InputDecoration(
                                      hintText: 'Type Venmo ID',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 8.0,
                                  colors: [
                                    this.typedVenmo == '' ? Colors.grey : Colors.red,
                                    this.typedVenmo == '' ? Colors.grey : Colors.black38,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShaderMask(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.algolia, color: Colors.black87, size: 40.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: _tiktokController,
                                    decoration: InputDecoration(
                                      hintText: 'Type TikTok Username',
                                      hintStyle: TextStyle(color: Colors.black87),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(color: Colors.black87),
                                    cursorColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.centerLeft,
                                  radius: 8.0,
                                  colors: [
                                    this.typedTikTok == '' ? Colors.grey : Colors.green,
                                    this.typedTikTok == '' ? Colors.grey : Colors.orange,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            save();
                          },
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.grey,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.save,
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  save() async {
    setState(() {
      isLoginProsses = true;
    });
    final String fcmToken = await _fcm.getToken();

    final user = await FirebaseAuth.instance.currentUser();
    if (user != null)
      try {
        globals.objProfile.contactUserName = lstuserName;
        globals.objProfile.contactUserPhone = lstuserPhone;
        globals.objProfile.countryCode = globals.objProfile.countryCode;
        globals.objProfile.email = _emailController.text.trim();
        globals.objProfile.facebook = _facebookController.text.trim();
        globals.objProfile.firstName = _firstNameController.text.trim();
        globals.objProfile.instagram = _instagramController.text.trim();
        globals.objProfile.lastName = _lastNameController.text.trim();
        globals.objProfile.linkedin = _linkedinController.text.trim();
        globals.objProfile.photoUrl = 'https://picsum.photos/200';
        globals.objProfile.snapchat = _snapchatController.text.trim();
        globals.objProfile.tiktok = _tiktokController.text.trim();
        globals.objProfile.token = fcmToken;
        globals.objProfile.userName = _usernameController.text.trim();
        globals.objProfile.venmo = _venmoController.text.trim();

        await ApiProvider().updateUserFields(globals.objProfile);

        setState(() {
          isLoginProsses = false;
        });
        Navigator.pushReplacementNamed(context, Routes.HOME);
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoginProsses = false;
        });
      }
  }

  _typedFirstname() {
    this.firstName = _firstNameController.text;
  }

  _typedLastname() {
    this.lastName = _lastNameController.text;
  }

  _typedUsername() {
    this.userName = _usernameController.text;
  }

  _typedEmail() {
    this.email = _emailController.text;
  }

  _typedInstagram() {
    this.typedInstagram = _instagramController.text;
  }

  _typedSnapchat() {
    this.typedSnapchat = _snapchatController.text;
  }

  _typedFacebook() {
    this.typedFacebook = _facebookController.text;
  }

  _typedLinkedin() {
    this.typedLinkedin = _linkedinController.text;
  }

  _typedVenmo() {
    this.typedVenmo = _venmoController.text;
  }

  _typedTikTok() {
    this.typedTikTok = _tiktokController.text;
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/model/profileModel.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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

  String firstName = '';
  String lastName = '';
  String userName = '';
  String email = '';
  String typedEmail = '';
  String phone = '';
  String typedInstagram = '';
  String typedSnapchat = '';
  String typedFacebook = '';
  String typedLinkedin = '';
  String typedVenmo = '';
  String typedTikTok = '';

  bool isProgress = false;

  ProfileModel objProfileModel = new ProfileModel();

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
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    setState(() {
      isProgress = true;
    });
    objProfileModel = await ApiProvider().getProfileDetail(globals.objProfile.userId);

    _firstNameController.text = objProfileModel.firstName;
    _lastNameController.text = objProfileModel.lastName;
    _usernameController.text = objProfileModel.userName;
    _emailController.text = objProfileModel.email;
    _instagramController.text = objProfileModel.instagram;
    _snapchatController.text = objProfileModel.snapchat;
    _facebookController.text = objProfileModel.facebook;
    _linkedinController.text = objProfileModel.linkedin;
    _venmoController.text = objProfileModel.venmo;
    _tiktokController.text = objProfileModel.tiktok;

    globals.objProfile = objProfileModel;

    setState(() {
      isProgress = false;
    });
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
        inAsyncCall: isProgress,
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
              height: 75,
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
                      height: 55,
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
                              this.firstName == '' ? Colors.grey : Colors.blueGrey[50],
                              this.firstName == '' ? Colors.grey : Colors.blueGrey[100],
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
                                    this.lastName == '' ? Colors.grey : Colors.blueGrey[100],
                                    this.lastName == '' ? Colors.grey : Colors.blueGrey[200],
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
                                    autofocus: true,
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
                                    this.userName == '' ? Colors.grey : Colors.lightBlue[200],
                                    this.userName == '' ? Colors.grey : Colors.deepPurple[100],
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
                                    this.typedEmail == '' ? Colors.grey : Colors.deepPurple[100],
                                    this.typedEmail == '' ? Colors.grey : Colors.deepPurple[200],
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
                                    autofocus: true,
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
                                    this.typedFacebook == '' ? Colors.grey : Colors.blue,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
                                    autofocus: true,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
                                    autofocus: true,
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
                                    this.typedVenmo == '' ? Colors.grey : Colors.lightBlue,
                                    this.typedVenmo == '' ? Colors.grey : Colors.lightGreen,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
                                    autofocus: true,
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
                                    this.typedTikTok == '' ? Colors.grey : Colors.pink[300],
                                    this.typedTikTok == '' ? Colors.grey : Colors.lightBlueAccent,
                                  ],
                                  tileMode: TileMode.clamp)
                              .createShader(bounds),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async{
                            print(_usernameController.text.trim());

                            if( globals.objProfile.userName != _usernameController.text.trim() ){
                              // if username does not equal the typed username, check if it is available
                              var valid = await ApiProvider().usernameCheck(_usernameController.text.trim());
                              print(valid);
                              if (!valid) {
                                  Fluttertoast.showToast(msg: "Username already taken :(!");
                                    // username exists
                                }
                            }

                            else{ save();}
                          },
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.black,
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
                                    style: TextStyle(color: Colors.white, fontSize: 17.0),
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
    if (isValid()) {
      try {
        setState(() {
          isProgress = true;
        });
        globals.objProfile.firstName = _firstNameController.text;
        globals.objProfile.lastName = _lastNameController.text;
        globals.objProfile.instagram = _instagramController.text;
        globals.objProfile.snapchat = _snapchatController.text;
        globals.objProfile.facebook = _facebookController.text;
        globals.objProfile.linkedin = _linkedinController.text;
        globals.objProfile.venmo = _venmoController.text;
        globals.objProfile.email = _emailController.text;
        globals.objProfile.tiktok = _tiktokController.text;
        globals.objProfile.userName = _usernameController.text;

        await ApiProvider().updateEditProfileFields(globals.objProfile);

        // Get Result/Objects
        getUserDetail();
        Fluttertoast.showToast(msg: "Successfully updated your profile!");
        setState(() {
          isProgress = false;
        });
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isProgress = false;
        });
      }
    }
  }

  bool isValid() {
    if (_firstNameController.text.trim() == null || _firstNameController.text.trim() == "") {
      Fluttertoast.showToast(msg: "please, Enter First Name");
      return false;
    }
    if (_lastNameController.text.trim() == null || _lastNameController.text.trim() == "") {
      Fluttertoast.showToast(msg: "please, Enter Last Name");
      return false;
    }
    if (_usernameController.text.trim() == null || _usernameController.text.trim() == "") {
      Fluttertoast.showToast(msg: "please, Enter a User Name");
      return false;
    }
    // if (_instagramController.text.trim() == null || _instagramController.text.trim() == "") {
    //   Fluttertoast.showToast(msg: "please, Enter Instagram URL");
    //   return false;
    // }
    // if (_snapchatController.text.trim() == null || _snapchatController.text.trim() == "") {
    //   Fluttertoast.showToast(msg: "please, Enter Snapchat URL");
    //   return false;
    // }
    // if (_facebookController.text.trim() == null || _facebookController.text.trim() == "") {
    //   Fluttertoast.showToast(msg: "please, Enter facebook URL");
    //   return false;
    // }
    // if (_linkedinController.text.trim() == null || _linkedinController.text.trim() == "") {
    //   Fluttertoast.showToast(msg: "please, Enter LinkedIn URL");
    //   return false;
    // }
    // if (_venmoController.text.trim() == null || _venmoController.text.trim() == "") {
    //   Fluttertoast.showToast(msg: "please, Enter Venmo URL");
    //   return false;
    // }
    // if (_tiktokController.text.trim() == null || _tiktokController.text.trim() == "") {
    //   Fluttertoast.showToast(msg: "please, Enter Tiktok URL");
    //   return false;
    // }
    return true;
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
  _typedEmail() {
    this.typedEmail = _emailController.text;
  }

  _typedTikTok() {
    this.typedTikTok = _tiktokController.text;
  }
}

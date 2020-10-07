import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart' as contacts_service;

class EditProfileFromDrawer extends StatefulWidget {

  final VoidCallback profileSaved;

  EditProfileFromDrawer({
    @required this.profileSaved,
  });

  EditProfileFromDrawerState createState() => EditProfileFromDrawerState();
}

class EditProfileFromDrawerState extends State<EditProfileFromDrawer> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;

  String saveButtonText = 'Save';

  String typedInstagram = '';
  String typedSnapchat = '';
  String typedFacebook = '';
  String typedLinkedin = '';
  String typedVenmo = '';
  String typedTikTok = '';

  //TextFields Controllers;
  final _instagramController = TextEditingController();
  final _snapchatController = TextEditingController();
  final _facebookController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _venmoController = TextEditingController();
  final _tiktokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _instagramController.addListener(_typedInstagram);
    _snapchatController.addListener(_typedSnapchat);
    _facebookController.addListener(_typedFacebook);
    _linkedinController.addListener(_typedLinkedin);
    _venmoController.addListener(_typedVenmo);
    _tiktokController.addListener(_typedTikTok);
    getUser();
  }

  @override
  void dispose() {
    _instagramController.dispose();
    _snapchatController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    _venmoController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  Future<Iterable<contacts_service.Contact>> getContacts() async {
    Iterable<contacts_service.Contact> contacts = await contacts_service.ContactsService.getContacts();
    return contacts;
  }

  @override
  Widget build(BuildContext context) {

    return this.firebaseUser !=null
        ?
    FutureBuilder(
      future: Firestore.instance.collection('Users').document(this.firebaseUser.uid).get(),
      builder: ((BuildContext context, AsyncSnapshot user) {

        if (user.hasData == true && user.connectionState == ConnectionState.done) {
          _instagramController.text = user.data['instagram'];
          _snapchatController.text = user.data['snapchat'];
          _facebookController.text = user.data['facebook'];
          _linkedinController.text = user.data['linkedin'];
          _venmoController.text = user.data['venmo'];
          _tiktokController.text = user.data['tiktok'];
        }

        return user.hasData == true && user.connectionState == ConnectionState.done
            ?
        ListView(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          children: <Widget>[
            //Text;
            Container(
              child: Text(
                'Edit Profile & Connect Socials',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //Instagram;
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
                  tileMode: TileMode.clamp
              ).createShader(bounds),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //Snapchat;
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
                  tileMode: TileMode.repeated
              ).createShader(bounds),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //Facebook;
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
                  tileMode: TileMode.clamp
              ).createShader(bounds),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //LinkedIn;
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
                  tileMode: TileMode.clamp
              ).createShader(bounds),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //Venmo
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
                  tileMode: TileMode.clamp
              ).createShader(bounds),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //TikTok
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
                  tileMode: TileMode.clamp
              ).createShader(bounds),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //Save button;
            GestureDetector(
              onTap: () => save(),
              child: Container(
                height: 75.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.black87,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.save, color: Colors.white, size: 40.0),
                      ),
                    ),
                    Expanded(
                        flex: 7,
                        child: Text(this.saveButtonText, style: TextStyle(color: Colors.white, fontSize: 16.0))
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            :
        Center(
          child: CupertinoActivityIndicator(),
        );
      }),
    )
        :
    Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Future<FirebaseUser> save() async {
    this.firebaseUser = await _auth.currentUser();

    //Updating user's data by reference;
    final DocumentReference userReference = Firestore.instance.collection('Users').document(this.firebaseUser.uid);
    userReference.updateData({
      'instagram' : typedInstagram,
      'snapchat' : typedSnapchat,
      'facebook' : typedFacebook,
      'linkedin' : typedLinkedin,
      'venmo' : typedVenmo,
      'tiktok' : typedTikTok,
    }).then((_) {
      widget.profileSaved();
    });

    return this.firebaseUser;
  }

  Future<FirebaseUser> getUser() async {
    this.firebaseUser = await _auth.currentUser();
    return this.firebaseUser;
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
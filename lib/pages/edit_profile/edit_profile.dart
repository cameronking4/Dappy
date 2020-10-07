import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart' as contacts_service;
import 'package:algolia/algolia.dart';
import 'package:swopp2/pages/welcome/welcome_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EditProfile extends StatefulWidget {

  final VoidCallback profileSaved;
  final AlgoliaTask taskAdded;

  EditProfile({
    @required this.profileSaved,
    @required this.taskAdded,
  });

  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {

  Algolia algolia = Application.algolia;

  AlgoliaObjectSnapshot addedObject;

  AlgoliaTask taskUpdated;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  contacts_service.Contact contactsService = new contacts_service.Contact();

  FirebaseUser firebaseUser;

  String saveButtonText = 'Save';

  bool isContactFound = false;

  String firstName = '';
  String lastName = '';
  String typedUsername = '';
  String typedInstagram = '';
  String typedSnapchat = '';
  String typedFacebook = '';
  String typedLinkedin = '';
  String typedVenmo = '';
  String typedTikTok = '';
  String email = '';

  //TextFields Controllers;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _instagramController = TextEditingController();
  final _snapchatController = TextEditingController();
  final _facebookController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _venmoController = TextEditingController();
  final _tiktokController = TextEditingController();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_typedFirstname);
    _lastNameController.addListener(_typedLastname);
    _usernameController.addListener(_typedUsername);
    _instagramController.addListener(_typedInstagram);
    _snapchatController.addListener(_typedSnapchat);
    _facebookController.addListener(_typedFacebook);
    _linkedinController.addListener(_typedLinkedin);
    _venmoController.addListener(_typedVenmo);
    _tiktokController.addListener(_typedTikTok);
    //WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _instagramController.dispose();
    _snapchatController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    _venmoController.dispose();
    _tiktokController.dispose();
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<Iterable<contacts_service.Contact>> getContacts() async {
    Iterable<contacts_service.Contact> contacts = await contacts_service.ContactsService.getContacts();
    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }

  Future<FirebaseUser> save() async {
    this.firebaseUser = await _auth.currentUser();
    print(this.firebaseUser.uid);

    getContacts().then((contacts) {

      for(var contact in contacts) {
        for(var phone in contact.phones) {
          String phoneNumber = phone.value;
          String formattedString = phoneNumber.replaceAll(RegExp('-'), '');
          String formattedNumber = formattedString.replaceAll(' ', '');
          if (formattedNumber == this.firebaseUser.phoneNumber.toString()) {
            this.isContactFound = true;
            this.firstName = contact.givenName;
            print(this.firstName);
            this.lastName = contact.familyName;
            print(this.lastName);
            Item emailItem = contact.emails.first;
            String email = emailItem.value;
            //Updating user's data by reference; (Taking the first relevant value);
            final DocumentReference userReference = Firestore.instance.collection('Users').document(this.firebaseUser.uid);
            userReference.updateData({
              '!firstname' : firstName,
              '!lastname' : lastName,
              'instagram' : typedInstagram,
              'snapchat' : typedSnapchat,
              'facebook' : typedFacebook,
              'linkedin' : typedLinkedin,
              'venmo' : typedVenmo,
              'tiktok' : typedTikTok,
              'email' : email,
            }).then((_) {

              getUser().then((addedObject) async {
                Map<String, dynamic> updateData = Map<String, dynamic>.from(addedObject.data);
                updateData['!firstname'] = firstName;
                updateData['!lastname'] = lastName;
                updateData['instagram'] = typedInstagram;
                updateData['snapchat'] = typedSnapchat;
                updateData['facebook'] = typedFacebook;
                updateData['linkedin'] = typedLinkedin;
                updateData['venmo'] = typedVenmo;
                updateData['tiktok'] = typedTikTok;
                updateData['email'] = email;
                taskUpdated = await algolia.instance.index('users').object(addedObject.objectID).updateData(updateData);
              }).then((result) async {
                // Get the token for this device;
                String fcmToken = await _fcm.getToken();
                // Save it to Firestore;
                if(fcmToken != null) {
                  final DocumentReference userReference = Firestore.instance.collection('Users').document(this.firebaseUser.uid);
                  await userReference.updateData({
                    'token': fcmToken,
                    'createdAt': FieldValue.serverTimestamp()
                  }).then((tokenUpdateResult) {
                    widget.profileSaved();
                  });
                } else {
                  print('something wrong with getting token; saving data interrupted');
                }
              });
            });
          }
          break;
        }
        if(this.isContactFound) {
          break;
        }
      }
    });

    return this.firebaseUser;
  }

  Future<AlgoliaObjectSnapshot> getUser() async {
    addedObject = await Future.delayed(Duration(seconds: 3), () async {
        return await algolia.instance.index('users').object(widget.taskAdded.data['objectID'].toString()).getObject();
      }
    );
    return addedObject;
  }

  _typedFirstname() {
    this.firstName = _firstNameController.text;
  }
  _typedLastname() {
    this.lastName = _lastNameController.text;
  }
  _typedUsername() {
    this.typedUsername = _usernameController.text;
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
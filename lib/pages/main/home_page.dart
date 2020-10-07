import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:swopp2/pages/edit_profile/edit_profile.dart';
import 'package:swopp2/pages/edit_profile/edit_profile_from_drawer/edit_profile_from_drawer.dart';
import 'package:swopp2/pages/notifications/notifications_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swopp2/pages/profile/profile_page.dart';
import 'package:swopp2/pages/recent_exchanges/recent_exchanges_page.dart';
import 'package:swopp2/pages/request/request_page.dart';
import 'package:swopp2/pages/search/search_page.dart';
import 'package:swopp2/pages/swapped/swapped_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swopp2/pages/welcome/welcome_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {

  final bool userExists;
  final AlgoliaTask taskAdded;

  HomePage({
    @required this.userExists,
    this.taskAdded,
  });

  HomePageState createState() => HomePageState();

}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  Algolia algolia = Application.algolia;

  AlgoliaObjectSnapshot addedObject;

  TextStyle _listTileTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontFamily: 'Helvetica-Regular'
  );

  AlgoliaObjectSnapshot algoliaUser;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  TabController mainTabController;

  String qrCode;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String qrCodeData;

  FirebaseUser firebaseUser;

  DocumentSnapshot swappedUser;

  int _activeTabIndex;

  String _uploadedFileURL = '';

  File _image;

  String avatar = 'https://www.shareicon.net/data/512x512/2017/01/06/868320_people_512x512.png';

  String displayName;

  int notificationsNumber;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    mainTabController = TabController(length: 9, initialIndex: isUserExists(widget.userExists), vsync: this);
    mainTabController.addListener(_setActiveTabIndex);
    // Configuring FCM's callbacks;
    _fcm.configure(
      //'onMessage' if received in foreground callback configuration;
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _drawerKey,
      appBar: PreferredSize(
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: this._activeTabIndex == 1 || this._activeTabIndex == 3 || this._activeTabIndex == 4 || this._activeTabIndex == 5 || this._activeTabIndex == 6 || this._activeTabIndex == 7 ? Colors.black : Colors.white,
          elevation: 0.0,
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                this._activeTabIndex != 2 ? Positioned(
                  left: 0.0,
                  child: GestureDetector(
                    child: Image.asset('assets/images/drawer_icon.png', color: this._activeTabIndex == 1 || this._activeTabIndex == 3 || this._activeTabIndex == 4 || this._activeTabIndex == 5 || this._activeTabIndex == 6 || this._activeTabIndex == 7 ? Colors.white : Colors.black),
                    onTap: () {
                      _drawerKey.currentState.openDrawer();
                      // Getting display name;
                      getDisplayName();
                      // Getting number of notifications;
                      getNumberOfNotifications();
                    },
                  ),
                ): Container(),
                Positioned(
                  child: Image.asset('assets/images/logo_swopp.png'),
                ),
                this._activeTabIndex != 2 ? Positioned(
                  right: 0.0,
                  child: GestureDetector(
                    child: Image.asset('assets/images/search_icon.png', color: this._activeTabIndex == 1 || this._activeTabIndex == 3 || this._activeTabIndex == 4 || this._activeTabIndex == 5 || this._activeTabIndex == 6 || this._activeTabIndex == 7 ? Colors.white : Colors.black),
                    onTap: () {
                      toSearchPage();
                    },
                  ),
                ): Container(),
              ],
            ),
          )
        ),
        preferredSize: Size.fromHeight(100.0),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 240.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 140.0,
                          child: Image(
                            image: AdvancedNetworkImage(
                              this.avatar,
                              useDiskCache: true,
                              cacheRule: CacheRule(maxAge: Duration(days: 7)),
                            ),
                            fit: BoxFit.cover,
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                        ),
                        onTap: () {
                          getImage().then((_) async {
                            final StorageReference storageReference = FirebaseStorage().ref().child('avatar-${this.firebaseUser.uid}');
                            final StorageUploadTask uploadTask = storageReference.putFile(_image);
                            await uploadTask.onComplete;
                            print('File Uploaded');
                            storageReference.getDownloadURL().then((fileURL) {
                              setState(() {
                                _uploadedFileURL = fileURL;
                              });
                            }).then((_) {
                              final DocumentReference userReference = Firestore.instance.collection('Users').document(this.firebaseUser.uid);
                              userReference.updateData({
                                'photoUrl' : _uploadedFileURL
                              }).then((_) {
                                setState(() {
                                  print('photoUrl updated');
                                });
                              });
                            });
                          });
                        },
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: GestureDetector(
                          onTap: () {
                            toHomePage();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(this.displayName != null ? this.displayName : 'Loading...',
                                textAlign: TextAlign.center, style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18.0
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text('Home', style: _listTileTextStyle, textAlign: TextAlign.center),
                  onTap: () {
                    toHomePage();
                  },
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text('Edit Profile', style: _listTileTextStyle, textAlign: TextAlign.center),
                  onTap: () {
                    toEditPageFromDrawer();
                  },
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text('Recent Swaps', style: _listTileTextStyle, textAlign: TextAlign.center),
                  onTap: () {
                    toRecentExchangesPage();
                  },
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                        child: Text('Notifications', style: _listTileTextStyle, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.greenAccent,
                          child: Text(this.notificationsNumber != null ? this.notificationsNumber.toString() : '0', style: TextStyle(color: Colors.black87, fontSize: 18.0)),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    toNotifications();
                  },
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text('Privacy Policy', style: _listTileTextStyle, textAlign: TextAlign.center),
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text('Delete Account', style: _listTileTextStyle, textAlign: TextAlign.center),
                  onTap: () {
                    this._auth.signOut();
                  },
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 75.0,
                child: Text('SWOPP, Inc.\nAll Rights Reserved', style: TextStyle(fontSize: 11.0, color: Colors.white), textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: mainTabController,
        children: <Widget>[
          // HomePageTab;
          Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: FutureBuilder(
                  future: _auth.currentUser(),
                  builder: ((BuildContext context, AsyncSnapshot snapshot) {
                    return Container(
                      alignment: Alignment.center,
                      child: QrImage(
                        data: this.firebaseUser != null ? '{"uid" : "${this.firebaseUser.uid}"}' : '{" " : " "}',
                        version: QrVersions.auto,
                        gapless: false,
                        size: 300.0,
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset('assets/images/add_to_wallet_icon.png'),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Image.asset('assets/images/qr_scan.png'),
                  onTap: scanQRCode
                ),
              ),
            ],
          ),
          //NotificationsPageTab;
          NotificationsPage(),
          //SwappedPageTab;
          SwappedPage(swappedUser: swappedUser, swappedProfileDetails: swappedProfileDetails),
          //ProfilePageTab;
          ProfilePage(swappedUser: swappedUser),
          //EditProfilePageTab;
          EditProfile(profileSaved: profileSaved, taskAdded: widget.taskAdded),
          //EditProfileFromDrawerPageTab;
          EditProfileFromDrawer(profileSaved: profileSaved),
          //RecentExchangesPageTab;
          RecentExchangesPage(firebaseUser: this.firebaseUser),
          //SearchPage;
          SearchPage(toRequestPage: toRequestPage),
          //RequestPage;
          RequestPage(algoliaUser: algoliaUser),
        ],
      ),
    );
  }

  int isUserExists(bool isExists) {
    return isExists ? 0 : 4;
  }

  Future<void> getDisplayName() async {
    FirebaseUser currentUser = await _auth.currentUser();
    String uid = currentUser.uid;
    DocumentReference referenceToCurrentUser = Firestore.instance.collection('Users').document(uid);
    DocumentSnapshot currentUserSnapshot = await referenceToCurrentUser.get();
    String firstName = currentUserSnapshot['!firstname'];
    String lastName = currentUserSnapshot['!lastname'];
    //print(firstName + ' ' + lastName);
    setState(() {
      this.displayName = firstName + ' ' + lastName;
    });
  }

  Future<void> getNumberOfNotifications() async {
    FirebaseUser currentUser = await _auth.currentUser();
    String uid = currentUser.uid;
    CollectionReference referenceToCurrentUser = Firestore.instance.collection('Users').document(uid).collection('Notifications');
    QuerySnapshot currentUserNotificationsSnapshot = await referenceToCurrentUser.getDocuments();
    //print(currentUserNotificationsSnapshot.documents.length);
    setState(() {
      this.notificationsNumber = currentUserNotificationsSnapshot.documents.length;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = mainTabController.index;
    });
  }

  void toNotifications() {
    Navigator.of(context).pop();
    this.mainTabController.animateTo(1);
  }

  void toEditPage() {
    Navigator.of(context).pop();
    this.mainTabController.animateTo(4);
  }

  void toEditPageFromDrawer() {
    Navigator.of(context).pop();
    this.mainTabController.animateTo(5);
  }

  void toRecentExchangesPage() {
    Navigator.of(context).pop();
    this.mainTabController.animateTo(6);
  }

  void toSearchPage() {
    this.mainTabController.animateTo(7);
  }

  void toRequestPage(AlgoliaObjectSnapshot user) {
    algoliaUser = user;
    this.mainTabController.animateTo(8);
  }

  Future scanQRCode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.qrCode = barcode;
        Map<String, dynamic> code = json.decode(this.qrCode);
        String connection;
        connection = firebaseUser.uid + '_' + code['uid'];
        print(connection);

        final CollectionReference swopsReference = Firestore.instance.collection('swops');
        final DocumentReference connectionReference = swopsReference.document(connection);
        connectionReference.setData({
          'user_1' : firebaseUser.uid,
          'user_2' : code['uid'],
        }).then((data) {

          final DocumentReference swappedUserReference = Firestore.instance.collection('Users').document(code['uid']);
          swappedUserReference.get().then((DocumentSnapshot swappedUser) {
            this.swappedUser = swappedUser;
            print(this.swappedUser.data);
            this.mainTabController.animateTo(2);
          });
        }).catchError((error) {
          print(error);
        });

      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.qrCode = 'The user did not grant the camera permission!';
          print(this.qrCode);
        });
      } else {
        setState(() => this.qrCode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.qrCode = 'null (User returned using the "back"-button before scanning anything.');
    } catch (e) {
      setState(() => this.qrCode = 'Unknown error: $e');
    }
  }

  void profileSaved() {
    //Navigate to HomePage;
    this.mainTabController.animateTo(0);
  }

  void toHomePage() {
    //Navigate to HomePage;
    Navigator.of(context).pop();
    this.mainTabController.animateTo(0);
  }

  void swappedProfileDetails() {
    //Navigate to ProfilePage;
    this.mainTabController.animateTo(3);
  }

}
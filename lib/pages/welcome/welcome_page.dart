import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swopp2/pages/main/home_page.dart';
import 'package:native_contact_dialog/native_contact_dialog.dart' as dialog;

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'FWP0S84P4F',
    apiKey: '8d06024611f926be01b3a052f0ce0273',
  );
}

class WelcomePage extends StatefulWidget {

  final String phoneNumber;
  final String dialingCode;

  WelcomePage({
    @required this.phoneNumber,
    @required this.dialingCode,
  });

  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {

  Algolia algolia = Application.algolia;

  AlgoliaTask taskAdded;

  AlgoliaObjectSnapshot addedObject;

  AlgoliaObjectSnapshot algoliaUser;

  Map<String, dynamic> user;

  TabController mainTabController;

  String qrCode;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;

  DocumentSnapshot swappedUser;

  String avatar = 'https://www.shareicon.net/data/512x512/2017/01/06/868320_people_512x512.png';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      print('state resumed');

      /*Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => HomePage()),
      );*/

      var userId = this.firebaseUser.uid;
      final DocumentReference userReference = Firestore.instance.collection('Users').document(userId);

      // Creating new user record in Firebase & Algolia then redirect to EditPage;
      userReference.setData({
        '!firstname' : '',
        '!lastname' : '',
        'instagram' : '',
        'snapchat' : '',
        'facebook' : '',
        'linkedin' : '',
        'tiktok' : '',
        'userId' : userId,
        'userPhone' : this.firebaseUser.phoneNumber,
        'photoUrl' : 'https://www.shareicon.net/data/512x512/2017/01/06/868320_people_512x512.png',
        'providerId' : this.firebaseUser.providerId,
        'email' : '',
      }).then((_) {
        //New empty user in Algolia;
        this.user = {
          '!firstname' : '',
          '!lastname' : '',
          'instagram' : '',
          'snapchat' : '',
          'facebook' : '',
          'linkedin' : '',
          'tiktok' : '',
          'userId' : userId,
          'userPhone' : this.firebaseUser.phoneNumber,
          'photoUrl' : 'https://www.shareicon.net/data/512x512/2017/01/06/868320_people_512x512.png',
          'providerId' : this.firebaseUser.providerId,
          'email' : '',
        };
        addUser().then((AlgoliaTask taskAdded) {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => HomePage(userExists: false, taskAdded: this.taskAdded)),
          );
        });
      });

    } else {
      print('else');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: /*ListView(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                    'assets/images/stars_login.png'
                ),
                Image.asset(
                  'assets/images/attendant_welcome.png',
                  scale: 0.9,
                )
              ],
            ),
            Text('Welcome!\n', textAlign: TextAlign.center, style: TextStyle(
                color: Colors.black,
                fontSize: 27.0,
                fontFamily: 'Gotham'
            )),
            Container(
              color: Colors.red,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                        'assets/images/stars_welcome.png'
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Please allow access to your camera, \n contacts and push notification', textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: 'Gotham'
                    )),
                  ),
                  Container(
                    color: Colors.green,
                    child: Text("This is the fun part! \n Let's connect your \n accounts.", textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: 'Gotham'
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 70.0, right: 70.0),
              child: Text("Get Started", style: TextStyle(fontSize: 16.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
              onPressed: () => toHomePage(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              textColor: Colors.white,
              color: Colors.black,
            ),
          ],
        )*/
        Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                //color: Colors.yellow,
                child: Image.asset(
                  'assets/images/attendant_welcome.png',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                //color: Colors.green,
                child: Text('Welcome!', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Gotham-Medium',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                //color: Colors.red,
                child: Text('Please allow access to your camera, \n contacts and push notification', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'Gotham-Medium',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                //color: Colors.orange,
                child: Text("This is the fun part! \n Let's connect your \n accounts.", textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'Gotham-Medium',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 15.0),
                alignment: Alignment.topCenter,
                //color: Colors.deepPurpleAccent,
                child: RaisedButton(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 80.0, right: 80.0),
                  child: Text("Get Started", style: TextStyle(fontSize: 14.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
                  onPressed: () => toHomePage(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  textColor: Colors.white,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toHomePage() {

    ///Checking if user exists;
    _auth.currentUser().then((FirebaseUser currentUser) {
      this.firebaseUser = currentUser;
      var userId = this.firebaseUser.uid;
      final DocumentReference userReference = Firestore.instance.collection('Users').document(userId);
      userReference.get().then((user) {
        if (user.exists) {

          this.avatar = user.data['photoUrl'];

          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => HomePage(userExists: true)),
          );

        } else {

          // Opening native contact dialog;
          String phoneNumber = '+' + widget.dialingCode + widget.phoneNumber;
          String trimmedPhoneNumber  = phoneNumber.split(" ").join("");

            dialog.NativeContactDialog.addContact(dialog.Contact(
              givenName: "Firstname",
              familyName: "Lastname",
              phones: [
                dialog.Item(label: 'Mobile', value: trimmedPhoneNumber),
              ],
            ),
          );
        }
      });
    });

    //To HomePage;
    /*Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => HomePage()),
    );*/

    /*String phoneNumber = '+' + widget.dialingCode + widget.phoneNumber;
    String trimmedPhoneNumber  = phoneNumber.split(" ").join("");

    dialog.NativeContactDialog.addContact(dialog.Contact(
        familyName: "Lastname",
        givenName: "Firstname",
        phones: [
          dialog.Item(label: 'Mobile', value: trimmedPhoneNumber),
        ],
      ),
    );*/

  }

  Future<AlgoliaTask> addUser() async {
    return taskAdded = await algolia.instance.index('users').addObject(user);
  }

}
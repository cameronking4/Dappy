import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class RequestPage extends StatefulWidget {

  final AlgoliaObjectSnapshot algoliaUser;

  RequestPage({
    @required this.algoliaUser,
  });

  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    print(widget.algoliaUser.data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.0),
      child: Column(
        children: <Widget>[
          //Avatar;
          CircleAvatar(
            radius: 75.0,
            child: Image(
              image: AdvancedNetworkImage(
                widget.algoliaUser.data['photoUrl'],
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: Duration(days: 7)),
              ),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
          ),
          //Firstname & Lastname:
          Container(
            child: Text(widget.algoliaUser.data['!firstname'] + ' ' + widget.algoliaUser.data['!lastname'],
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 25.0),
            alignment: Alignment.topCenter,
            child: RaisedButton(
              padding: EdgeInsets.only(top: 25.0, bottom: 25.0, left: 80.0, right: 80.0),
              child: Text("Request Swap", style: TextStyle(fontSize: 16.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
              onPressed: () {
                requestSwap().then((result) {
                  print(result);
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
              textColor: Colors.white,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> requestSwap() async {
    //Getting current user data;
    FirebaseUser currentUser =  await _auth.currentUser();
    String currentUserId = currentUser.uid;
    //Getting current user info by reference from DB;
    DocumentSnapshot currentUserFromDB = await Firestore.instance.collection('Users').document(currentUserId).get();
    Map<String, dynamic> currentUserData = currentUserFromDB.data;
    //Add to requested user in 'Notifications' collection current user data;
    String requestedUserId = widget.algoliaUser.data['userId'];
    //Reference to requested user 'Notifications' collection;
    CollectionReference notificationsReference = Firestore.instance.collection('Users').document(requestedUserId).collection('Notifications');
    //Push current user data to requested user 'Notifications' collection;
    notificationsReference.document(currentUserId).setData(currentUserData);
    return 'notification added';
  }

}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class RecentExchangesPage extends StatefulWidget {

  final FirebaseUser firebaseUser;

  RecentExchangesPage({
    @required this.firebaseUser,
  });

  RecentExchangesPageState createState() => RecentExchangesPageState();

}

class RecentExchangesPageState extends State<RecentExchangesPage> {

  List<String> swapsList = [];

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: Firestore.instance.collection('swops').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return snapshot.hasData == true
            ?
        ListView(
            children: List<Widget>.generate(snapshot.data.documents.length, (int index) {

              String documentID = snapshot.data.documents[index].documentID;

              return documentID.contains(widget.firebaseUser.uid) && documentID.substring(0, 28) == widget.firebaseUser.uid
                  ?
              FutureBuilder(
                future: Firestore.instance.collection('Users').document(documentID.substring(29, 57)).get(),
                builder: ((BuildContext context, AsyncSnapshot snap) {

                  return Card(
                    elevation: 12.0,
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          child: Image(
                            image: AdvancedNetworkImage(
                              snap.data.data['photoUrl'],
                              useDiskCache: true,
                              cacheRule: CacheRule(maxAge: Duration(days: 7)),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Container(
                          padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                          child: Text(snap?.data?.data['!username'], style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),),
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.only(left: 10.0, top: 1.0, bottom: 1.0),
                          margin: EdgeInsets.only(right: 30.0),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Text('Perkins Library', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                        ),
                        dense: false,
                        trailing: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: FlatButton(
                            child: Text('View Details', style: TextStyle(color: Colors.black45, fontSize: 14.0)),
                            onPressed: () {
                              print('to profile page');
                            },
                          ),
                        ),
                      ),
                    ),
                  );

                }),
              )
                  :
              documentID.contains(widget.firebaseUser.uid) && documentID.substring(29, 57) == widget.firebaseUser.uid
                  ?
              FutureBuilder(
                future: Firestore.instance.collection('Users').document(documentID.substring(0, 28)).get(),
                builder: ((BuildContext context, AsyncSnapshot snap) {

                  return Card(
                    elevation: 12.0,
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          child: Image(
                            image: AdvancedNetworkImage(
                              snap.data.data['photoUrl'],
                              useDiskCache: true,
                              cacheRule: CacheRule(maxAge: Duration(days: 7)),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Container(
                          padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                          child: Text(snap?.data?.data['!username'], style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),),
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.only(left: 10.0, top: 1.0, bottom: 1.0),
                          margin: EdgeInsets.only(right: 30.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Text('Perkins Library', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                        ),
                        dense: false,
                        trailing: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: FlatButton(
                            child: Text('View Details', style: TextStyle(color: Colors.black45, fontSize: 14.0)),
                            onPressed: () {
                              print('to profile page');
                            },
                          ),
                        ),
                      ),
                    ),
                  );

                }),
              )
                  :
              Container();
            }).toList()
        )
            :
        CircularProgressIndicator();

      },
    );

  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class NotificationsPage extends StatefulWidget {

  NotificationPageState createState() => NotificationPageState();

}

class NotificationPageState extends State<NotificationsPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _auth.currentUser(),
      builder: ((BuildContext context, AsyncSnapshot currentUser) {

        if (currentUser.connectionState == ConnectionState.done && currentUser.hasData == true) {

          this.currentUser = currentUser.data;

          return StreamBuilder(
            stream: Firestore.instance.collection('Users').document(this.currentUser.uid).collection('Notifications').snapshots(),
            builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> notifications) {

              if(notifications.connectionState == ConnectionState.active && notifications.hasData == true) {

                QuerySnapshot notificationsData = notifications.data;

                List<DocumentSnapshot> notificationsList = notificationsData.documents;

                return ListView.builder(
                  itemCount: notificationsList.length,
                  itemBuilder: ((BuildContext context, int index) {

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
                                notificationsList[index]['photoUrl'],
                                useDiskCache: true,
                                cacheRule: CacheRule(maxAge: Duration(days: 7)),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Container(
                            padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                            child: Text(notificationsList[index]['!firstname'], style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0, top: 3.0, bottom: 3.0, right: 10.0),
                                  margin: EdgeInsets.only(right: 15.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  child: Text('Decline Request', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                                ),
                                onTap: () {
                                  declineNotification(notificationsList[index].reference.path).then((res) {
                                    print(res);
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0, top: 3.0, bottom: 3.0, right: 10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  child: Text('Accept Request', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                                ),
                                onTap: () {
                                  acceptNotification(notificationsList[index].data['userId'], notificationsList[index].reference.path).then((res) {
                                    print(res);
                                  });
                                },
                              ),
                            ],
                          ),
                          dense: false,
                        ),
                      ),
                    );

                  }),
                );

              } else {

                return Container();

              }

            }),
          );

        } else {

          return Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
      }),
    );
  }

  Future<String> declineNotification(String pathToNotification) async {
    String notificationPath = pathToNotification;
    DocumentReference referenceToNotification = Firestore.instance.document(notificationPath);
    await referenceToNotification.delete();
    return 'notification declined';
  }

  Future<String> acceptNotification(String notificationUserId, String pathToNotification) async {
    String notificationPath = pathToNotification;
    String currentUserId = this.currentUser.uid;
    String userId = notificationUserId;
    String connection;
    connection = userId + '_' + currentUserId;
    print(connection);
    final CollectionReference swopsReference = Firestore.instance.collection('swops');
    final DocumentReference connectionReference = swopsReference.document(connection);
    await connectionReference.setData({
      'user_1' : userId,
      'user_2' : currentUserId,
    });
    DocumentReference referenceToNotification = Firestore.instance.document(notificationPath);
    await referenceToNotification.delete();
    //Once request accepted, remove notification;
    return 'notification accepted';
  }

}
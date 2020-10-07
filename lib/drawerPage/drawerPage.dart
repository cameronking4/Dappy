import 'package:flutter/material.dart';
import 'package:swapTech/editProfilePage/editProfile.dart';
import 'package:swapTech/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/notificationPage/notificationPage.dart';
import 'package:swapTech/swapPage/recentSwap.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  SwapModel swapModel = SwapModel();
  ProfileModel objSwappProfile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    ClipPath(
                      clipper: TopBarClipper(
                        topLeft: true,
                        topRight: true,
                        bottomLeft: true,
                        bottomRight: true,
                        radius: 100,
                      ),
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        imageUrl: globals.objProfile.photoUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 35.0,
                        width: 170.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          "${globals.objProfile.firstName}" "\t" + "${globals.objProfile.lastName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 18.0),
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
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.HOME);
              },
              child: Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Gotham-Light',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
              child: Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Gotham-Light',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentSwapPage(),
                  ),
                );
              },
              child: Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text(
                    'Recent Swaps',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Gotham-Light',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetail(),
                  ),
                );
              },
              child: Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Expanded(
                      //   child: Container(),
                      // ),
                      Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Gotham-Light',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Expanded(
                      //   child: CircleAvatar(
                      //     radius: 15.0,
                      //     backgroundColor: Colors.greenAccent,
                      //     child: Text("1",
                      //         style: TextStyle(
                      //             color: Colors.black87, fontSize: 18.0)),
                      //   ),
                      // ),
                    ],
                  ),
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
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Gotham-Light',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white,
            ),
            InkWell(
              onTap: () async {
                globals.objProfile = null;
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, Routes.LOGIN);
              },
              child: Container(
                color: Colors.black,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Gotham-Light',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
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
    );
  }
}

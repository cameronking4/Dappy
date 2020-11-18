import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/components/z_select_single_image.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:swapTech/editProfilePage/editProfile.dart';
import 'package:swapTech/homePage/homePage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/notificationPage/notificationPage.dart';
import 'package:swapTech/providers/auth_provider.dart';
import 'package:swapTech/swapPage/recentSwap.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  SwapModel swapModel = SwapModel();
  ProfileModel objSwappProfile;
  File newProfileImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(80),
        ),
        child: Drawer(
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
                        ZSelectSingleImage(
                          height: 150,
                          width: 150,
                          isEnabled: true,
                          imageFile: newProfileImage,
                          imageUrl: globals.objProfile.photoUrl,
                          borderRadius: BorderRadius.circular(100),
                          onImageChange: (res) {
                            newProfileImage = res;
                            ApiProvider().updateUserProfilePhoto(
                                profile: globals.objProfile,
                                file: newProfileImage);
                            setState(() {});
                          },
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
                              "${globals.objProfile.userName}",
                              // "\t" + "${globals.objProfile.lastName}"
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18.0),
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
                    Get.offAll(HomePage());
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
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => HomePage(),
                //       ),
                //     );
                //   },
                // //   child: Container(
                // //     color: Colors.black,
                // //     child: ListTile(
                // //       contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                // //       title: Text(
                // //         'Search for Friends',
                // //         style: TextStyle(
                // //           fontSize: 14.0,
                // //           fontFamily: 'Gotham-Light',
                // //           fontWeight: FontWeight.bold,
                // //           color: Colors.white,
                // //         ),
                // //         textAlign: TextAlign.center,
                // //       ),
                // //     ),
                // //   ),
                // // ),
                // // Divider(
                // //   height: 2.0,
                // //   color: Colors.white,
                // // ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()));
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
                              'Swap Requests',
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
                    context.read<AuthProvider>().signOut();
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
                  child: Text('SWOPP, Inc.\nAll Rights Reserved',
                      style: TextStyle(fontSize: 11.0, color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ));
  }
}

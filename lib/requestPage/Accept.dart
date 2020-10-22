import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/notificationModel.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/notificationPage/notificationPage.dart';
import 'package:swapTech/searchPage/searchPage.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:swapTech/constance/global.dart' as globals;

class RequestPageAccept extends StatefulWidget {
  final ProfileModel userProfile;

  RequestPageAccept({this.userProfile});

  @override
  _RequestPageStateAccept createState() => _RequestPageStateAccept();
}

class _RequestPageStateAccept extends State<RequestPageAccept> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationModel objNotificationModel = NotificationModel();

  bool isLoading = false;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Colors.black,
          ),
          Container(
            height: 150,
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
                children: [
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Image.asset(
                      ConstanceData.drawerIcon,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    height: 80,
                    child: Image.asset(
                      ConstanceData.appLogo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      setState(() {
                        // isSearch = true;
                      });
                    },
                    child: Image.asset(
                      ConstanceData.searchIcon,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipPath(
                            clipper: TopBarClipper(
                              topLeft: true,
                              topRight: true,
                              bottomLeft: true,
                              bottomRight: true,
                              radius: 130,
                            ),
                            child: CachedNetworkImage(
                              height: 130,
                              width: 130,
                              imageUrl: widget.userProfile.photoUrl,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(width: 270, child: 
                      Text(widget.userProfile.firstName + ' ' + widget.userProfile.lastName,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 4,)),
                      SizedBox(height:15), 
                      Text(widget.userProfile.userName,
                          style: TextStyle(fontSize: 12.0)),
                      
                      widget.userProfile.userId == globals.objProfile.userId ?
                      Container() :
                      SizedBox(height: 25),
                      Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(5, 5), //(x,y)
                          ),
                        ],
                      ),
                      child: FlatButton(
                       onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationDetail(
                                ),
                              ),
                            );
                        },                  
                      child: Text(
                    "Return to Swap Requests",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

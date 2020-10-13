import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/notificationModel.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/searchPage/searchPage.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';

class NotificationDetail extends StatefulWidget {
  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NotificationModel> lstNotification = [];

  SwapModel swapModel = SwapModel();
  ProfileModel profile;
  ProfileModel objSwappProfile;

  bool isProgress = false;
  bool isSearch = false;

  @override
  void initState() {
    getNotificationDetail();
    super.initState();
  }

  getNotificationDetail() async {
    setState(() {
      isProgress = true;
    });
    lstNotification = await ApiProvider().notificationDetail();
    setState(() {
      isProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(),
      body: ModalProgressHUD(
        inAsyncCall: isProgress,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.black,
            ),
            appBar(),
            !isSearch
                ? Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Row(
                            children: [
                              Text(
                                "Notifications",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Gotham-Medium',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: lstNotification.length,
                            itemBuilder: (BuildContext context, index) {
                              return FutureBuilder(
                                future: ApiProvider().getProfileDetail(lstNotification[index].userId),
                                builder: (BuildContext context, AsyncSnapshot<ProfileModel> objProfileModel) {
                                 if (lstNotification.length > 0) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 14, right: 14),
                                          child: Card(
                                            elevation: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                              child: Row(
                                                children: [
                                                  ClipPath(
                                                    clipper: TopBarClipper(
                                                      topLeft: true,
                                                      topRight: true,
                                                      bottomLeft: true,
                                                      bottomRight: true,
                                                      radius: 60,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      height: 60,
                                                      width: 60,
                                                      imageUrl: objProfileModel.data.photoUrl,
                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        objProfileModel.data.firstName + " " + objProfileModel.data.lastName,
                                                        style: TextStyle(
                                                          color: Colors.blueGrey,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              lstNotification[index].isAccept = false;
                                                              lstNotification[index].declined = true;
                                                              await updateRequest(lstNotification[index]);
                                                              lstNotification.remove(lstNotification[index]);
                                                              Fluttertoast.showToast(msg: "Declined Request Successfully.");
                                                              // await deleteRequest(lstNotification[index]);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[700],
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(4),
                                                                child: Text(
                                                                  "Decline Request",
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              lstNotification[index].isAccept = true;
                                                              lstNotification[index].declined = false;
                                                              await updateRequest(lstNotification[index]);
                                                              swapModel.locationAddreess = "Via Search";
                                                              swapModel.userId = lstNotification[index].userId;
                                                              swapModel.swapuserId = lstNotification[index].requestUserId;
                                                              lstNotification.remove(lstNotification[index]);
                                                              await performSwap(swapModel);
                                                              Fluttertoast.showToast(msg: "Accepted Request Successfully!! :)");
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[700],
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(4),
                                                                child: Text(
                                                                  "Accept Request",
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    );
                                 }
                                  else {
                                     return new Text( "You have no new notifications. Come back later :)");
                                  }
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : SearchPage()
          ],
        ),
      ),
    );
  }

  Future updateRequest(NotificationModel objNotification) async {
    setState(() {
      isProgress = true;
    });
    await ApiProvider().updateNotification(objNotification);
    setState(() {
      isProgress = false;
    });
  }

   Future performSwap(SwapModel swapModel) async {
    setState(() {
      isProgress = true;
    });
    await ApiProvider().swapUserProfile(swapModel);
    setState(() {
      isProgress = false;
    });
  }

  // Future deleteRequest(NotificationModel objNotificationModel) async {
  //   setState(() {
  //     isProgress = true;
  //   });
  //   await ApiProvider().deleteNotification(objNotificationModel);
  //   setState(() {
  //     isProgress = false;
  //   });
  // }

  Widget appBar() {
    return Container(
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
                color: Colors.white,
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
                  isSearch = true;
                });
              },
              child: Image.asset(
                ConstanceData.searchIcon,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/homePage/homePage.dart';
import 'package:swapTech/model/notificationModel.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/profile/userProfile.dart';
import 'package:swapTech/requestPage/Accept.dart';
import 'package:swapTech/searchPage/searchPage.dart';
import 'package:swapTech/swapPage/recentSwap.dart';
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
              height: MediaQuery.of(context).padding.top + 10,
              // height: 75,
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
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Swap Requests",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Gotham-Medium',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        lstNotification.length > 0 ? 
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: lstNotification.length,
                            itemBuilder: (BuildContext context, index) {
                              return FutureBuilder(
                                future: ApiProvider().getProfileDetail(lstNotification[index].userId),
                                builder: (BuildContext context, AsyncSnapshot<ProfileModel> objProfileModel) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        new InkWell(
                                        onTap: () {
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RequestPageAccept(
                                              userProfile: objProfileModel.data,
                                            ),
                                          ),);
                                        }, 
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.only(left: 14, right: 14),
                                          child: 
                                           Card(
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
                                                    Container( width: 220,
                                                      child: 
                                                      Text(
                                                        objProfileModel.data.firstName + " " + objProfileModel.data.lastName,
                                                        style: TextStyle(
                                                          color: Colors.blueGrey,
                                                          fontSize: 15.0,
                                                        ),
                                                         overflow: TextOverflow.ellipsis,
                                                        maxLines: 4
                                                      )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              lstNotification[index].isAccept = false;
                                                              lstNotification[index].declined = true;
                                                              await updateRequest(lstNotification[index]);
                                                              lstNotification.remove(lstNotification[index]);
                                                              Fluttertoast.showToast(msg: "Declined Request Successfully. Only you sees this.");
                                                              // await deleteRequest(lstNotification[index]);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Text(
                                                                  " Decline ",
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 16.0,
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
                                                              await performSwap(swapModel);
                                                              lstNotification.remove(lstNotification[index]);
                                                              // var obj = await ApiProvider().getProfileDetail(lstNotification[index].userId);
                                                              Fluttertoast.showToast(msg: "Accepted Request Successfully!! :)");
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => RecentSwapPage(),
                                                                  ),
                                                                ); 
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.green,
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Text(
                                                                  " Accept ",
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 16.0,
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
                                        )),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                          ),
                        ): 
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: 
                             Center(
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const ListTile(
                                      // leading: Icon(Icons.album),
                                      title: Text('No Swap Requests'),
                                      subtitle: Text('Sorry, it seems you have no new notifications. Feel free to check again later. In the meantime, you can always share your link, search for users and keep swapping.'),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          child: const Text('Home'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                    
                                                 ),
                                                ),
                                              );
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        TextButton(
                                          child: const Text('Swap History'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RecentSwapPage(
                                                 ),
                                                ),
                                              );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                           )
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
      height: 75,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 5),
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
              height: 55,
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

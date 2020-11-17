import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/homePage/homePage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/notificationPage/notificationPage.dart';
import 'package:swapTech/profile/userProfile.dart';
import 'package:swapTech/searchPage/searchPage.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:swapTech/constance/global.dart' as globals;

class RecentSwapPage extends StatefulWidget {
  @override
  _RecentSwapPageState createState() => _RecentSwapPageState();
}

class _RecentSwapPageState extends State<RecentSwapPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearch = false;
  SwapModel objSwapModel;

  bool isProgress = false;

  List<SwapModel> lstSwapModel = [];

  getData() async {
    setState(() {
      isProgress = true;
    });
    lstSwapModel = await ApiProvider().getRecentSwapDetail();
    setState(() {
      isProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 14, top: 14),
                          child: Row(
                            children: [
                              Text(
                                "Swap History",
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
                          height: 10,
                        ),
                        lstSwapModel.length > 0
                            ? Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: lstSwapModel.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return FutureBuilder(
                                      future: ApiProvider().getProfileDetail(
                                          globals.objProfile.userId ==
                                                  lstSwapModel[index].swapuserId
                                              ? lstSwapModel[index].userId
                                              : lstSwapModel[index].swapuserId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<ProfileModel>
                                              objProfileModel) {
                                        if (!objProfileModel.hasData) {
                                          return SizedBox();
                                        } else {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              new InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserProfilePage(
                                                          userProfile:
                                                              objProfileModel
                                                                  .data,
                                                          swapModel:
                                                              lstSwapModel[
                                                                  index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: Card(
                                                      elevation: 5,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Row(
                                                          children: [
                                                            ClipPath(
                                                                clipper:
                                                                    TopBarClipper(
                                                                  topLeft: true,
                                                                  topRight:
                                                                      true,
                                                                  bottomLeft:
                                                                      true,
                                                                  bottomRight:
                                                                      true,
                                                                  radius: 60,
                                                                ),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 35.0,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          objProfileModel.data.photoUrl ??
                                                                              ""),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                )

                                                                //  CachedNetworkImage(
                                                                //   height: 60,
                                                                //   width: 60,
                                                                //   imageUrl: objProfileModel.data.photoUrl,
                                                                //   placeholder: (context, url) => CircularProgressIndicator(),
                                                                //   errorWidget: (context, url, error) => Icon(Icons.error),
                                                                // ),
                                                                ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                      width:
                                                                          350,
                                                                      child: Text(
                                                                          (objProfileModel?.data?.firstName ?? "") +
                                                                              " " +
                                                                              (objProfileModel?.data?.lastName ??
                                                                                  ""),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.blueGrey,
                                                                            fontSize:
                                                                                15.0,
                                                                          ),
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          maxLines:
                                                                              4)),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black54,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Text(
                                                                        (objProfileModel?.data?.userName ??
                                                                                "") +
                                                                            " ",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              13.0,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        maxLines:
                                                                            3,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            UserProfilePage(
                                                                      userProfile:
                                                                          objProfileModel
                                                                              .data,
                                                                      swapModel:
                                                                          lstSwapModel[
                                                                              index],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                'View Details',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .blueGrey[
                                                                      300],
                                                                  fontSize:
                                                                      13.0,
                                                                ),
                                                              ),
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
                                      },
                                    );
                                  },
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Center(
                                      child: Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const ListTile(
                                              // leading: Icon(Icons.album),
                                              title: Text('No Swaps History'),
                                              subtitle: Text(
                                                  'Seems like you do not have any swaps yet. Start swapping by sharing your link, searching for users or contactlessy displaying your QR code. All of your swap history will display here.'),
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  child: const Text('Home'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                TextButton(
                                                  child: const Text(
                                                      'Notifications'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            NotificationDetail(),
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
                                    )))
                      ],
                    ),
                  )
                : SearchPage(),
          ],
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.only(left: 20, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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

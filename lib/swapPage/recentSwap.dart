import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
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
              height: MediaQuery.of(context).padding.top,
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
                                "Recent Swaps",
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
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: lstSwapModel.length,
                            itemBuilder: (BuildContext context, index) {
                              return FutureBuilder(
                                future: ApiProvider().getProfileDetail(globals.objProfile.userId == lstSwapModel[index].swapuserId
                                    ? lstSwapModel[index].userId
                                    : lstSwapModel[index].swapuserId),
                                builder: (BuildContext context, AsyncSnapshot<ProfileModel> objProfileModel) {
                                  if (!objProfileModel.hasData) {
                                    return SizedBox();
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Card(
                                            elevation: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                                                    width: 25,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          objProfileModel.data.firstName + " " + objProfileModel.data.lastName ,
                                                          style: TextStyle(
                                                            color: Colors.blueGrey,
                                                            fontSize: 14.0,
                                                          ),
                                                          overflow: TextOverflow.visible,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(3.0),
                                                            child: Text(
                                                              objProfileModel.data.userName,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14.0,
                                                              ),
                                                              overflow: TextOverflow.visible,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => UserProfilePage(userProfile: objProfileModel.data),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'View Details',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
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
                                },
                              );
                            },
                          ),
                        )
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

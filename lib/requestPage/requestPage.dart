import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/notificationModel.dart';
import 'package:swapTech/searchPage/searchPage.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:swapTech/constance/global.dart' as globals;

class RequestPage extends StatefulWidget {
  final UserPhone objUserPhone;

  RequestPage({
    this.objUserPhone,
  });

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationModel objNotificationModel = NotificationModel();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
        child: Column(
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
                      onTap: () {},
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipPath(
                  clipper: TopBarClipper(
                    topLeft: true,
                    topRight: true,
                    bottomLeft: true,
                    bottomRight: true,
                    radius: 140,
                  ),
                  child: CachedNetworkImage(
                    height: 140,
                    width: 140,
                    imageUrl: globals.objProfile.photoUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(width: 250,
                 child: Text(
                  widget.objUserPhone.firstName + " " + widget.objUserPhone.lastName  ,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  maxLines: 4,
                )),
                Text(
                  widget.objUserPhone.userName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    requestSwap();
                  },
                  child: Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment(0.5, 0.0),
                        colors: [const Color(0xFF4E4E4E), const Color(0xFF000000)],
                      ),
                      // color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Request Swap",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gotham-Medium',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  requestSwap() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.objUserPhone.userId != null) {
        objNotificationModel.userId = globals.objProfile.userId;
        objNotificationModel.requestUserId = widget.objUserPhone.userId;

        await ApiProvider().addNotification(objNotificationModel);
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Notification Send succsessfull !");
      } else {
        Fluttertoast.showToast(msg: "Something went to wrong !");
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

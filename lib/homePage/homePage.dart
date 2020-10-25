import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/enumSwapStage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/permission/permissions.dart';
import 'package:swapTech/profile/userProfile.dart';
import 'package:swapTech/searchPage/searchPage.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:location/location.dart' as locationPlugin;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  locationPlugin.Location location = new locationPlugin.Location();
  locationPlugin.LocationData _locationData;
  Map<String, dynamic> code;

  String qrCodeData;
  String connection = "";
  String barCode = "";

  SwapModel swapModel = SwapModel();
  ProfileModel profile;
  ProfileModel objSwappProfile;

  bool isSearch = false;
  bool _isLoding = false;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  SwapPageStatus enumSwapPageStatus;

  @override
  void initState() {
    super.initState();
    enumSwapPageStatus = SwapPageStatus.Home;
    updateFCMTken();
  }

  updateFCMTken() async {
    globals.objProfile.token = await _fcm.getToken();
    await ApiProvider().updateUserFCMToken();

    bool isContactAdd = await ApiProvider().searchContactAdd();
    if (isContactAdd) {
      print("ok");
    } else {
      print("NO");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(),
      body: ModalProgressHUD(
        inAsyncCall: _isLoding,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
        child: enumSwapPageStatus == SwapPageStatus.Home
            ? StreamBuilder(
                stream: Firestore.instance.collection('Swap').snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return SizedBox();
                  } else {
                    if (snap.data.documents.length > 0) {
                      SwapModel objSwapModel = new SwapModel();
                      for (var docData in snap.data.documents) {
                        objSwapModel = SwapModel.parseSnapshot(docData);
                        if (!objSwapModel.isDismiss && objSwapModel.userId == globals.objProfile.userId && objSwapModel.isScannerUser) {
                          gotoSwapProfileScreen(objSwapModel, false);
                          break;
                        } else if (!objSwapModel.isDismiss && objSwapModel.swapuserId == globals.objProfile.userId && objSwapModel.isScannerUser) {
                          gotoSwapProfileScreen(objSwapModel, true);
                          break;
                        } else {
                          barCodeScreen();
                        }
                        

                        if (objSwapModel.isDismiss == false) {
                          if (objSwapModel.swapuserId == globals.objProfile.userId) {
                            gotoSwapProfileScreen(objSwapModel, true);
                          } else {
                            Stream<QuerySnapshot> snapshot =
                                Firestore.instance.collection('Swap').where("userId", isEqualTo: globals.objProfile.userId).snapshots();
                            snapshot.listen((snapShot) {
                              if (snapShot.documents.length > 0) {
                                SwapModel objSwapModel = SwapModel.parseSnapshot(snapShot.documents[0]);
                                if (objSwapModel.isDismiss) {
                                  setState(() {
                                    enumSwapPageStatus = SwapPageStatus.Home;
                                  });
                                } else {
                                  if (objSwapModel.swapuserId == globals.objProfile.userId) {
                                    gotoSwapProfileScreen(objSwapModel, true);
                                  } else {
                                    gotoSwapProfileScreen(objSwapModel, false);
                                  }
                                }
                              }
                            });
                          }
                        } else {
                          return barCodeScreen();
                        }
                      }
                      return barCodeScreen();
                    } else {
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection('Swap')
                            .where("userId", isEqualTo: globals.objProfile.userId)
                            .where("swapuserId", isEqualTo: barCode)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox();
                          } else {
                            if (snapshot.data.documents.length > 0) {
                              SwapModel objSwapModel = SwapModel.parseSnapshot(snapshot.data.documents[0]);
                              gotoSwapProfileScreen(objSwapModel, false);
                              return SizedBox();
                            } else {
                              return barCodeScreen();
                            }
                          }
                        },
                      );
                    }
                  }
                })
            : ListView(
                padding: EdgeInsets.all(0),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  SizedBox(
                    height: 80,
                    child: Image.asset(
                      ConstanceData.appLogo,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'SWAPPED!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 50.0,
                      fontFamily: 'Gotham-Medium',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/swapped_arrow.png',
                          scale: 1.1,
                        ),
                      ),
                      Container(
                        height: 140,
                        width: 140.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(150)),
                          border: Border.all(
                            color: Colors.black87,
                            width: 4.0,
                          ),
                        ),
                        child: ClipPath(
                          clipper: TopBarClipper(
                            topLeft: true,
                            topRight: true,
                            bottomLeft: true,
                            bottomRight: true,
                            radius: 130,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: objSwappProfile.photoUrl,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 90.0,
                              backgroundImage: AssetImage(
                                'assets/images/logo_swopp.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Text(
                    objSwappProfile.firstName + " " + objSwappProfile.lastName,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 36.0,
                      fontFamily: 'Helvetica-Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text("View Profile", style: TextStyle(fontSize: 18.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                              userProfile: objSwappProfile,
                            ),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      textColor: Colors.white,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text("Dismiss",
                          style: TextStyle(fontSize: 18.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold, color: Colors.black54)),
                      onPressed: () async {
                        setState(() {
                          _isLoding = true;
                        });
                        await ApiProvider().dismissSwapReq(swapModel);
                        setState(() {
                          _isLoding = false;
                          enumSwapPageStatus = SwapPageStatus.Home;
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      hoverElevation: 0.0,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 20,
                  ),
                ],
              ),
      ),
      floatingActionButton:
      isSearch ? null :  
      SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          // animatedIcon: AnimatedIcons.add_event,
          // animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          child: Icon(Icons.share),
          // If true user is forced to close dial manually 
          // by tapping main button and overlay is not rendered.
          closeManually: true,
          curve: Curves.bounceInOut,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 10.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.account_balance_wallet_rounded),
              backgroundColor: Colors.purple,
              label: 'Add to Wallet',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('Download QR Code')
            ),
            SpeedDialChild(
              child: Icon(Icons.link),
              backgroundColor: Colors.orange,
              label: 'Share Private Link',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => shareUserLink(globals.objProfile.userId, globals.objProfile.token),
            ),
            SpeedDialChild(
              child: Icon(Icons.qr_code_scanner_rounded),
              backgroundColor: Colors.pink,
              label: 'Scan QR Code',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              onTap: () => scanQrCode(),
            ),
          ],
        ),
     floatingActionButtonLocation: FloatingActionButtonLocation.endDocked
     );
  }

  Widget barCodeScreen() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Colors.white,
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Expanded(child: SizedBox( width: 30,)),
                SizedBox(
                  height: 70,
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
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        !isSearch
            ? Expanded(
                child: SizedBox(),
              )
            : SizedBox(),
        isSearch
            ? SearchPage()
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImage(
                    data: globals.objProfile.userId,
                    version: QrVersions.auto,
                    gapless: true,
                    embeddedImage:  NetworkImage(globals.objProfile.photoUrl),
                    embeddedImageStyle: QrEmbeddedImageStyle(size: Size.square(65)),
                    size: 275.0,
                  ),
                  Container(
                  width:250, 
                  child:
                  Center(child:
                    Text(globals.objProfile.firstName + " " + globals.objProfile.lastName, 
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Gotham-Medium',
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ),
                ),
                 SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        " " + globals.objProfile.userName + " " ,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      scanQrCode();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        ConstanceData.qrScan,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
        !isSearch
            ? Expanded(
                flex: 2,
                child: SizedBox(),
              )
            : SizedBox(),
      ],
    );
  }

  gotoSwapProfileScreen(SwapModel objSwapModel, bool isOpposite) async {
    if (isOpposite) {
      objSwappProfile = await ApiProvider().getProfileDetail(objSwapModel.userId);
    } else {
      objSwappProfile = await ApiProvider().getProfileDetail(objSwapModel.swapuserId);
    }
    setState(() {
      enumSwapPageStatus = SwapPageStatus.Swap;
    });
  }

  Future<Uint8List> toQrImageData(String text) async {
  try {
    final image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return a.buffer.asUint8List();
  } catch (e) {
    throw e;
  }
}

  Future<bool> checkPermission() async {
    bool result = await Permissions().getPermission();
    if (result) {
      return true;
    } else {
      await Permissions().getPermission();
      return false;
    }
  }

  shareUserLink(userId, token ) {
    final RenderBox box = context.findRenderObject();
    Share.share(
      'Check out my link https://dappyweb.web.app/' + token + "/" + userId + " !",
      subject: 'This private link has all my contact info and socials :)',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );
  }


  scanQrCode() async {
    setState(() {
      _isLoding = true;
    });
    
      // Get Location Address

      try {
        ScanResult barcode = await BarcodeScanner.scan();

        if (barcode.rawContent != null && barcode.rawContent != "") {
          setState(() {
            barCode = barcode.rawContent;
          });

          bool permission = await checkPermission();

         if (permission) {
          _locationData = await location.getLocation();
          final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
          var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          swapModel.locationAddreess = addresses.first.addressLine;
         }
          else {
           await checkPermission();
          }

          swapModel.userId = globals.objProfile.userId;
          swapModel.swapuserId = barcode.rawContent;
          
          await ApiProvider().swapUserProfile(swapModel);
          setState(() {
            _isLoding = false;
          });
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoding = false;
        });
      }
    } 
}

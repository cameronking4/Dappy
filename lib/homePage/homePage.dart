import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:let_log/let_log.dart';
import 'package:provider/provider.dart';
import 'package:swapTech/providers/auth_provider.dart';
import 'package:swapTech/providers/dynamic_link_provider.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
// import 'package:share/share.dart';
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
import 'package:location/location.dart' as locationPlugin;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:swapTech/FlutterWidgetData.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

class HomePage extends StatefulWidget {
  final bool shouldCallSwipe;

  const HomePage({
    Key key,
    this.shouldCallSwipe = false,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dynamicLink;

  locationPlugin.Location location = new locationPlugin.Location();
  locationPlugin.LocationData _locationData;
  Map<String, dynamic> code;

  String qrCodeData;
  String connection = "";
  String barCode = "";

  GlobalKey globalKey = new GlobalKey();

  SwapModel swapModel = SwapModel();
  ProfileModel profile;
  ProfileModel objSwappProfile;

  bool isSearch = false;
  bool _isLoding = false;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  SwapPageStatus enumSwapPageStatus;
  String parametersLink;

  @override
  void initState() {
    super.initState();
    enumSwapPageStatus = SwapPageStatus.Home;
    updateFCMTken();
    getDynamicLink().then((value) {
      dynamicLink = value;
      setState(() {});
    }).catchError((onError) => print("ERROR GETTING DYNAMIC LINK"));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Logger.log("SHOULD CALL SWIPE", widget.shouldCallSwipe);
      if (widget.shouldCallSwipe) {
        final userId = context.read<DynamicLinkProvider>().linkShareUserId;
        Logger.log("linkShareUserId", userId);
        await scanQrCode(dynamicLinkUserId: userId);
        context.read<DynamicLinkProvider>().linkStatus = LinkStatus.NoLink;
      }
    });

    // initPlatformState();
  }

  Future<void> initPlatformState() async {
    final data = FlutterWidgetData("dappy.me/"+ globals.objProfile.userId);
    final resultString = await WidgetKit.getItem('testString', 'group.com.dappy');
    final resultBool = await WidgetKit.getItem('testBool', 'group.com.dappy');
    final resultNumber = await WidgetKit.getItem('testNumber', 'group.com.dappy');
    final resultJsonString = await WidgetKit.getItem('testJson', 'group.com.dappy');

    var resultData;
    if(resultJsonString != null) {
      resultData = FlutterWidgetData.fromJson(jsonDecode(resultJsonString));
    }

    WidgetKit.setItem('testString', 'Hello World', 'group.com.dappy');
    WidgetKit.setItem('testBool', false, 'group.com.dappy');
    WidgetKit.setItem('testNumber', 10, 'group.com.dappy');
    WidgetKit.setItem('testJson', jsonEncode(data), 'group.com.dappy');
    WidgetKit.setItem('widgetData', jsonEncode(data), 'group.com.dappy');
    print( "Link is set to Widget!!!!");
    WidgetKit.reloadAllTimelines();
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
                          if (!objSwapModel.isDismiss &&
                              objSwapModel.userId ==
                                  globals.objProfile.userId &&
                              objSwapModel.isScannerUser) {
                            gotoSwapProfileScreen(objSwapModel, false);
                            break;
                          } else if (!objSwapModel.isDismiss &&
                              objSwapModel.swapuserId ==
                                  globals.objProfile.userId &&
                              objSwapModel.isScannerUser) {
                            gotoSwapProfileScreen(objSwapModel, true);
                            break;
                          } else {
                            barCodeScreen();
                          }

                          if (objSwapModel.isDismiss == false) {
                            if (objSwapModel.swapuserId ==
                                globals.objProfile.userId) {
                              gotoSwapProfileScreen(objSwapModel, true);
                            } else {
                              Stream<QuerySnapshot> snapshot = Firestore
                                  .instance
                                  .collection('Swap')
                                  .where("userId",
                                      isEqualTo: globals.objProfile.userId)
                                  .snapshots();
                              snapshot.listen((snapShot) {
                                if (snapShot.documents.length > 0) {
                                  SwapModel objSwapModel =
                                      SwapModel.parseSnapshot(
                                          snapShot.documents[0]);
                                  if (objSwapModel.isDismiss) {
                                    setState(() {
                                      enumSwapPageStatus = SwapPageStatus.Home;
                                    });
                                  } else {
                                    if (objSwapModel.swapuserId ==
                                        globals.objProfile.userId) {
                                      gotoSwapProfileScreen(objSwapModel, true);
                                    } else {
                                      gotoSwapProfileScreen(
                                          objSwapModel, false);
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
                              .where("userId",
                                  isEqualTo: globals.objProfile.userId)
                              .where("swapuserId", isEqualTo: barCode)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox();
                            } else {
                              if (snapshot.data.documents.length > 0) {
                                SwapModel objSwapModel =
                                    SwapModel.parseSnapshot(
                                        snapshot.data.documents[0]);
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
                  },
                )
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(150)),
                            border: Border.all(
                              color: Colors.black87,
                              width: 4.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: objSwappProfile.photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
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
                      objSwappProfile.firstName +
                          " " +
                          objSwappProfile.lastName,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 36.0,
                        fontFamily: 'Helvetica-Regular',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
                      child: RaisedButton(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text("View Profile",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Gotham-Light',
                                fontWeight: FontWeight.bold)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        textColor: Colors.white,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
                      child: RaisedButton(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          "Dismiss",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Gotham-Light',
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        hoverElevation: 0.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 20,
                    ),
                  ],
                ),
        ),
        floatingActionButton: isSearch
            ? null
            : SpeedDial(
                // both default to 16
                marginRight: 18,
                marginBottom: 20,
                // animatedIcon: AnimatedIcons.add_event,
                animatedIconTheme: IconThemeData(size: 22.0),
                // this is ignored if animatedIcon is non null
                child: Icon(Icons.share),
                // If true user is forced to close dial manually
                // by tapping main button and overlay is not rendered.
                closeManually: false,
                curve: Curves.easeInOutExpo,
                overlayColor: Colors.white,
                overlayOpacity: 0.8,
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
                      child: Icon(Icons.mic_outlined),
                      backgroundColor: Colors.lightBlue,
                      elevation: 8,
                      label: 'Add Siri Shortcut',
                      labelBackgroundColor: Colors.lightBlue,
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      onTap: () => launchSiriShortcut()),
                  SpeedDialChild(
                    child: Icon(Icons.account_balance_wallet_rounded),
                    backgroundColor: Colors.purple,
                    elevation: 8,
                    label: 'Export QR to Photos',
                    labelBackgroundColor: Colors.purple,
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    onTap: () => exportQRcode(),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.link),
                    backgroundColor: Colors.orange,
                    elevation: 8,
                    label: 'Share Private Link',
                    labelBackgroundColor: Colors.orange,
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    onTap: () => shareUserLink(
                      globals.objProfile.userId,
                      globals.objProfile.token,
                    ),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.qr_code_scanner_rounded),
                    backgroundColor: Colors.pink,
                    elevation: 8,
                    label: 'Scan QR Code',
                    labelBackgroundColor: Colors.pink,
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    onTap: () => scanQrCode(),
                  ),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
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
                Expanded(
                  child: SizedBox(
                    width: 30,
                  ),
                ),
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
                  Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child:
                  RepaintBoundary(
                    key: globalKey,
                    child: Card(
                      elevation: 7,
                      shadowColor: Colors.black,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: dynamicLink == null
                            ? Container()
                            : ClipRRect(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    QrImage(
                                      data: dynamicLink ??
                                          context
                                              .read<AuthProvider>()
                                              .firebaseUser
                                              .uid,
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      version: QrVersions.auto,
                                      gapless: true,
                                      // embeddedImage: CachedNetworkImageProvider(
                                      //   globals.objProfile?.photoUrl ?? "",
                                      // ),
                                      // embeddedImageStyle: QrEmbeddedImageStyle(
                                      //   size: Size.square(65),
                                      // ),
                                      size: 325.0,
                                    ),
                                    Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),

                                        child: CachedNetworkImage(
                                          imageUrl:
                                              globals.objProfile?.photoUrl ??
                                                  "",
                                          width: 66,
                                          height: 66,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  )),
                  SizedBox(height: 20),
                  Container(
                    width: 250,
                    child: Center(
                      child: Text(
                        globals.objProfile.firstName +
                            " " +
                            globals.objProfile.lastName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Gotham-Medium',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        " " + globals.objProfile.userName + " ",
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
                    height: 30,
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
      objSwappProfile =
          await ApiProvider().getProfileDetail(objSwapModel.userId);
    } else {
      objSwappProfile =
          await ApiProvider().getProfileDetail(objSwapModel.swapuserId);
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

  launchSiriShortcut() async {
    var url =
        'https://www.icloud.com/shortcuts/3ba77293fc6a4540b0dfae8e2ee8168f';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Siri Shortcut';
    }
  }

  shareUserLink(userId, token) async {
    Share.text(
      'Check out my link',
      'This private link has all my contact info and socials: $dynamicLink',
      // +
      //     globals.objProfile.token +
      //     "/" +
      //     globals.objProfile.userId,
      'text/plain',
    );
    // Share.share(
    // 'Check out my link https://dappyweb.web.app/' + token + "/" + userId + " !",
    // subject: 'This private link has all my contact info and socials :)',
    // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size );
  }

  Future<String> getDynamicLink() async {
    final userId = (await FirebaseAuth.instance.currentUser()).uid;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://dappy.page.link',
      link: Uri.parse('https://dappy.me/$userId'),
      androidParameters: AndroidParameters(
        packageName: 'com.gitterhive.swapTech',
        fallbackUrl: Uri.parse("https://dappy.me/$userId"),
      ),
      iosParameters: IosParameters(
        bundleId: "com.gitterhive.swaptact",
        appStoreId: "1526658458",
        fallbackUrl: Uri.parse("https://dappy.me/$userId"),
      ),
    );
    final link = await parameters.buildShortLink();
    parametersLink = parameters.link.toString();
    print(link.shortUrl.toString());
    Logger.debug("HERE IS THE DYNAMIC LINK", link.shortUrl.toString());
    WidgetKit.reloadAllTimelines();
    final data = FlutterWidgetData(link.shortUrl.toString());
    WidgetKit.setItem('widgetData', jsonEncode(data), 'group.com.dappy');
    print( "Link is set to Widget!!!!");
    return link.shortUrl.toString();
  }

  exportQRcode() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.file(dynamicLink, 'MYQRCODE.png', pngBytes, 'image/png');
    } catch (e) {
      print(e.toString());
    }
  }

  addToContacts(userID) async {
    final obj = await ApiProvider().getProfileDetail(userID);
    print("saving !");
    var newContact = Contact(
      //  displayName: widget.userProfile.firstName,
      givenName: obj.firstName,
      familyName: obj.lastName,
    );
    newContact.emails = [Item(label: "home", value: obj.email)];
    newContact.company = "Dappy.io";
    Uint8List byteImage = await networkImageToByte(obj.photoUrl);
    newContact.avatar = byteImage;
    newContact.phones = [Item(label: "mobile", value: obj.phone)];
    await ContactsService.addContact(newContact);
  }

  Future scanQrCode({String dynamicLinkUserId}) async {
    setState(() {
      _isLoding = true;
    });
    // Get Location Address

    try {
      ScanResult barcode;
      if (dynamicLinkUserId == null) {
        barcode = await BarcodeScanner.scan();
      } else {
        barcode = ScanResult(rawContent: dynamicLinkUserId);
        // barcode?.rawContent = dynamicLinkUserId;
      }

      print(barcode.rawContent);

      if (barcode.rawContent != null && barcode.rawContent != "") {
        setState(() {
          barCode = barcode.rawContent;
        });

        bool permission = await checkPermission();

        if (permission) {
          _locationData = await location.getLocation();
          final coordinates =
              new Coordinates(_locationData.latitude, _locationData.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          swapModel.locationAddreess = "@ " + addresses.first.addressLine;
        } else {
          await checkPermission();
        }
        final code = dynamicLinkUserId ?? parametersLink.split("/").last;
        print("HERE IS THE CODE $code");

        swapModel.userId = globals.objProfile.userId;
        swapModel.swapuserId = dynamicLinkUserId ?? code;
        print("SWAP USER PROFILE");
        await ApiProvider().swapUserProfile(swapModel);
        addToContacts(swapModel.swapuserId);
        await Future.delayed(Duration(seconds: 1));
        Logger.debug("SWAP STATUS", enumSwapPageStatus);
        if (enumSwapPageStatus == SwapPageStatus.Home) {
          final doc =
              await Firestore.instance.collection("Users").document(code).get();

          print(doc.data);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                userProfile: ProfileModel.parseSnapshot(doc),
              ),
            ),
          );
        }
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
// bf:a3:f0:eb:c4:75:3b:35:c0:0d:bd:d5:2b:a4:89:a0:1f:76:16:5c
// SHA-1
// 25:58:2c:77:35:a8:4a:1e:df:db:45:f5:5a:5b:c7:d8:14:09:13:b1
// SHA-1
// 2c:ce:4a:ec:71:81:eb:fa:db:7e:b6:03:79:3a:b2:89:83:e7:7c:c4
// SHA-1
// 79:64:fb:d8:43:a6:ba:06:e0:a1:9f:8f:c8:7c:22:ae:f6:84:12:fb
// SHA-1
// 3d:02:66:ce:da:78:b1:13:c6:cb:4f:de:36:f3:b1:b8:83:58:eb:7b
// SHA-1
// 75:ea 61:8b:42:e8:bc:1f:c7:a6:ef:d0:f5:6b:dd:f8:ad:a6:6c:03:50:75:4c:c5:c1:39:cb:ee:2c:88:d2:f1:

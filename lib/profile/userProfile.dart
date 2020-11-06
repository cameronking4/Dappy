import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:swapTech/constance/global.dart' as globals;
import 'package:intl/intl.dart';

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Contact Saved"),
    content: Text(
        "Check your contacts app for your newly added contact :) Click buttons on the right or below to take actions."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class UserProfilePage extends StatefulWidget {
  final ProfileModel userProfile;
  final SwapModel swapModel;

  UserProfilePage({this.userProfile, this.swapModel});
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  bool isSearch = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hasSaved = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      key: _scaffoldKey,
      drawer: DrawerPage(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.network(
              widget.userProfile.photoUrl,
              fit: BoxFit.fitHeight,
              width: size.width,
              height: size.height,
            ),
          ),
          Container(
            height: 115,
            margin: EdgeInsets.symmetric(),
            decoration: BoxDecoration(
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
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.all(0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 9,
                child: Container(
                  height: size.height * 0.79,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.grey,
                                            spreadRadius: 2)
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          widget.userProfile.photoUrl),
                                    )),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 8,
                                    ),
                                    // if user is itself (global)
                                    widget.userProfile.userId ==
                                            globals.objProfile.userId
                                        ? Container()
                                        : // ELSE ADD/VIEW CONTACTS
                                        hasSaved == true
                                            ? //if saved, open in contacts
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.lightBlue,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          5), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 12,
                                                ),
                                                child: InkWell(
                                                  onTap: () async {
                                                    await ContactsService
                                                        .openDeviceContactPicker();
                                                  },
                                                  child: Center(
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: const <
                                                              Widget>[
                                                        Icon(
                                                          Icons.contacts,
                                                          color: Colors.white,
                                                          size: 24.0,
                                                          semanticLabel:
                                                              'View in Contacts',
                                                        ),
                                                        Text(
                                                          "  View in Contacts",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ])),
                                                ),
                                              )
                                            : //if user has saved already and swap user has not updated
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          5), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 12,
                                                ),
                                                child: InkWell(
                                                  onTap: () async {
                                                    print("saving !");
                                                    var newContact = Contact(
                                                      //  displayName: widget.userProfile.firstName,
                                                      givenName: widget
                                                          .userProfile
                                                          .firstName,
                                                      familyName: widget
                                                          .userProfile.lastName,
                                                    );
                                                    newContact.emails = [
                                                      Item(
                                                          label: "home",
                                                          value: widget
                                                              .userProfile
                                                              .email)
                                                    ];
                                                    newContact.company =
                                                        "Dappy.io";
                                                    Uint8List byteImage =
                                                        await networkImageToByte(
                                                            widget.userProfile
                                                                .photoUrl);
                                                    newContact.avatar =
                                                        byteImage;
                                                    newContact.phones = [
                                                      Item(
                                                          label: "mobile",
                                                          value: widget
                                                              .userProfile
                                                              .phone)
                                                    ];
                                                    await ContactsService
                                                        .addContact(newContact);
                                                    hasSaved = true;
                                                    setState(() {
                                                      showAlertDialog(context);
                                                      hasSaved = true;
                                                    });
                                                  },
                                                  child: Center(
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                        Icon(
                                                          Icons.cloud_download,
                                                          color: Colors.white,
                                                          size: 24.0,
                                                          semanticLabel:
                                                              'Save to Contacts',
                                                        ),
                                                        Text(
                                                          "  Save to Contacts",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ])),
                                                ),
                                              ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.userProfile.firstName +
                                  " " +
                                  widget.userProfile.lastName,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "id: " + widget.userProfile.userName,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Swapped " +
                                  (widget.swapModel?.locationAddreess ?? "") +
                                  " " +
                                  readTimestamp(
                                    widget?.swapModel?.createdAt ?? 0,
                                  ),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "CALL",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _makeCall(widget.userProfile.phone);
                                      },
                                      child: Image.asset(
                                          'assets/images/telephone.png'))
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "TEXT",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _sendSMS(widget.userProfile.phone);
                                      },
                                      child: Image.asset(
                                          'assets/images/message.png'))
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "EMAIL",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _sendEmail(widget.userProfile.email);
                                      },
                                      child:
                                          Image.asset('assets/images/mail.png'))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[400],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 5.0,
                        runSpacing: 5.0,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          widget.userProfile.instagram == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchInstagram(
                                        widget.userProfile.instagram);
                                  },
                                  child: Image.asset(
                                      'assets/images/instagram.png'),
                                ),
                          widget.userProfile.snapchat == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchSnapchat(
                                        widget.userProfile.snapchat);
                                  },
                                  child:
                                      Image.asset('assets/images/snapchat.png'),
                                ),
                          widget.userProfile.facebook == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchFacebook(
                                        widget.userProfile.facebook);
                                  },
                                  child:
                                      Image.asset('assets/images/facebook.png'),
                                ),
                          widget.userProfile.linkedin == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchLinkedin(
                                        widget.userProfile.linkedin);
                                  },
                                  child:
                                      Image.asset('assets/images/linkedin.png'),
                                ),
                          widget.userProfile.venmo == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchVenmo(widget.userProfile.venmo);
                                  },
                                  child: Image.asset('assets/images/venmo.png'),
                                ),
                          widget.userProfile.tiktok == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchTiktok(widget.userProfile.tiktok);
                                  },
                                  child:
                                      Image.asset('assets/images/tiktok.png'),
                                ),
                          widget.userProfile.twitter == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchTwitter(widget.userProfile.twitter);
                                  },
                                  child:
                                      Image.asset('assets/images/twitter.png'),
                                ),
                          widget.userProfile.cashapp == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchCashapp(widget.userProfile.cashapp);
                                  },
                                  child:
                                      Image.asset('assets/images/cashapp.png'),
                                ),
                          widget.userProfile.website == ''
                              ? SizedBox(width: 0)
                              : InkWell(
                                  onTap: () {
                                    _launchWebsite(widget.userProfile.website);
                                  },
                                  child:
                                      Image.asset('assets/images/website.png'),
                                ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchInstagram(link) async {
    var url = 'https://www.instagram.com/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';
    print(diff);
    print(diff.inDays);

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays <= 1) {
        if (diff.inHours <= 24) {
          time = (diff.inHours).floor().toString() + ' hours ago';
        } else {
          time = diff.inDays.toString() + ' day ago';
        }
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    } else {
      if ((diff.inDays / 7).floor() == 1) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }
    print(time);
    return time;
  }

  _launchSnapchat(link) async {
    var url = 'https://www.snapchat.com/add/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchFacebook(link) async {
    var url = 'https://www.facebook.com/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchLinkedin(link) async {
    var url = 'https://www.linkedin.com/in/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchVenmo(link) async {
    var url = 'https://www.venmo.com/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTiktok(link) async {
    var url = 'https://www.tiktok.com/' + '@' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWebsite(link) async {
    var url = 'http://' + link;
    if (await canLaunch(url.trim())) {
      await launch(url.trim());
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchCashapp(link) async {
    var url = r"https://cash.app/$" + link;
    if (await canLaunch(url.trim())) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTwitter(link) async {
    var url = 'https://www.twitter.com/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    var number = 'tel:$phoneNumber';
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _sendEmail(String email) async {
    var mail = 'mailto:$email';
    if (await canLaunch(mail)) {
      await launch(mail);
    } else {
      throw 'Could not launch $email';
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    var number = 'sms:$phoneNumber';
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}

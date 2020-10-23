import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapTech/constance/constance.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:swapTech/constance/global.dart' as globals;

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
    content: Text("Check your contacts app for your newly added contact :) Click buttons on the right or below to take actions."),
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

  UserProfilePage({this.userProfile});
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  bool isSearch = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                          Expanded(
                            child: Container(),
                          ),
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
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  // InkWell(
                                  //   onTap: () {
                                  //     _sendSMS(widget.userProfile.phone);
                                  //   },
                                  //   child: Image.asset('assets/images/message.png'),
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       _sendEmail(widget.userProfile.email);
                                  //     },
                                  //     child: Image.asset('assets/images/mail.png'),
                                  //   ),
                                  // ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     _makeCall(widget.userProfile.phone);
                                  //   },
                                  //   child: Image.asset('assets/images/telephone.png'),
                                  // ),
                                ],
                              ),
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
                      Text(widget.userProfile.userName,
                          style: TextStyle(fontSize: 12.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                _sendSMS(widget.userProfile.phone);
                              },
                              child: Image.asset('assets/images/message.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
                              child: InkWell(
                                onTap: () {
                                  _sendEmail(widget.userProfile.email);
                                },
                                child: Image.asset('assets/images/mail.png'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _makeCall(widget.userProfile.phone);
                              },
                              child: Image.asset('assets/images/telephone.png'),
                            )

                      ],),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            widget.userProfile.instagram == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchInstagram(widget.userProfile.instagram);
                                    },
                                    child: Image.asset('assets/images/instagram.png'),
                                  ),
                            widget.userProfile.snapchat == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchSnapchat(widget.userProfile.snapchat);
                                    },
                                    child: Image.asset('assets/images/snapchat.png'),
                                  ),
                            widget.userProfile.facebook == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchFacebook(widget.userProfile.facebook);
                                    },
                                    child: Image.asset('assets/images/facebook.png'),
                                  ),
                            widget.userProfile.linkedin == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchLinkedin(widget.userProfile.linkedin);
                                    },
                                    child: Image.asset('assets/images/linkedin.png'),
                                  ),
                            widget.userProfile.venmo == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchVenmo(widget.userProfile.venmo);
                                    },
                                    child: Image.asset('assets/images/venmo.png'),
                                  ),
                            widget.userProfile.tiktok == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchTiktok(widget.userProfile.tiktok);
                                    },
                                    child: Image.asset('assets/images/tiktok.png'),
                                  ),
                            widget.userProfile.twitter == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchTwitter(widget.userProfile.twitter);
                                    },
                                    child: Image.asset('assets/images/tiktok.png'),
                                  ),
                            widget.userProfile.cashapp == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchCashapp(widget.userProfile.cashapp);
                                    },
                                    child: Image.asset('assets/images/tiktok.png'),
                                  ),
                            widget.userProfile.website == ''
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchWebsite(widget.userProfile.website);
                                    },
                                    child: Image.asset('assets/images/tiktok.png'),
                                  ),
                          ],
                        ),
                      ),
                      widget.userProfile.userId == globals.objProfile.userId ?
                      Container() :
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
                  onPressed: () async {
                     print("saving !");
                     var newContact = Contact(
                      //  displayName: widget.userProfile.firstName,
                       givenName: widget.userProfile.firstName,
                       familyName: widget.userProfile.lastName,
                     );
                     newContact.emails = [ Item(label: "home", value: widget.userProfile.email)];
                     newContact.company = "Dappy.io";
                     newContact.phones = [Item(label: "mobile", value: widget.userProfile.phone)];
                     await ContactsService.addContact(newContact);
                   
                    setState(() {
                      showAlertDialog(context);
                    });
                   
                    // await ContactsService.openExistingContact(newContact);
                 },
                  child: Text(
                    "Save to Contacts",
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

  _launchInstagram(link) async {
    var url = 'https://www.instagram.com/' + link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

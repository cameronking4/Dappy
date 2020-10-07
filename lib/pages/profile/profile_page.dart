import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {

  final DocumentSnapshot swappedUser;

  ProfilePage({
    @required this.swappedUser,
  });

  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          //1;
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Container(
                  height: 140.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  ),
                  child: Image(
                    image: AdvancedNetworkImage(
                      widget.swappedUser.data['photoUrl'],
                      useDiskCache: true,
                      cacheRule: CacheRule(maxAge: Duration(days: 7)),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Image.asset('assets/images/message.png'),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Image.asset('assets/images/mail.png'),
                        ),
                        GestureDetector(
                          child: Image.asset('assets/images/telephone.png'),
                          onTap: () {
                            _makeCall(widget.swappedUser.data['userPhone']);
                          },
                        ),
                      ],
                    ),
                  ),
              ),
            ],
          ),
          //2;
          Text(widget.swappedUser.data['!firstname'] + ' ' + widget.swappedUser.data['!lastname'], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          //3;
          Text('Swapped Last Thursday @ Perkins Library', style: TextStyle(fontSize: 14.0)),
          //4;
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _launchURL();
                  },
                  child: Image.asset('assets/images/instagram.png'),
                ),
                widget.swappedUser.data['snapchat'] == '' ? Container() : Image.asset('assets/images/snapchat.png'),
                widget.swappedUser.data['facebook'] == '' ? Container() : Image.asset('assets/images/facebook.png'),
                widget.swappedUser.data['linkedin'] == '' ? Container() : Image.asset('assets/images/linkedin.png'),
                widget.swappedUser.data['venmo'] == '' ? Container() : Image.asset('assets/images/venmo.png'),
                widget.swappedUser.data['tiktok'] == '' ? Container() : Image.asset('assets/images/tiktok.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    //Just example for video;
    const url = 'https://www.instagram.com/anton777';
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

}
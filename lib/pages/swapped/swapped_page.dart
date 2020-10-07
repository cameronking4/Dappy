import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class SwappedPage extends StatefulWidget {

  final DocumentSnapshot swappedUser;

  final VoidCallback swappedProfileDetails;

  SwappedPage({
    @required this.swappedUser,
    @required this.swappedProfileDetails,
  });

  SwappedPageState createState() => SwappedPageState();

}

class SwappedPageState extends State<SwappedPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return Container();
    return ListView(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0.0,
              child: Text('SWAPPED!', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.black87,
                  fontSize: 50.0,
                  fontFamily: 'Gotham-Medium',
                  fontWeight: FontWeight.bold
              )),
            ),
            Container(
              child: Image.asset('assets/images/swapped_arrow.png', scale: 1.1),
            ),
            Container(
              height: 160.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                border: Border.all(
                  color: Colors.black87,
                  width: 4.0,
                ),
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
            Positioned(
              bottom: 0.0,
              child: Text(widget.swappedUser.data['!firstname'], style: TextStyle(
                color: Colors.black87,
                fontSize: 36.0,
                fontFamily: 'Helvetica-Regular',
              )),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
          child: RaisedButton(
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Text("View Profile", style: TextStyle(fontSize: 18.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
            onPressed: () {
              widget.swappedProfileDetails();
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
            child: Text("Dismiss", style: TextStyle(fontSize: 18.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold, color: Colors.black54)),
            onPressed: () => null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            hoverElevation: 0.0,
          ),
        ),
      ],
    );
  }

}
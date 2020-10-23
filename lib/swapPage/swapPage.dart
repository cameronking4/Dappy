import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
// import 'package:flutter_advanced_networkimage/provider.dart';

class SwappedPage extends StatefulWidget {
  final ProfileModel swappedUser;

  SwappedPage({this.swappedUser});

  SwappedPageState createState() => SwappedPageState();
}

class SwappedPageState extends State<SwappedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0.0,
                child: Text('SWAPPED!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 50.0, fontFamily: 'Gotham-Medium', fontWeight: FontWeight.bold)),
              ),
              Container(
                child: Image.asset('assets/images/swapped_arrow.png', scale: 1.1),
              ),
              Container(
                height: 160.0,
                width: 160.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(150)),
                  border: Border.all(
                    color: Colors.black87,
                    width: 4.0,
                  ),
                ),
                child: FutureBuilder(
                  future: Future.value(widget.swappedUser),
                  builder: ((BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData == true && snapshot.connectionState == ConnectionState.done
                        ? ClipPath(
                            clipper: TopBarClipper(
                              topLeft: true,
                              topRight: true,
                              bottomLeft: true,
                              bottomRight: true,
                              radius: 150,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.swappedUser.photoUrl,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          )
                        : CircleAvatar(
                            radius: 90.0,
                            backgroundImage: AssetImage(
                              'assets/images/logo_swopp.png',
                            ),
                          );
                  }),
                ),
              ),
              FutureBuilder(
                future: Future.value(widget.swappedUser),
                builder: ((BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData == true && snapshot.connectionState == ConnectionState.done
                      ? Positioned(
                          bottom: 0.0,
                          child: Text(widget.swappedUser.firstName,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 36.0,
                                fontFamily: 'Helvetica-Regular',
                              )),
                        )
                      : Container();
                }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
            child: RaisedButton(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text("View Profile", style: TextStyle(fontSize: 18.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
              onPressed: () {},
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              textColor: Colors.white,
              color: Colors.black,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
          //   child: RaisedButton(
          //     padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
          //     child:
          //         Text("Dismiss", style: TextStyle(fontSize: 18.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold, color: Colors.black54)),
          //     onPressed: () async => await ApiProvider().dismissSwapReq(swapModel);,
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          //     hoverElevation: 0.0,
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/requestPage/requestPage.dart';
import 'package:swapTech/topBarClipper/topBarClipare.dart';
import 'package:swapTech/constance/global.dart' as globals;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearch = false;
  bool isInProgress = false;
  String searchQuery;
  List<UserPhone> lstUserPhone = [];
  List<UserPhone> lstSearchUserPhone = [];
  List<UserPhone> searchedUserDetail = [];

  TextEditingController _searchText = TextEditingController();

  @override
  void initState() {
    searchedUserDetail.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text('Find Users', style: TextStyle(color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            height: 75.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchText,
                    decoration: InputDecoration(
                      hintText: 'Search by username or phone number',
                      hintStyle: TextStyle(color: Colors.black87),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[FaIcon(FontAwesomeIcons.search, color: Colors.black87)],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    ),
                    style: TextStyle(color: Colors.black87),
                    cursorColor: Colors.black87,
                    onChanged: (value) {
                      if (value != null && value != "") {
                        userSearchName(value);
                      } else {
                        setState(() {
                          isSearch = false;
                        });
                        searchedUserDetail.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ModalProgressHUD(
              inAsyncCall: isSearch,
              progressIndicator: CupertinoActivityIndicator(),
              child: ListView.builder(
                itemCount: isSearch ? lstSearchUserPhone.length : searchedUserDetail.length,
                itemBuilder: (BuildContext context, index) {
                  var data = isSearch ? lstSearchUserPhone : searchedUserDetail;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                                            imageUrl: globals.objProfile.photoUrl,
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text(
                                          '${data[index].userName}',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RequestPage(
                                                  objUserPhone: data[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  userSearchName(String text) async {
    setState(() {
      isSearch = true;
    });
    await Future.delayed(Duration(milliseconds: 300));

    searchedUserDetail.clear();
    List<UserPhone> lstSearchedUserDetail = [];

    if (text.length < 4) return;

    if (isNumeric(_searchText.text)) {
      lstSearchedUserDetail = await ApiProvider().searchUser("searchPhone", text);
    } else {
      lstSearchedUserDetail = await ApiProvider().searchUser("searchUserName", text);
    }

    setState(() {
      searchedUserDetail = lstSearchedUserDetail;
      isSearch = false;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}

class UserPhone {
  String userName;
  String userPhone;
  String userId;

  UserPhone({
    this.userName = "",
    this.userPhone = "",
    this.userId = "",
  });

  factory UserPhone.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;
    return UserPhone(
      userName: data['userName'] ?? '',
      userPhone: data['phone'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}

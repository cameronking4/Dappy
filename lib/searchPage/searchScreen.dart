import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/drawerPage/drawerPage.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/model/swapModel.dart';
import 'package:swapTech/profile/profile.dart';
import 'package:swapTech/profile/userProfile.dart';
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

  List<SwapModel> lstSwapModel = [];
  List<String> lst = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // bool isSearch = false;
  SwapModel objSwapModel;

  bool isProgress = false;


  getData() async {
    lst = await ApiProvider().getSwapsIds();
  }
  

  @override
  void initState() {
    searchedUserDetail.clear();
    getData();
    super.initState();
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
              height: MediaQuery.of(context).padding.top + 10,
              // height: 75,
              color: Colors.black,
            ),
          appBar(),
          Expanded(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 16.0),
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
                    InkWell(  //makes whole card tappable (should refactor as function later)
                      onTap: () async {
                        var obj = await ApiProvider().getProfileDetail(data[index].userId);
            
                        if(lst.contains(data[index].userId)){ 
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                                userProfile: obj,
                              ),
                            ),
                          );
                        print("view swapped user");
                      }
                      else{ 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestPage(
                              objUserPhone: data[index],
                            ),
                          ),
                        );
                        print("locked user");
                      }
                    },
                    child: 
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
                                          child: 
                                          CircleAvatar(
                                            radius: 35.0,
                                            backgroundImage:
                                                NetworkImage(data[index].photoUrl),
                                            backgroundColor: Colors.transparent,
                                          )
                                          
                                          //  CachedNetworkImage(
                                          //   height: 60,
                                          //   width: 60,
                                          //   imageUrl: objProfileModel.data.photoUrl,
                                          //   placeholder: (context, url) => CircularProgressIndicator(),
                                          //   errorWidget: (context, url, error) => Icon(Icons.error),
                                          // ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text(
                                          '${data[index].userName}',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 13.0,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () async {
                                            var obj = await ApiProvider().getProfileDetail(data[index].userId);
                                
                                            if(lst.contains(data[index].userId)){ 
                                              Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UserProfilePage(
                                                    userProfile: obj,
                                                 ),
                                                ),
                                              );
                                            print("view swapped user");
                                          }
                                        

                                            else{ 
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RequestPage(
                                                  objUserPhone: data[index],
                                                ),
                                              ),
                                            );
                                            print("locked user");
                                            } 
                                          },
                                          child: Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 13.0,
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
                      )
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
          ))])),
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
  String firstName;
  String lastName;
  String userPhone;
  String userId;
  String photoUrl;

  UserPhone({
    this.userName = "",
    this.userPhone = "",
    this.photoUrl = "",
    this.userId = "",
    this.firstName = "",
    this.lastName = "",
  });

  factory UserPhone.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;
    return UserPhone(
      userName: data['userName'] ?? '',
      userPhone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      userId: data['userId'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
    );
  }
}

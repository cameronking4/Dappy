import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swopp2/pages/welcome/welcome_page.dart';

class SearchPage extends StatefulWidget {

  final Function toRequestPage;

  SearchPage({
    @required this.toRequestPage(AlgoliaObjectSnapshot user),
  });

  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {

  Algolia algolia = Application.algolia;

  String searchQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Text;
        Container(
          padding: EdgeInsets.only(top: 16.0, left: 16.0),
          child: Text(
            'Find Users',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        //Searchbar;
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
                  decoration: InputDecoration(
                    hintText: 'Search by Name or Phone Number',
                    hintStyle: TextStyle(color: Colors.black87),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    prefixIcon: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.search, color: Colors.black87)
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.black87),
                  cursorColor: Colors.black87,
                  onSubmitted: (String searchQuery) {
                    setState(() {
                      this.searchQuery = searchQuery;
                      search();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        //Search results;
        FutureBuilder(
          future: search(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var results = snapshot.data;
              return Expanded(
                child: ListView.builder(
                  itemCount: results.hits.length,
                  itemBuilder: ((BuildContext context, int index) {
                    return Card(
                      elevation: 12.0,
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            child: Image(
                              image: AdvancedNetworkImage(
                                results.hits[index].data['photoUrl'],
                                useDiskCache: true,
                                cacheRule: CacheRule(maxAge: Duration(days: 7)),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Container(
                            //padding: EdgeInsets.only(left: 5.0),
                            child: Text(results.hits[index].data['!firstname'] + ' ' + results.hits[index].data['!lastname'], style: TextStyle(color: Colors.blueGrey, fontSize: 14.0),),
                          ),
                          dense: false,
                          trailing: FlatButton(
                            child: Text('View Details', style: TextStyle(color: Colors.black45, fontSize: 14.0)),
                            onPressed: () {
                              widget.toRequestPage(results.hits[index]);
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ],
    );
  }

  Future search() async {
    AlgoliaQuery query = algolia.instance.index('users').search(this.searchQuery.toString());
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    return snapshot;
  }

}
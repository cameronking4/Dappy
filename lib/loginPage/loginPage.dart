import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swapTech/apiProvider/apiProvider.dart';
import 'package:swapTech/loginPage/verifyPage.dart';
import 'package:swapTech/main.dart';
import 'package:swapTech/model/profileModel.dart';
import 'package:swapTech/constance/global.dart' as globals;

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('US');

  String typedPhone = '';

  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ####', filter: {"#": RegExp(r'[0-9]')});
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoginProsses = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_typedPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoginProsses,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('assets/images/stars_login.png'),
                  Image.asset(
                    'assets/images/top_image_login.png',
                    scale: 0.9,
                  ),
                ],
              ),
              Text('Login\n', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 27.0, fontFamily: 'Gotham')),
              Text('Enter your Mobile Number to \n\n Sign In or Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: 'Gotham-Light',
                  )),
              Container(
                height: 170.0,
                margin: EdgeInsets.only(top: 45.0, left: 32.0, right: 32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                      offset: Offset(
                        15.0,
                        10.0,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          border: Border.all(color: Colors.black45)),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: _openCountryPickerDialog,
                            child: selectedCountry(_selectedDialogCountry),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              inputFormatters: [maskFormatter],
                              decoration: InputDecoration(
                                hintText: '123 456 7890',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                              ),
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              cursorColor: Colors.black45,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconTheme(
                              data: IconThemeData(color: Colors.green),
                              child: Icon(Icons.check_circle),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        toVerifyPage();
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text("Login",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Gotham-Light',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          titlePadding: EdgeInsets.all(8.0),
          searchCursorColor: Theme.of(context).primaryColor,
          searchInputDecoration: InputDecoration(hintText: 'Search...'),
          isSearchable: true,
          title: Text(
            'Select your phone code',
            style: Theme.of(context).textTheme.bodyText1.copyWith(),
          ),
          onValuePicked: (Country country) => setState(() => _selectedDialogCountry = country),
          itemBuilder: _buildDialogItem,
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              getCountryString(country.name),
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyText2.copyWith(),
            ),
          ),
          Container(
            child: Text(
              "+${country.phoneCode}",
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyText2.copyWith(),
            ),
          ),
        ],
      );

  String getCountryString(String str) {
    var newString = '';
    var isFirstdot = false;
    for (var i = 0; i < str.length; i++) {
      if (isFirstdot == false) {
        if (str[i] != ',') {
          newString = newString + str[i];
        } else {
          isFirstdot = true;
        }
      }
    }
    return newString;
  }

  Widget selectedCountry(Country country) => Center(
        child: Container(
          padding: EdgeInsets.only(left: 12.0, right: 8.0, top: 4, bottom: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0),
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(width: 8),
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.50),
                child: Text(
                  "+" + getCountryString(country.phoneCode),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(),
                ),
              ),
            ],
          ),
        ),
      );

  toVerifyPage() async {
    var fullPhoneNumber = "+" + _selectedDialogCountry.phoneCode + this.typedPhone.replaceAll(" ", "");
    try {
      setState(() {
        isLoginProsses = true;
      });
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: ((AuthCredential authCredential) {
          FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) {
            if (authResult != null && authResult.user != null) {
              navigetToProfileScreen(authResult.user);
            }
          }).catchError((e) {
            print(e);
          });
        }),
        verificationFailed: ((AuthException error) {
          print('verification failed');
          print(error.message);
        }),
        codeSent: ((String verificationId, [int forceResendingToken]) {
          setState(() {
            isLoginProsses = false;
          });
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => VerifyPage(
                phoneNumber: maskFormatter.getMaskedText(),
                dialingCode: _selectedDialogCountry.phoneCode,
                verificationId: verificationId,
              ),
            ),
          );
        }),
        codeAutoRetrievalTimeout: null,
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoginProsses = false;
      });
    }
  }

  navigetToProfileScreen(FirebaseUser user) async {
    setState(() {
      isLoginProsses = true;
    });
    if (user != null) {
      try {
        await Firestore.instance.collection('Users').document(user.uid).get().then((snapshot) async {
          if (snapshot != null) {
            var userData = ProfileModel.parseSnapshot(snapshot);
            if (userData == null) {
            } else {
              globals.objProfile = userData;
              await ApiProvider().updateUser(userData).then((then) {
                setState(() {
                  isLoginProsses = false;
                });
                if (userData.firstName == '') {
                  Navigator.pushReplacementNamed(context, Routes.PROFILE);
                } else {
                  Navigator.pushReplacementNamed(context, Routes.HOME);
                }
              });
            }
          }
        });
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoginProsses = false;
        });
      }
    }
  }

  _typedPhone() {
    this.typedPhone = _phoneController.text;
  }
}

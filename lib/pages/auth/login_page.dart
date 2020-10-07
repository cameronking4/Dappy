import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:swopp2/pages/auth/verify_page.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  Country _selectedCountry = Country.US;

  String _dialingCode = '1';

  String typedPhone = '';

  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ####', filter: { "#": RegExp(r'[0-9]') });

  final _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                    'assets/images/stars_login.png'
                ),
                Image.asset(
                  'assets/images/top_image_login.png',
                  scale: 0.9,
                ),
              ],
            ),
            Text('Login\n', textAlign: TextAlign.center, style: TextStyle(
              color: Colors.black,
              fontSize: 27.0,
              fontFamily: 'Gotham'
            )),
            Text('Enter your Mobile Number to \n\n Sign In or Sign Up', textAlign: TextAlign.center, style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontFamily: 'Gotham-Light',
            )),
            Container(
              height: 170.0,
              margin: EdgeInsets.only(top: 45.0, left: 32.0, right: 32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(16.0)
                ),
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
                    //padding: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                      //color: Colors.red,
                      borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                      ),
                      border: Border.all(color: Colors.black45)
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            //color: Colors.red,
                            padding: EdgeInsets.only(left: 10.0),
                            child: CountryPicker(
                              dense: false,
                              showFlag: true,
                              showDialingCode: true,
                              showName: false,
                              showCurrency: false,
                              showCurrencyISO: false,
                              onChanged: (Country country) {
                                setState(() {
                                  _selectedCountry = country;
                                  _dialingCode = country.dialingCode;
                                });
                              },
                              selectedCountry: _selectedCountry,
                            ),
                          )
                        ),

                        Expanded(
                          flex: 4,
                          child: Container(
                            //color: Colors.yellow,
                            child: TextField(
                              controller: _phoneController,
                              inputFormatters: [maskFormatter],
                              decoration: InputDecoration(
                                hintText: '123 456 7890',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                              ),
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black45,
                            ),
                          )
                        ),

                        Expanded(
                          flex: 1,
                          child: IconTheme(
                            data: IconThemeData(color: Colors.green),
                            child: Icon(Icons.check_circle),
                          ),
                        ),

                      ],
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 125.0, right: 125.0),
                    child: Text("Login", style: TextStyle(fontSize: 16.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
                    onPressed: () => toVerifyPage(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    textColor: Colors.white,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toVerifyPage() {
    /*Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => VerifyPage(
        phoneNumber: maskFormatter.getMaskedText(),
        dialingCode: _dialingCode,
      )),
    );*/

    // Getting phone number;
    String phoneNumber = '+' + _dialingCode + this.typedPhone;
    String fullPhoneNumber = phoneNumber.replaceAll(' ', '');

    print(fullPhoneNumber);

    this._auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: ((AuthCredential authCredential) {
          print(authCredential);
          print('verification completed');
        }),
        verificationFailed: ((AuthException error) {
          print('verification failed');
          print(error.message);
        }),
        codeSent: ((String verificationId, [int forceResendingToken]) {

          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => VerifyPage(
              phoneNumber: maskFormatter.getMaskedText(),
              dialingCode: _dialingCode,
              verificationId: verificationId,
            )),
          );

        }),
        codeAutoRetrievalTimeout: null
    );

  }

  _typedPhone() {
    this.typedPhone = _phoneController.text;
  }

}

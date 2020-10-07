import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swopp2/pages/welcome/welcome_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPage extends StatefulWidget {

  final phoneNumber;
  final dialingCode;
  final verificationId;

  VerifyPage({
    @required this.phoneNumber,
    @required this.dialingCode,
    @required this.verificationId,
  });

  VerifyPageState createState() => VerifyPageState();
}

class VerifyPageState extends State<VerifyPage> {

  String verificationCode;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                    'assets/images/top_image_verify.png',
                  )
                ],
              ),

              Text('Verify \n', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontFamily: 'Gotham-Medium',
                  fontWeight: FontWeight.bold
                ),
              ),
              AutoSizeText("Enter A 6 Digit Number That \n Was Sent To + (${widget.dialingCode}) ${widget.phoneNumber}",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontFamily: 'Gotham-Light',
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
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
                          10.0,
                          10.0,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          //color: Colors.yellow,
                          padding: EdgeInsets.only(left: 40.0, right: 40.0),
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: false,
                            animationType: AnimationType.scale,
                            shape: PinCodeFieldShape.underline,
                            animationDuration: Duration(milliseconds: 300),
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.grey,
                            activeColor: Colors.black,
                            textInputType: TextInputType.number,
                            borderWidth: 2,
                            fieldWidth: 25.0,
                            fieldHeight: 30.0,
                            onChanged: (value) {
                              setState(() {
                                this.verificationCode = value;
                              });
                            },
                          ),
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 12.0, bottom: 12.0),
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text('Verify', style: TextStyle(fontSize: 14.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
                            onPressed: () => toWelcomePage(),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                            textColor: Colors.white,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),

              /*Container(
                //height: 170.0,
                margin: EdgeInsets.only(top: 45.0, left: 32.0, right: 32.0),
                decoration: BoxDecoration(
                  //color: Colors.red,
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
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: PinCodeTextField(
                        length: 6,
                        obsecureText: false,
                        animationType: AnimationType.scale,
                        shape: PinCodeFieldShape.underline,
                        animationDuration: Duration(milliseconds: 300),
                        inactiveColor: Colors.grey,
                        selectedColor: Colors.grey,
                        activeColor: Colors.black,
                        textInputType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            this.verificationCode = value;
                          });
                        },
                      ),
                    ),
                    RaisedButton(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 125.0, right: 125.0),
                      child: Text("Verify", style: TextStyle(fontSize: 16.0, fontFamily: 'Gotham-Light', fontWeight: FontWeight.bold)),
                      onPressed: () => toWelcomePage(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      textColor: Colors.white,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),*/
              /*Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text('Re-Send Code In 0:59', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: 'Gotham-Medium',
                )),
              ),*/

            ],
          ),
        )
    );
  }

  void toWelcomePage() {

    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationId,
        smsCode: this.verificationCode
    );

    _auth.signInWithCredential(credential).then((cred) {
      print(cred.user);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => WelcomePage(phoneNumber: widget.phoneNumber, dialingCode: widget.dialingCode)),
      );
    }).catchError((error) {
      print(error);
    });

  }

}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:swapTech/providers/auth_provider.dart';
import 'package:swapTech/utils/platform_dialogue.dart';

class VerifyPage extends StatefulWidget {
  final String phoneNumber;
  final String dialingCode;

  const VerifyPage({
    Key key,
    this.phoneNumber,
    this.dialingCode,
  }) : super(key: key);

  VerifyPageState createState() => VerifyPageState();
}

class VerifyPageState extends State<VerifyPage> {
  String verificationCode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select<AuthProvider, bool>((value) => value.isLoading);
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('assets/images/stars_login.png'),
                  Image.asset(
                    'assets/images/top_image_verify.png',
                  )
                ],
              ),
              Text(
                'Verify \n',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Gotham-Medium',
                    fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                "Enter A 6 Digit Number That \n Was Sent To + (${widget.dialingCode}) ${widget.phoneNumber}",
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
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
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
                              verificationCode = value;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 32.0, right: 32.0, top: 12.0, bottom: 12.0),
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Gotham-Light',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              if ((verificationCode?.length ?? 0) < 6) {
                                showPlatformDialogue(
                                  title: "Please fill in the code",
                                );
                                return;
                              }
                              context
                                  .read<AuthProvider>()
                                  .verifyCode(verificationCode);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future toWelcomePage() async {
  //   setState(() {
  //     isLoginProsses = true;
  //   });
  //   try {
  //     AuthCredential credential = PhoneAuthProvider.getCredential(
  //         verificationId: widget.verificationId,
  //         smsCode: this.verificationCode);

  //     await _auth.signInWithCredential(credential).then((cred) async {
  //       print(cred);
  // var newUser = ProfileModel();
  // newUser.userId = cred.user.uid;
  // newUser.phone = cred.user.phoneNumber;
  // newUser.countryCode = widget.dialingCode;
  // newUser.justPhone = widget.phoneNumber.replaceAll(" ", "");
  // await ApiProvider().creatUserProfile(newUser);
  //       Navigator.pushReplacementNamed(context, Routes.WELCOME);
  //     });
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     setState(() {
  //       isLoginProsses = false;
  //     });
  //   }
  // }
}

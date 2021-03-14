import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/UI/Welcome/SignInPage.dart';
import 'package:flutterapp/UI/Welcome/SignUpPage.dart';
import 'package:flutterapp/globals.dart' as globals;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String emailaddress;

  PinCodeVerificationScreen(this.emailaddress);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  ApiManager apiManager = ApiManager();
  bool loading = false;
  SharedPreferences sharedPreferences;

  @override
  initState() {
    getdata();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        loading = true;
        int code = await apiManager.ResendEmail(widget.emailaddress);
        if (code == 200) {
          loading = false;
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Email has been resent, check your mailbox..",
              style: TextStyle(color: Colors.black),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.white,
          ));
        } else {
          loading = false;
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "An error occured..",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ));
        }
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  verifycode() async {
    setState(() {
      loading = true;
    });
    int code =
        await apiManager.ConfirmRegistration(currentText, widget.emailaddress);
    if (code == 200 || code == 201) {
      setState(() {
        loading = false;
        hasError = false;
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Account Activated !!",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
      });
      loading = true;

      String u = sharedPreferences.getString("activate");
      sharedPreferences.setString("activate", null);
      String p = sharedPreferences.getString("activatep");
      sharedPreferences.setString("activatep", null);
      await apiManager.signIn(u, p, context);
    } else {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        loading = false;
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.kBackgroundColor,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Icon(MdiIcons.emailCheckOutline,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height / 4),
              ),
              SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.emailaddress,
                            style: TextStyle(
                                color: Colors.blue.shade200,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {},
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.white,
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: globals.kBackgroundColor,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                        verifycode();
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Code isn't correct" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: globals.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () async {
                      formKey.currentState.validate();
                      setState(() {
                        loading = true;
                      });
                      try {
                        int.parse(currentText);
                      } catch (e) {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          loading = false;
                          hasError = true;
                        });
                      }
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          loading = false;
                          hasError = true;
                        });
                      } else {
                        verifycode();
                      }
                    },
                    child: loading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: globals.kPrimaryColor,
                            ),
                          )
                        : Center(
                            child: Text(
                            "VERIFY".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: globals.kPrimaryColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: FlatButton(
                    child: Text("Login", style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                          (Route<dynamic> route) => false);
                    },
                  )),
                  Flexible(
                      child: FlatButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                          (Route<dynamic> route) => false);
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

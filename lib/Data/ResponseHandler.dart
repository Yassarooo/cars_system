import 'package:flutter/material.dart';
import 'package:flutterapp/UI/Welcome/SignInPage.dart';
import '../globals.dart' as globals;

class ResponseHandler {
  void handleResponse(int code, BuildContext context,
      GlobalKey<ScaffoldState> key, bool token) {
    //ok
    if (code == 200) {
      //globals.showMessage(key, "Created Successfully", 2, Colors.green);
    }
    //created
    else if (code == 201) {
      globals.showMessage(key, "Created Successfully", 2, Colors.green);
    }
    //unauthorized
    else if (code == 401) {
      if (token) {
        Widget okButton = FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                (Route<dynamic> route) => false);
          },
        ); // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Session Expired"),
          content: Text("Your Token has expired, Please Login to continue."),
          actions: [
            okButton,
          ],
        ); // show the dialog
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        globals.showMessage(key,
            "You are not authorized to perform this action", 2, Colors.red);
      }
    }
    //not found
    else if (code == 204) {
      globals.showMessage(key, "Object Not found", 2, Colors.red);
    }
    //internal server error
    else if (code == 500) {
      globals.showMessage(key, "An error occured", 2, Colors.red);
      //globals.showMessage(key, "An error occured", 2, Colors.yellow);
    }
    //internal server error
    else {
      globals.showMessage(key, "Unknown error occured", 2, Colors.red);
    }
  }
}

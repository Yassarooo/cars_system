import 'package:flutter/material.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Data/ResponseHandler.dart';
import 'package:flutterapp/Data/SharedData.dart';
import 'package:flutterapp/Model/User.dart';
import 'package:flutterapp/UI/Welcome/SignUpPage.dart';
import '../../globals.dart' as globals;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    "https://www.googleapis.com/auth/userinfo.profile"
  ],
);

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<ScaffoldState> signinscaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  ApiManager apiManager = ApiManager();
  ResponseHandler responseHandler = ResponseHandler();
  SharedData sharedData = SharedData();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  void _validate() {
    final isvalid = _form.currentState.validate();
    if (!isvalid)
      globals.showMessage(signinscaffoldKey, "Please Enter Correct Info.", 2);
    else {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      signIn(usernameController.text, passwordController.text);
    }
  }

  bool isValidUsername(String username) {
    if (username.isEmpty) {
      return false;
    }
    if (username.contains(" ")) return false;
    return true;
  }

  signIn(String username, pass) async {
    int code = await apiManager.signIn(username, pass, context);
    if (code == 401) {
      setState(() {
        _isLoading = false;
      });
      globals.showMessage(
          signinscaffoldKey, "Incorrect username or password", 2);
    } else {
      setState(() {
        _isLoading = false;
      });
      responseHandler.handleResponse(code, context, signinscaffoldKey, false);
    }
  }

  Future<void> GoogleLogin() async {
    try {
      GoogleSignInAccount user = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      //globals.showMessage(signinscaffoldKey, "Logged in !", 3, Colors.green);
      //print("AccessToken:" + googleSignInAuthentication.accessToken);
      //print("IDToken:" + googleSignInAuthentication.idToken);
      setState(() {
        _isLoading = true;
      });
      await apiManager.GoogleLogin(
          googleSignInAuthentication.idToken, context, signinscaffoldKey);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  Future<Null> _FbLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        //globals.showMessage(signinscaffoldKey, "Logged in !", 3, Colors.green);
        setState(() {
          _isLoading = true;
        });
        apiManager.FbLogin(accessToken.token, context, signinscaffoldKey);
        break;
      case FacebookLoginStatus.cancelledByUser:
        globals.showMessage(
            signinscaffoldKey, "Canceled by user ! }", 3, Colors.yellow);
        setState(() {
          _isLoading = false;
        });
        break;
      case FacebookLoginStatus.error:
        globals.showMessage(
            signinscaffoldKey, "${result.errorMessage}", 10, Colors.red);
        setState(() {
          _isLoading = false;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: signinscaffoldKey,
      backgroundColor: globals.kBackgroundColor,
      body: Container(
        decoration: BoxDecoration(),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logincar.jpg"),
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "SIGN IN",
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ],
                          ),
                          Form(
                            key: _form,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 20, 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.alternate_email,
                                          color: globals.kPrimaryColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: TextInputType.url,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (val) =>
                                              !isValidUsername(val)
                                                  ? "incorrect username"
                                                  : null,
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                            hintText: "Enter your username",
                                            labelText: "Username",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.lock,
                                          color: globals.kPrimaryColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (val) =>
                                              val.isEmpty ? "required" : null,
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: "Enter your password",
                                            labelText: "Password",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Container(
                              //width: MediaQuery.of(context).size.width *0.5,
                              alignment: Alignment.center,
                              //height: 40.0,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              //margin: EdgeInsets.only(top: 15.0),
                              child: RaisedButton(
                                onPressed: () {
                                  _validate();
                                },
                                color: Colors.blue,
                                child: Text("Sign In",
                                    style: TextStyle(color: Colors.white)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Divider(color: Colors.white70)),
                              Text("   OR   "),
                              Expanded(child: Divider(color: Colors.white70)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SignInButton(
                            Buttons.FacebookNew,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              _FbLogin();
                            },
                          ),
                          SignInButton(
                            Buttons.Google,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              GoogleLogin();
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: new GestureDetector(
                                  onTap: () async {
                                    User u = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));

                                    usernameController.text = u.username.trim();
                                    passwordController.text = u.password;
                                    globals.showMessage(
                                        signinscaffoldKey,
                                        "Check your email for confirmation message",
                                        3,
                                        Colors.orange);
                                    //signIn(u.username, u.password);
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Need an account? ",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Sign Up",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold)),
                                      ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

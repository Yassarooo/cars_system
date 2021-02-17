import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Model/User.dart';
import 'package:flutterapp/UI/Welcome/SignInPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutterapp/globals.dart' as globals;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _signupscaffoldKey =
      GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _isLoading = false;
  User user;
  ApiManager apiManager = ApiManager();

  void _validate() {
    final isvalid = _form.currentState.validate();
    if (!isvalid)
      globals.showMessage(_signupscaffoldKey, "Please Enter Correct Info.", 2);
    else {
      _form.currentState.save();

      setState(() {
        _isLoading = true;
      });
      SignUp(
          nameController.text,
          usernameController.text,
          passwordController.text,
          emailController.text,
          phoneController.text,
          selectedGender,
          dateController.text);
    }
  }

  bool isValidEmail(String email) {
    final RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regExp.hasMatch(email);
  }

  bool isValidPhoneNumber(String input) {
    if ((input.length < 10) || (input.length > 10) || input.contains(' '))
      return false;
    else {
      try {
        double.parse(input);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (result == null) return;

    setState(() {
      dateController.text = result.toString();
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return false;
    var d = convertToDate(dob);
    return d != null && d.isBefore(DateTime.now());
  }

  DateTime convertToDate(String input) {
    try {
      var d = DateTime.parse(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  SignUp(String name, String username, String password, String email,
      String phone, String gender, String dob) async {
    DateTime datedob = DateTime.parse(dob);
    user = User(0, name, username, password, email, phone, gender, datedob);
    int code = await apiManager.signUp(user, context);
    if (code == 200) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, user);
      });
    } else if (code == 409) {
      setState(() {
        _isLoading = false;
      });
      globals.showMessage(_signupscaffoldKey, "Username Already Exist !", 2);
    } else if (code == 207) {
      setState(() {
        _isLoading = false;
      });
      globals.showMessage(
          _signupscaffoldKey, "Email address belongs to another account", 2);
    } else {
      setState(() {
        _isLoading = false;
      });
      globals.showMessage(_signupscaffoldKey, "Unknown Error", 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _signupscaffoldKey,
      body: Container(
        color: globals.kBackgroundColor,
        //decoration: BoxDecoration(),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  headerSection2(),
                  textSection(),
                  buttonSection(),
                  LogInSection(),
                ],
              ),
      ),
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: () {
          _validate();
        },
        elevation: 4,
        color: Colors.blue,
        child: Text("Sign Up", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController dateController = new TextEditingController();
  final TextEditingController repasswordController =
      new TextEditingController();
  String selectedGender = "";

  Container textSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: _form,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: nameController,
                cursorColor: Colors.white,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                style: TextStyle(color: Colors.white70),
                validator: (val) => val.isEmpty ? "Name is required" : null,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  icon: Icon(Icons.account_circle_rounded, color: Colors.blue),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        hintText: 'Enter your date of birth',
                        labelText: 'Dob',
                      ),
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      validator: (val) =>
                          isValidDob(val) ? null : "Not valid date",
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.blue),
                    tooltip: 'Choose date',
                    onPressed: (() {
                      _chooseDate(context, dateController.text);
                    }),
                  )
                ],
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: usernameController,
                validator: (val) => val.isEmpty ? "Username is required" : null,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  labelText: "Username",
                  icon: Icon(Icons.alternate_email, color: Colors.blue),
                  hintText: "",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                cursorColor: Colors.white,
                onFieldSubmitted: (value) {},
                validator: (value) =>
                    isValidEmail(value) ? null : "Enter valid email address",
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  labelText: "E-mail",
                  icon: Icon(Icons.email, color: Colors.blue),
                  hintText: "Example@gmail.com",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                controller: phoneController,
                cursorColor: Colors.white,
                validator: (value) => isValidPhoneNumber(value)
                    ? null
                    : 'Phone number must be 10 digits',
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  icon: Icon(Icons.phone_android, color: Colors.blue),
                  hintText: "0999999999",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                cursorColor: Colors.white,
                obscureText: true,
                onFieldSubmitted: (value) {},
                validator: (value) => value.length < 8
                    ? "Password should be at least 8 characters."
                    : null,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.blue),
                  labelText: "Password",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: repasswordController,
                cursorColor: Colors.white,
                obscureText: true,
                style: TextStyle(color: Colors.white70),
                validator: (val) => repasswordController.text
                            .compareTo(passwordController.text) !=
                        0
                    ? "Doesn't match password"
                    : null,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.blue),
                  labelText: "Repeat Password",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        hint: Text("Gender"),
                        items: ["Male", "Female"].map((item) {
                          return DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedGender = value;
                        },
                        validator: (value) =>
                            value == null ? "Choose gender" : null,
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

  Container headerSectionold() {
    return Container(
        margin: EdgeInsets.only(top: 40.0),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Center(
          child: Text("Register",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
        ));
  }

  Container headerSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      //margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logincar.jpg"),
          fit: BoxFit.scaleDown,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Padding headerSection2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "SIGN UP",
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
    );
  }

  Container LogInSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Center(
        child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (Route<dynamic> route) => false);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account? ",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)),
                  Text("Sign In",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)),
                ])),
      ),
    );
  }
}

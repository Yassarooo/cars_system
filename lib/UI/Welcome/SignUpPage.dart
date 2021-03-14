import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Model/User.dart';
import 'package:flutterapp/UI/Welcome/PinConfirm.dart';
import 'package:flutterapp/UI/Welcome/SignInPage.dart';
import 'package:flutterapp/globals.dart' as globals;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences sharedPreferences;

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
          nameController.text.trim(),
          usernameController.text.trim(),
          passwordController.text,
          emailController.text.trim(),
          phoneController.text,
          selectedGender,
          dateController.text);
    }
  }

  isValidEmail(String email) {
    if (oldemail == email) return true;

    available = Container(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        backgroundColor: globals.kPrimaryColor,
      ),
    );
    final RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (regExp.hasMatch(email)) {
      checkload = true;
      isAvailable(email, 1);
      oldemail = email;
      if (checkedemail)
        return true;
      else {
        emailvalidatetext = "Email address belongs to another account";
        return false;
      }
    } else {
      emailvalidatetext = "Enter valid email address";
      available = SizedBox();
      return false;
    }
  }

  isValidUsername(String username) {
    if (oldusername == username) return true;

    availableu = Container(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        backgroundColor: globals.kPrimaryColor,
      ),
    );
    final RegExp regExp =
        RegExp(r"^(?=.{5,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$");
    if (regExp.hasMatch(username)) {
      checkload = true;
      isAvailable(username, 0);
      oldusername = username;
      if (checkedusername)
        return true;
      else {
        emailvalidatetext = "Username not available";
        return false;
      }
    } else {
      emailvalidatetext = "Enter valid username";
      availableu = SizedBox();
      return false;
    }
  }

  isAvailable(String UsernameOrEmail, int i) async {
    if (i == 0)
      availableu = Container(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          backgroundColor: globals.kPrimaryColor,
        ),
      );
    else if (i == 1)
      available = Container(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          backgroundColor: globals.kPrimaryColor,
        ),
      );

    int code = await apiManager.checkUsernameOrEmail(UsernameOrEmail);
    if (code == 200 || code == 201) {
      setState(() {
        if (i == 0) {
          checkedusername = true;
          availableu = Icon(CupertinoIcons.checkmark_alt, color: Colors.green);
        } else if (i == 1) {
          checkedemail = true;
          available = Icon(CupertinoIcons.checkmark_alt, color: Colors.green);
        }
      });
      return true;
    } else {
      setState(() {
        if (i == 0) {
          checkedusername = false;
          availableu = Icon(MdiIcons.close, color: Colors.red);
        } else if (i == 1) {
          checkedemail = false;
          available = Icon(MdiIcons.close, color: Colors.red);
        }
      });
      return false;
    }
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
    var initialDate = convertToDate(initialDateString) ?? DateTime(1999);
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
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
    sharedPreferences = await SharedPreferences.getInstance();
    DateTime datedob = DateTime.parse(dob);
    user = User(
        0,
        name,
        username,
        "https://www.w3schools.com/w3images/avatar2.png",
        password,
        email,
        phone,
        gender,
        datedob);
    int code = await apiManager.signUp(user);
    if (code == 200) {
      setState(() {
        _isLoading = false;
        //Navigator.pop(context, user);
        sharedPreferences.setString("activate", emailController.text);
        sharedPreferences.setString("activatep", repasswordController.text);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PinCodeVerificationScreen(emailController.text)));
      });
    } else if (code == 409) {
      setState(() {
        _isLoading = false;
      });
      globals.showMessage(
          _signupscaffoldKey, "Username or Email address already used !", 2);
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
        child: Text("Sign Up", style: TextStyle(color: Colors.white)),
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

  String oldemail = "";
  String oldusername = "";
  String selectedGender = "";
  bool checkload = false;
  Widget available = SizedBox();
  Widget availableu = SizedBox();
  bool checkedemail = true;
  bool checkedusername = true;
  String emailvalidatetext = "Enter valid email address";
  String usernamevalidatetext = "Enter valid Username";

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
                      onTap: () {
                        _chooseDate(context, dateController.text);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(color: Colors.white70),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        hintText: 'Enter your date of birth',
                        labelText: 'Date of birth',
                      ),
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      validator: (val) =>
                          isValidDob(val) ? null : "Not valid date",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      controller: usernameController,
                      validator: (value) =>
                          isValidUsername(value) ? null : usernamevalidatetext,
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
                  ),
                  availableu,
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      cursorColor: Colors.white,
                      onFieldSubmitted: (value) {},
                      validator: (value) =>
                          isValidEmail(value) ? null : emailvalidatetext,
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
                  ),
                  available,
                ],
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

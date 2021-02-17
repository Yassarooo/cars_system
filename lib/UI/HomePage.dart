import 'dart:async';
import 'dart:convert';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/Model/Parameters.dart';
import 'package:flutterapp/UI/Car/AddCarPage.dart';
import 'package:flutterapp/UI/PlaceHolder/AvailableCars.dart';
import 'package:flutterapp/UI/PlaceHolder/HomePH.dart';
import 'package:flutterapp/UI/PlaceHolder/ParamsPH.dart';
import 'package:flutterapp/UI/Welcome/SignInPage.dart';
import 'package:flutterapp/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Timer timer;
  ApiManager apiManager = ApiManager();
  final GlobalKey<ScaffoldState> _homescaffoldKey =
      new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePHWidget(),
    AvailableCars(),
    ParamsPHWidget(),
  ];
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    getpreferences();
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              globals.user = globals.user;
            }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getpreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.kBackgroundColor,
      key: _homescaffoldKey,
      appBar: AppBar(
        backgroundColor: globals.kBackgroundColor,
        elevation: 1,
        shadowColor: Colors.white,
        title: Text("Cars System"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              globals.carsobj = null;
              globals.myheaders = null;
              globals.user = null;
              globals.paramsobj = null;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignInPage()),
                  (Route<dynamic> route) => false);
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: globals.kBackgroundColor,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.home),
            // ignore: deprecated_member_use
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.car_detailed),
            // ignore: deprecated_member_use
            title: Text('Available'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_to_photos),
            // ignore: deprecated_member_use
            title: new Text('Parameters'),
          ),
        ],
      ),
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //Init Floating Action Bubble
      floatingActionButton: FloatingActionBubble(
        herotag: "btn",
        // Menu items
        items: <Bubble>[
          Bubble(
            title: "Add Param",
            iconColor: Colors.black,
            bubbleColor: Colors.white,
            icon: Icons.playlist_add,
            titleStyle: TextStyle(fontSize: 16, color: Colors.black),
            onPress: () {
              _animationController.reverse();
              apiManager.addParam(context, _homescaffoldKey);
            },
          ),
          Bubble(
            title: "Add Car",
            iconColor: Colors.black,
            bubbleColor: Colors.white,
            icon: CupertinoIcons.car_detailed,
            titleStyle: TextStyle(fontSize: 16, color: Colors.black),
            onPress: () async {
              if (globals.paramsobj.params == null ||
                  globals.paramsobj.params.length == 0) {
                globals.showMessage(
                    _homescaffoldKey, "Please add parameters first", 2);
                return;
              } else {
                Car c = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCarPage()));
                c == null
                    ? print(
                        "klaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaaab")
                    :
                    // ignore: unnecessary_statements
                    () {
                        globals.showMessage(
                            _homescaffoldKey,
                            c.brand + " " + c.model + " has added successfully",
                            2,
                            Colors.green);
                        apiManager.fetchCars(context, _homescaffoldKey);
                      };
              }
              _animationController.reverse();
            },
          ),
          if (_currentIndex == 0)
            Bubble(
              title: "Sort",
              iconColor: Colors.black,
              bubbleColor: Colors.white,
              icon: Icons.sort,
              titleStyle: TextStyle(fontSize: 16, color: Colors.black),
              onPress: () async {
                Widget cancelButton = FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext con) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.sort),
                            Text("  Sort by"),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                globals.appliedsort = "/api/cars";
                                sharedPreferences.setString(
                                    'appliedsort', "/api/cars");
                                globals.showMessage(_homescaffoldKey,
                                    "Sorted by date", 2, Colors.blue);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.date_range),
                                  Text("    Date (default)"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                globals.appliedsort = "/api/carsbymodel";
                                sharedPreferences.setString(
                                    'appliedsort', "/api/carsbymodel");
                                globals.showMessage(_homescaffoldKey,
                                    "Sorted by name", 2, Colors.blue);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.sort_by_alpha),
                                  Text("    Name"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                globals.appliedsort = "/api/carsbyprice";
                                sharedPreferences.setString(
                                    'appliedsort', "/api/carsbyprice");
                                globals.showMessage(_homescaffoldKey,
                                    "Sorted by price", 2, Colors.blue);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(CupertinoIcons.money_dollar),
                                  Text("    Price"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                globals.appliedsort = "/api/carsbyrate";
                                sharedPreferences.setString(
                                    'appliedsort', "/api/carsbyrate");
                                globals.showMessage(_homescaffoldKey,
                                    "Sorted by rate", 2, Colors.blue);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.star),
                                  Text("    Rate"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(
                              color: Colors.white70,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: !globals.descsort,
                                        onChanged: (val) => {
                                          setState(() {
                                            globals.descsort = false;
                                            sharedPreferences.setBool(
                                                'descsort', false);
                                          }),
                                          print(globals.descsort),
                                        },
                                      ),
                                      Text("Asceding"),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: globals.descsort,
                                        onChanged: (val) => {
                                          setState(() {
                                            globals.descsort = true;
                                            sharedPreferences.setBool(
                                                'descsort', true);
                                          }),
                                          print(globals.descsort),
                                        },
                                      ),
                                      Text("Desceding"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          cancelButton,
                        ],
                      );
                    });
                  },
                );
                _animationController.reverse();
              },
            ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.white,

        // Flaoting Action button Icon
        iconData: Icons.add,
        backGroundColor: Color.fromRGBO(60, 60, 60, 1),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: Container(
            color: globals.kBackgroundColor,
            child: ListView(
              children: <Widget>[
                Container(
                  child: UserAccountsDrawerHeader(
                    accountName: Text(
                        globals.user == null ? 'null' : '${globals.user.name}'),
                    accountEmail: Text(globals.user == null
                        ? 'null'
                        : '${globals.user.email}'),
                    currentAccountPicture: InkWell(
                      onTap: () {
                        print("jazaaaaraaaaaa");
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.asset('assets/images/avatar.png',
                              width: 200.0, height: 200.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text("Change Password"),
                  trailing: Icon(Icons.lock),
                  //onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  //  builder: (BuildContext context) => AddData(),
                  //)),
                ),
                Divider(),
                ListTile(
                  title: new Text("Edit Name"),
                  trailing: new Icon(Icons.edit),
                  //onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  // builder: (BuildContext context) => ShowData(),
                  //)),
                ),
                ListTile(
                  title: new Text("Settings"),
                  trailing: new Icon(Icons.settings),
                  //onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  // builder: (BuildContext context) => ShowData(),
                  //)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

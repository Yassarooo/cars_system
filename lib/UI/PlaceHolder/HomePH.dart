import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Data/ResponseHandler.dart';
import 'package:flutterapp/Data/SharedData.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/UI/Car/BookCar.dart';
import 'package:flutterapp/UI/Car/CarWidget.dart';
import 'package:flutterapp/UI/PlaceHolder/AvailableCars.dart';
import 'package:flutterapp/UI/Welcome/WelcomePage.dart';
import 'package:flutterapp/globals.dart' as globals;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePHWidget extends StatefulWidget {
  @override
  _HomePHWidgetState createState() => _HomePHWidgetState();
}

class _HomePHWidgetState extends State<HomePHWidget> {
  ApiManager apiManager = ApiManager();
  ResponseHandler responseHandler = ResponseHandler();
  bool _isloading = true;
  Timer timer;
  final GlobalKey<ScaffoldState> homephscaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    //timer = Timer.periodic(Duration(seconds: 1), (Timer t) => apiManager.fetchCars());
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              globals.carsobj = globals.carsobj;
            }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  checkLoginStatus() async {
    SharedData sharedData = SharedData();
    String token = await sharedData.loadToken();
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()),
          (Route<dynamic> route) => false);
    } else {
      int code = await apiManager.CheckToken(token);
      responseHandler.handleResponse(code, context, homephscaffoldKey, true);
      await sharedData.loadGlobals();
      if (await apiManager.fetchCars(context, homephscaffoldKey) == true &&
          await apiManager.fetchParams(context, homephscaffoldKey) == true)
        setState(() {
          globals.carsobj = globals.carsobj;
          _isloading = false;
        });
    }
  }

  Future<void> _getData() async {
    _isloading = true;
    bool success = await apiManager.fetchCars(context, homephscaffoldKey);
    if (success) {
      setState(() {
        globals.carsobj = globals.carsobj;
        _isloading = false;
      });
      globals.showMessage(homephscaffoldKey, "Refreshed", 2, Colors.green);
    } else
      globals.showMessage(
          homephscaffoldKey, "An error occurred", 2, Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homephscaffoldKey,
      backgroundColor: globals.kBackgroundColor,
      body: !_isloading
          ? SafeArea(
              child: RefreshIndicator(
                onRefresh: _getData,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: globals.kAccentColor,
                            contentPadding: EdgeInsets.only(
                              left: 30,
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 24.0, left: 16.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: globals.kBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              buildSection(
                                  "TOP CARS",
                                  "highrate",
                                  Icon(
                                    CupertinoIcons.wand_stars,
                                    size: 27,
                                    color: Colors.yellow,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AvailableCars()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 16, right: 16, left: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: globals.kPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(24),
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Available Cars",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Long term and short term",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          height: 50,
                                          width: 50,
                                          child: Center(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: globals.kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              buildSection(
                                  "Low Price",
                                  "lowprice",
                                  Icon(MdiIcons.cash,
                                      size: 27, color: Colors.green)),
                              buildSection(
                                "Sedan",
                                "Sedan",
                                Icon(MdiIcons.car, size: 27),
                              ),
                              buildSection(
                                "SUV",
                                "SUV",
                                Icon(MdiIcons.carEstate, size: 27),
                              ),
                              buildSection(
                                "Compact",
                                "Compact",
                                Icon(MdiIcons.carHatchback, size: 27),
                              ),
                              buildSection(
                                "Super Car",
                                "Supercar",
                                Icon(MdiIcons.carSports, size: 27),
                              ),
                              buildSection(
                                "2021 Collection",
                                "2021",
                                Icon(MdiIcons.carSports, size: 27),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  List<Widget> buildDeals(String deal) {
    List<Widget> list = [];
    List<Car> filteredcars = List<Car>();
    int only3 = 0;
    if (deal == "highrate") {
      globals.carsobj.cars.sort((a, b) => b.rate.compareTo(a.rate));
      filteredcars = globals.carsobj.cars;
    } else if (deal == "lowprice") {
      globals.carsobj.cars.sort((a, b) => a.price.compareTo(b.price));
      filteredcars = globals.carsobj.cars;
    } else if (deal == "2021") {
      for (Car c in globals.carsobj.cars)
        if (c.year == 2021) filteredcars.add(c);
    } else if (deal == "SUV" ||
        deal == "Compact" ||
        deal == "Supercar" ||
        deal == "Sedan" ||
        deal == "Coupe" ||
        deal == "Sport" ||
        deal == "Limousine") {
      for (Car c in globals.carsobj.cars)
        if (c.type == deal) filteredcars.add(c);
    } else {
      filteredcars = globals.carsobj.cars;
    }
    for (var c in filteredcars) {
      if (only3 == 3) break;

      list.add(GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookCar(car: c)),
            );
          },
          child: buildCar(c, only3, context)));
      only3++;
    }
    return list;
  }

  Widget buildSection(String title, String sort, Widget icn) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  icn,
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "view all",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: globals.kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: globals.kPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 230,
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: buildDeals(sort),
          ),
        ),
      ],
    );
  }
}

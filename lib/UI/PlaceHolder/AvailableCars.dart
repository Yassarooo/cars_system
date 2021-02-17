import 'package:flutter/material.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/UI/Car/BookCar.dart';
import 'package:flutterapp/UI/Car/CarWidget.dart';
import 'package:flutterapp/globals.dart' as globals;

class AvailableCars extends StatefulWidget {
  @override
  _AvailableCarsState createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  ApiManager apiManager = ApiManager();
  bool _isloading = true;
  final GlobalKey<ScaffoldState> availablescaffoldKey =
     GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    _isloading = true;
    bool success = await apiManager.fetchCars(context, availablescaffoldKey);
    if (success) {
      setState(() {
        globals.carsobj = globals.carsobj;
        _isloading = false;
      });
      globals.showMessage(availablescaffoldKey, "Refreshed", 2, Colors.green);
    } else
      globals.showMessage(
          availablescaffoldKey, "An error occurred", 2, Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return !_isloading
        ? Scaffold(
            key: availablescaffoldKey,
            backgroundColor: globals.kBackgroundColor,
            body: RefreshIndicator(
              onRefresh: () async {
                _getData();
                setState(() {
                  globals.carsobj = globals.carsobj;
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
/*
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 33, 33, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: kBackgroundColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 28,
                    )
                ),
              ),
*/
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Available Cars (" +
                          globals.carsobj.cars.length.toString() +
                          ")",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: GridView.count(
                        physics: BouncingScrollPhysics(),
                        childAspectRatio: 1 / 1.55,
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: globals.carsobj.cars.map((item) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookCar(car: item)),
                                );
                              },
                              child: buildCar(item, null, context));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            buildFilterIcon(),
            Row(
              children: buildFilters(),
            ),
          ],
        ),
      ),
      */
          )
        : Center(child: CircularProgressIndicator());
  }

  Widget buildFilterIcon() {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: globals.kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

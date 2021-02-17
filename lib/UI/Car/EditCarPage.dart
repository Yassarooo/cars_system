import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  bool _isLoading = false;
  Car car;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddCar(String model,String brand, String price, String seats, String paramid, String level,
      double rate,String year,List<String> images) async {

    int intseats, intparamid,intyear;
    double doubleprice;
    try {
      intseats = int.parse(seats);
    } catch (e) {}
    try {
      intseats = int.parse(year);
    } catch (e) {}
    try {
      intparamid = int.parse(paramid);
      doubleprice = double.parse(price);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: new Text('Please Enter A Valid Numbers',
            style: TextStyle(color: Colors.white)),
        duration: new Duration(seconds: 10),
      ));
      print("Error parsing numbers");
      return;
    }

    car = Car(0, model,brand, "", "","", doubleprice, 0, intseats, false, intparamid, level,
        rate, 0,intyear,images);
    String jsonCar = jsonEncode(car.toJson());
    var uri = Uri.https('networkapplications.herokuapp.com', '/api/cars');

    var response =
        await http.post(uri, headers: globals.myheaders, body: jsonCar);

    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, car);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body + response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection(),
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
        onPressed: modelController.text == "" ||
                priceController.text == "" ||
                paramidController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                AddCar(modelController.text,brandController.text, priceController.text,
                    seatsController.text, paramidController.text, level, rate,yearController.text,images);
              },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Submit", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController modelController = new TextEditingController();
  final TextEditingController brandController = new TextEditingController();
  final TextEditingController priceController = new TextEditingController();
  final TextEditingController seatsController = new TextEditingController();
  final TextEditingController paramidController = new TextEditingController();
  final TextEditingController yearController = new TextEditingController();
  double rate = 3.5;
  String level = "Good";
  List<String> images;

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: modelController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.card_membership, color: Colors.white),
              hintText: "Model",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: priceController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(CupertinoIcons.money_dollar, color: Colors.white),
              hintText: "Price",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: seatsController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.event_seat, color: Colors.white),
              hintText: "Seats Number",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              if (rating < 2) level = "Bad";
              if (rating >= 2 && rating < 3) level = "Good";
              if (rating >= 3 && rating < 4) level = "Very Good";
              if (rating >= 4) level = "Excellent";
              rate = (rating *2)/100;
            },
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: paramidController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.format_indent_increase, color: Colors.white),
              hintText: "Default Param id",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
        margin: EdgeInsets.only(top: 50.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Center(
          child: Text("Add new Car",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
        ));
  }
}

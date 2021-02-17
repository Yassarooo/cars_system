library project.globals;

import 'package:flutter/material.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/Model/Parameters.dart';
import 'package:flutterapp/Model/User.dart';

int herocnt = 0;
Map<String, String> myheaders;
Cars carsobj = Cars();
Params paramsobj = Params();
String appliedsort = "/api/cars";
String host = "networkapplications.herokuapp.com";
bool descsort = false;
User user;
String token;
const kBackgroundColor = Colors.black; //(0xFFFFFFF);
const kAccentColor = Color.fromRGBO(33, 33, 33, 1); //(0xFFFFBD73);
const kPrimaryColor = Colors.blue; //(0xFFFFBD73);
const kSecondaryColor = Colors.yellow; //(0xFFFFBD73);

showMessage(GlobalKey<ScaffoldState> scaffoldkey, String message, int duration,
    [MaterialColor color = Colors.red]) {
  scaffoldkey.currentState.showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text(message, style: TextStyle(color: Colors.white)),
    duration: Duration(seconds: duration),
  ));
}
showMessage2(ScaffoldState scaffoldkey, String message,
    [MaterialColor color = Colors.red]) {
  scaffoldkey.showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text(message, style: TextStyle(color: Colors.white)),
    duration: Duration(seconds: 2),
  ));
}

Color setColorfromRate(double rate) {
  if (rate < 0.4)
    return Colors.red;
  else if (rate >= 0.4 && rate < 0.6)
    return Colors.yellow;
  else if (rate >= 0.6 && rate < 0.8)
    return Colors.lightGreen;
  else if (rate >= 0.8)
    return Colors.green;
  else
    return Colors.grey;
}

List<String> brands = [
  "Audi",
  "Bentley",
  "BMW",
  "Bugatti",
  "Chevrolet",
  "Citroen",
  "Ferrari",
  "Fiat",
  "Ford",
  "GMC",
  "Honda",
  "Hummer",
  "Hyundai",
  "Infinity",
  "Jaguar",
  "Jeep",
  "Kia",
  "Lada",
  "Lamborghini",
  "Land Rover",
  "Lexus",
  "Maserati",
  "Mazda",
  "Mercedes",
  "Mitsubishi",
  "Nissan",
  "Opel",
  "Peageot",
  "Subaru",
  "Suzuki",
  "Tesla",
  "Toyota",
  "Volkswagen",
  "Volvo",
];

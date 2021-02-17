import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data/ResponseHandler.dart';
import 'package:flutterapp/Data/SharedData.dart';
import 'package:flutterapp/Model/Parameters.dart';
import 'package:flutterapp/Model/User.dart';
import 'package:flutterapp/UI/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapp/Model/Car.dart';
import '../globals.dart' as globals;

class ApiManager {
  ResponseHandler responseHandler = ResponseHandler();
  SharedData sharedData = SharedData();

  Future<bool> fetchCars(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldkey) async {
    var uri = Uri.https(globals.host, globals.appliedsort);
    var response = await http.get(uri, headers: globals.myheaders);
    var jsonResponse;

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      globals.carsobj = Cars.fromJson(jsonResponse);
      if (globals.descsort)
        globals.carsobj.cars = globals.carsobj.cars.reversed.toList();
      return true;
    } else {
      await this.CheckToken(globals.token);
      //globals.showMessage(scaffoldkey, "Unknown error occured", 2, Colors.red);
      responseHandler.handleResponse(
          response.statusCode, context, scaffoldkey, false);
      //throw HttpException('Failed to load cars');
    }
  }

  Future<bool> addCar(Car car) async {
    String jsonCar = jsonEncode(car.toJson());
    var uri = Uri.https('networkapplications.herokuapp.com', '/api/cars');
    var response =
        await http.post(uri, headers: globals.myheaders, body: jsonCar);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteCar(
      BuildContext context, Car car, GlobalKey<ScaffoldState> key) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.2,
      ),
      onPressed: () async {
        Navigator.pop(context);
        AlertDialog alert2 = AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Deleting..."),
          content: LinearProgressIndicator(),
        ); // show the dialog
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext con) {
            return alert2;
          },
        );

        var uri = Uri.https(
            'networkapplications.herokuapp.com', '/api/cars/${car.id}');
        var response = await http.delete(uri, headers: globals.myheaders);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 500) {
          await fetchCars(context, key);
          Navigator.pop(context);
          globals.showMessage(
              key, "${car.model} Deleted Successfully", 2, Colors.green);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false);
          return true;
        } else {
          Navigator.pop(context);
          globals.showMessage(
              key, "Failed to Delete ${car.model}", 2, Colors.red);
          // If that call was not successful, throw an error.
          throw Exception('Failed to Delete Car ${car.id}' +
              response.statusCode.toString());
        }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Delete Car ?"),
      content: Text("${car.brand + " " + car.model} will be deleted."),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext con) {
        return alert;
      },
    );
    return false;
  }

  Future<bool> fetchParams(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldkey) async {
    var uri = Uri.https(globals.host, '/api/params');
    var response = await http.get(uri, headers: globals.myheaders);
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      globals.paramsobj = Params.fromJson(jsonResponse);
      return true;
    } else {
      responseHandler.handleResponse(
          response.statusCode, context, scaffoldkey, false);
      //throw Exception('Failed to load Params');
    }
  }

  Future<bool> addParam(BuildContext con, GlobalKey<ScaffoldState> key) async {
    final TextEditingController nameController = new TextEditingController();
    final TextEditingController seatsController = new TextEditingController();
    final TextEditingController percentController = new TextEditingController();
    Parameters param;
    ApiManager apiManager = ApiManager();

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(con);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Add",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.2,
      ),
      onPressed: () async {
        Navigator.pop(con);
        AlertDialog alert2 = AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Adding..."),
            content: LinearProgressIndicator(),
            actions: [
              cancelButton,
            ]); // show the dialog

        if (nameController.text != "" ||
            seatsController.text != "" ||
            percentController.text != "") {
          showDialog(
            barrierDismissible: false,
            context: con,
            builder: (BuildContext con) {
              return alert2;
            },
          );

          param = Parameters(0, int.parse(seatsController.text),
              nameController.text, double.parse(percentController.text));
          String jsonParam = jsonEncode(param.toJson());
          var uri =
              Uri.https('networkapplications.herokuapp.com', '/api/params');
          var response =
              await http.post(uri, headers: globals.myheaders, body: jsonParam);

          if (response.statusCode == 201) {
            Navigator.pop(con);
            globals.showMessage(key, "Added Successfully", 2, Colors.green);
          } else {
            Navigator.pop(con);
            responseHandler.handleResponse(
                response.statusCode, con, key, false);
            // If that call was not successful, throw an error.
            throw Exception(
                'Failed to Add Param' + response.statusCode.toString());
          }
        } else {
          globals.showMessage(key, "You cannot add empty fields", 2);
        }
      },
    ); // set up the AlertDialog

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Enter Param Details"),
      content: ListView(shrinkWrap: true, children: <Widget>[
        TextField(
          keyboardType: TextInputType.name,
          onChanged: (value) {},
          controller: nameController,
          decoration: InputDecoration(hintText: "Name"),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {},
          controller: seatsController,
          decoration: InputDecoration(hintText: "Default Seats Number"),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {},
          controller: percentController,
          decoration: InputDecoration(hintText: "Win Percentage"),
        ),
      ]),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      barrierDismissible: false,
      context: con,
      builder: (BuildContext con) {
        return alert;
      },
    );
  }

  Future<bool> deleteParam(
      int id, BuildContext con, GlobalKey<ScaffoldState> key) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(con);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.2,
      ),
      onPressed: () async {
        Navigator.pop(con);
        AlertDialog alert2 = AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Deleting..."),
          content: LinearProgressIndicator(),
        ); // show the dialog
        showDialog(
          barrierDismissible: false,
          context: con,
          builder: (BuildContext con) {
            return alert2;
          },
        );

        var uri =
            Uri.https('networkapplications.herokuapp.com', '/api/params/$id');
        var response = await http.delete(uri, headers: globals.myheaders);
        if (response.statusCode == 200) {
          await this.fetchParams(con, key);
          globals.showMessage(
              key, "Param ${id} deleted successfully", 2, Colors.green);
          Navigator.pop(con);
          return true;
        } else {
          responseHandler.handleResponse(response.statusCode, con, key, false);
          Navigator.pop(con);
          // If that call was not successful, throw an error.
          throw Exception(
              'Failed to Delete Param $id' + response.statusCode.toString());
        }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Delete Param ?"),
      content:
          Text("\n \"it can only be deleted if there are no cars using it\""),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      barrierDismissible: false,
      context: con,
      builder: (BuildContext con) {
        return alert;
      },
    );
  }

  Future<bool> editParam(
      int id, int index, BuildContext con, GlobalKey<ScaffoldState> key) async {
    final TextEditingController nameController = new TextEditingController();
    final TextEditingController seatsController = new TextEditingController();
    final TextEditingController percentController = new TextEditingController();
    nameController.text = globals.paramsobj.params[index].name;
    seatsController.text = globals.paramsobj.params[index].seats.toString();
    percentController.text = globals.paramsobj.params[index].percent.toString();
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(con);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Submit",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.2,
      ),
      onPressed: () async {
        Navigator.pop(con);
        AlertDialog alert2 = AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Please Wait..."),
          content: LinearProgressIndicator(),
        ); // show the dialog

        if (nameController.text != "" ||
            seatsController.text != "" ||
            percentController.text != "") {
          showDialog(
            barrierDismissible: false,
            context: con,
            builder: (BuildContext con) {
              return alert2;
            },
          );

          Parameters param = Parameters(
              globals.paramsobj.params[index].id,
              int.parse(seatsController.text),
              nameController.text,
              double.parse(percentController.text));
          String jsonParam = jsonEncode(param.toJson());
          print(jsonParam);
          var uri =
              Uri.https('networkapplications.herokuapp.com', '/api/params');
          var response =
              await http.put(uri, headers: globals.myheaders, body: jsonParam);

          if (response.statusCode == 200) {
            Navigator.pop(con);
            globals.showMessage(
                key, "Param $id edited Successfully", 2, Colors.green);
            return true;
          } else {
            responseHandler.handleResponse(
                response.statusCode, con, key, false);
            Navigator.pop(con);
            // If that call was not successful, throw an error.
            throw Exception(
                'Failed to Edit Param' + response.statusCode.toString());
          }
        }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Edit Parameters \"$id\" "),
      content: ListView(shrinkWrap: true, children: <Widget>[
        TextField(
          keyboardType: TextInputType.name,
          onChanged: (value) {},
          controller: nameController,
          decoration: InputDecoration(hintText: "Name"),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {},
          controller: seatsController,
          decoration: InputDecoration(hintText: "Default Seats Number"),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {},
          controller: percentController,
          decoration: InputDecoration(hintText: "Win Percentage"),
        ),
      ]),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      barrierDismissible: false,
      context: con,
      builder: (BuildContext con) {
        return alert;
      },
    );
  }

  Future<int> signIn(String username, pass, BuildContext context) async {
    Map<String, String> Params = {
      'username': username,
      'password': pass,
    };
    var uri = Uri.https(globals.host, '/authenticate', Params);
    var jsonResponse;
    var response = await http.post(uri);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      await sharedData.saveUser(jsonResponse);

      String token = jsonResponse['token'];
      await sharedData.saveToken(token);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }
    return response.statusCode;
  }

  Future<int> signUp(User user, BuildContext context) async {
    String jsonUser = jsonEncode(user);
    print(jsonUser);
    var uri = Uri.https('networkapplications.herokuapp.com', '/register');
    Map<String, String> myheaders = {
      'content-type': 'application/json',
    };
    var response = await http.post(uri, headers: myheaders, body: jsonUser);

    return response.statusCode;
  }

  // ignore: non_constant_identifier_names
  Future<int> CheckToken(String token) async {
    // ignore: non_constant_identifier_names
    Map<String, String> Params = {
      'token': token,
    };
    var uri = Uri.https(globals.host, '/checktoken', Params);
    var response = await http.post(uri);

    return response.statusCode;
  }

  Future<bool> uploadImage(File filename, Car c) async {
    String jsonCar = jsonEncode(c.toJson());
    print(jsonCar);
    var uri = Uri.https(globals.host, '/uploadCarimage');
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', filename.path));
    Map<String, String> myheaders2 = {'id': c.id.toString()};
    myheaders2.addAll(globals.myheaders);
    print(myheaders2);
    request.headers.addAll(myheaders2);
    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<String> uploadImages(List<File> files, Car c) async {
    String jsonCar = jsonEncode(c.toJson());
    print(jsonCar);
    var uri = Uri.https(globals.host, '/uploadCarimages');
    var request = http.MultipartRequest('POST', uri);
    for (var file in files)
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
    Map<String, String> myheaders2 = {'id': c.id.toString()};
    myheaders2.addAll(globals.myheaders);
    print(myheaders2);
    request.headers.addAll(myheaders2);
    var res = await request.send();
    print(res.statusCode);
    return res.reasonPhrase;
  }
}

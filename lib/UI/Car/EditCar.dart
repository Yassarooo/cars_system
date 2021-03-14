import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/Model/Specs.dart';
import 'package:flutterapp/UI/Car/BrandListPage.dart';
import '../../globals.dart' as globals;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EditCar extends StatefulWidget {
  Car car;

  EditCar({@required this.car});

  @override
  _EditCarState createState() => _EditCarState();
}

class _EditCarState extends State<EditCar> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _isLoading = false;
  ApiManager apiManager = ApiManager();
  Specs spec;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCarData();
  }

  initCarData() async {
    modelController.text = widget.car.model;
    brandController.text = widget.car.brand;
    priceController.text = widget.car.price.toString();
    yearController.text = widget.car.year.toString();
    paramid = globals.paramsobj.params
        .where((param) =>
            param.name.toLowerCase().contains(widget.car.type.toLowerCase()))
        .first
        .id;
    rate = widget.car.rate;
    level = widget.car.level;
    seatsVal = widget.car.seats.toDouble();
    priceVal = widget.car.price > 150000 ? 150000 : widget.car.price;
  }

  void _validate() {
    final isvalid = _form.currentState.validate();
    if (!isvalid)
      globals.showMessage(_scaffoldKey, "Please Enter Correct Info.", 2);
    else {
      _form.currentState.save();

      setState(() {
        _isLoading = true;
      });

      EditCar(modelController.text, brandController.text, priceController.text,
          seatsVal.toInt(), paramid, level, rate, yearController.text);
    }
  }

  isValidNumber(String val) {
    if (val.isEmpty)
      return false;
    else {
      try {
        double.parse(val);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  bool isValidYear(String year) {
    try {
      DateTime now = DateTime.now();
      int intyear = int.parse(year);
      if (intyear <= now.year && intyear > 1900)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> EditCar(String model, String brand, String price, int seats,
      int paramid, String level, double rate, String year) async {
    int intyear;
    double doubleprice;
    try {
      intyear = int.parse(year);
    } catch (e) {}
    try {
      doubleprice = double.parse(price);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      globals.showMessage(_scaffoldKey, "Unknown error", 2);
      print("Error parsing numbers");
      return;
    }

    Car car = Car(
        widget.car.id,
        widget.car.version,
        model,
        brand,
        widget.car.brandlogo,
        widget.car.buyername,
        widget.car.type,
        doubleprice,
        widget.car.sellprice,
        seats,
        widget.car.sold,
        paramid,
        level,
        rate,
        widget.car.specsid,
        intyear,
        List<String>());

    bool success = await apiManager.editCar(car);

    if (success) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, car);
      });
    } else {
      setState(() {
        _isLoading = false;
        globals.showMessage(_scaffoldKey, "An error occurred ", 2, Colors.red);
      });
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
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
      ),
      backgroundColor: globals.kBackgroundColor,
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: RaisedButton(
        onPressed: () {
          _validate();
        },
        elevation: 0.0,
        color: Colors.blue,
        child: Text("Submit", style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  int paramid = globals.paramsobj.params[0].id;
  double rate = 0.5;
  String level = "Good";
  double seatsVal = 0;
  double priceVal = 50000;
  List<String> images;

  Form textSection() {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: _form,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    controller: brandController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white70),
                    validator: (val) =>
                        val.isEmpty ? "Brand is required" : null,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    decoration: InputDecoration(
                      icon: Icon(Icons.wb_incandescent, color: Colors.blue),
                      labelText: "Brand",
                      hintText: "Enter car brand",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.blue),
                  tooltip: 'Choose brand',
                  onPressed: (() async {
                    brandController.text = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BrandsList()));
                  }),
                )
              ],
            ),
            SizedBox(height: 30.0),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: modelController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              validator: (val) => val.isEmpty ? "Model is required" : null,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              decoration: InputDecoration(
                icon: Icon(Icons.av_timer, color: Colors.blue),
                labelText: "Model",
                hintText: "Enter car model",
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
                    keyboardType: TextInputType.number,
                    controller: yearController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white70),
                    validator: (val) => val.isEmpty
                        ? "Year is required"
                        : !isValidYear(val)
                            ? "Enter valid year"
                            : null,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range, color: Colors.blue),
                      labelText: "Year",
                      hintText: "Enter car year",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            /*TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              controller: priceController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              validator: (val) =>
                  !isValidNumber(val) ? "Price isn't correct" : null,
              decoration: InputDecoration(
                icon: Icon(CupertinoIcons.money_dollar, color: Colors.blue),
                labelText: "Price",
                hintText: "Enter car price in dollar",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),*/
            Row(
              children: <Widget>[
                Icon(CupertinoIcons.money_dollar, color: Colors.blue),
                Text(
                  "     Price ",
                  style: TextStyle(
                    //fontSize: 4,
                    color: Colors.white70,
                  ),
                ),
                Slider(
                  value: priceVal,
                  min: 2000,
                  max: 150000,
                  divisions: 1000,
                  label: priceVal.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      priceVal = value;
                      priceController.text = priceVal.toInt().toString();
                    });
                  },
                ),
                Container(
                  width: 60,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white70),
                    validator: (val) =>
                        !isValidNumber(val) ? "Price isn't correct" : null,
                    decoration: InputDecoration(
                      labelText: "Price",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Icon(Icons.event_seat, color: Colors.blue),
                Text(
                  "     Seats ",
                  style: TextStyle(
                    //fontSize: 4,
                    color: Colors.white70,
                  ),
                ),
                Slider(
                  value: seatsVal,
                  min: 0,
                  max: 6,
                  divisions: 3,
                  label: seatsVal.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      seatsVal = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Container(
                  child: Icon(Icons.star, color: Colors.blue),
                  //Text("Rate   ",style: TextStyle( fontSize: 20,color: Colors.white70 ),),
                ),
                SizedBox(
                  height: 10,
                  width: 35,
                ),
                RatingBar.builder(
                  glowColor: Colors.pink,
                  initialRating: (rate / 2) * 10,
                  minRating: 0.5,
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
                    rate = (rating * 2) / 10;
                  },
                ),
              ],
            ),
            SizedBox(height: 30.0),
            DropdownButtonFormField(
              value: paramid,
              dropdownColor: Colors.blue,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              items: globals.paramsobj.params
                  .map(
                    (item) => DropdownMenuItem(
                      child: Text(
                        item.name,
                      ),
                      value: item.id,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  paramid = value;
                  widget.car.type = globals.paramsobj.params
                      .where((param) => param.id == (paramid))
                      .first
                      .name;
                });
              },
              hint: Text("Default Parameters"),
              validator: (value) =>
                  value == null ? "Select default parameters" : null,
            )
          ],
        ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
              "${widget.car.brand} ${widget.car.model} ${widget.car.year.toString()}",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

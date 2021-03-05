import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/Model/Specs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../globals.dart' as globals;
import 'package:flex_color_picker/flex_color_picker.dart';

class AddSpecs extends StatefulWidget {
  Car car;

  AddSpecs({@required this.car});

  @override
  _AddSpecsState createState() => _AddSpecsState();
}

class _AddSpecsState extends State<AddSpecs> {
  Color dialogPickerColor;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _isLoading = false;
  ApiManager apiManager = ApiManager();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dialogPickerColor = Colors.white;
  }

  void _validate() {
    final isvalid = _form.currentState.validate();
    if (!isvalid)
      globals.showMessage(_scaffoldKey, "Please enter correct info.", 2);
    else {
      _form.currentState.save();

      setState(() {
        _isLoading = true;
      });
      AddSpecs(
          doorsVal,
          dialogPickerColor,
          fueltype,
          powerVal.toDouble(),
          tankVal,
          transmission,
          topspeed,
          acceleration,
          consumption,
          wheeldrive,
          shift,
          turnangle,
          turbo,
          frontstabilizer,
          rearstabilizer,
          abs);
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
      if (intyear < now.year && intyear > 1900)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> AddSpecs(
      int doors,
      Color color,
      String fueltype,
      double power,
      int tank,
      String transmission,
      int topspeed,
      double acceleration,
      double consumption,
      String drive,
      String shift,
      double turnangle,
      bool turbo,
      bool frontstabilizer,
      bool rearstabilizer,
      bool abs) async {
    String valueString = color.toString().split('(0x')[1].split(')')[0];
    Specs s = Specs(
        0,
        widget.car.id,
        doors,
        tank,
        topspeed,
        transmission,
        power,
        acceleration,
        consumption,
        turnangle,
        valueString,
        fueltype,
        drive,
        shift,
        turbo,
        frontstabilizer,
        rearstabilizer,
        abs);

    bool success = await apiManager.addSpec(s);

    if (success) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, s);
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
                physics: BouncingScrollPhysics(),
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

  TextEditingController angleController = TextEditingController();
  String fueltype = globals.fueltypes[0];
  String shift = globals.shifts[3];
  String transmission = globals.transmissions[0];
  String wheeldrive = globals.drivewheel[0];
  int doorsVal = 4;
  int powerVal = 180;
  int tankVal = 50;
  int topspeed = 220;
  double acceleration = 10;
  double consumption = 5;
  double turnangle = 5;
  bool turbo = false,
      abs = false,
      frontstabilizer = false,
      rearstabilizer = false;

  Container headerSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${widget.car.brand} ${widget.car.model} ${widget.car.year}",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Form textSection() {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: _form,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //color
              Row(
                children: <Widget>[
                  Icon(
                    Icons.color_lens,
                    color: globals.kPrimaryColor,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Color'),
                      trailing: ColorIndicator(
                        width: 44,
                        height: 44,
                        borderRadius: 4,
                        color: dialogPickerColor,
                        onSelect: () async {
                          final Color colorBeforeDialog = dialogPickerColor;
                          if (!(await colorPickerDialog())) {
                            setState(() {
                              dialogPickerColor = colorBeforeDialog;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //doors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carDoor, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Doors",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: doorsVal.toDouble(),
                    min: 2,
                    max: 8,
                    divisions: 6,
                    label: doorsVal.toString(),
                    onChanged: (value) {
                      setState(() {
                        doorsVal = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //gears
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carShiftPattern, color: Colors.blue),
                      SizedBox(width: 15),
                      Text(
                        "Gears",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 170,
                    child: DropdownButtonFormField(
                      value: shift,
                      dropdownColor: Colors.blue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: globals.shifts
                          .map(
                            (item) => DropdownMenuItem(
                              child: Text(
                                item,
                              ),
                              value: item,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          shift = value;
                        });
                      },
                      hint: Text("Gears"),
                      validator: (value) =>
                          value == null ? "Select gears" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //transmission
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carCog, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Transmission",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 170,
                    child: DropdownButtonFormField(
                      value: transmission,
                      dropdownColor: Colors.blue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: globals.transmissions
                          .map(
                            (item) => DropdownMenuItem(
                              child: Text(
                                item,
                              ),
                              value: item,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          transmission = value;
                        });
                      },
                      hint: Text("Transmission"),
                      validator: (value) =>
                          value == null ? "Select Transmission" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Divider(
                thickness: 1,
                color: Color.fromRGBO(0, 70, 120, 0.8),
                height: 5,
              ),

              //wheeldrive
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.shipWheel, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Wheel Drive",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 170,
                    child: DropdownButtonFormField(
                      value: wheeldrive,
                      dropdownColor: Colors.blue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: globals.drivewheel
                          .map(
                            (item) => DropdownMenuItem(
                              child: Text(
                                item,
                              ),
                              value: item,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          wheeldrive = value;
                        });
                      },
                      hint: Text("Wheel Drive"),
                      validator: (value) =>
                          value == null ? "Select wheel drive" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //fuel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.fuel, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Fuel",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 170,
                    child: DropdownButtonFormField(
                      value: fueltype,
                      dropdownColor: Colors.blue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: globals.fueltypes
                          .map(
                            (item) => DropdownMenuItem(
                              child: Text(
                                item,
                              ),
                              value: item,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          fueltype = value;
                        });
                      },
                      hint: Text("Fuel tank"),
                      validator: (value) =>
                          value == null ? "Select Fuel tank" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //power
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.engine, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Power",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: powerVal.toDouble(),
                    min: 100,
                    max: 1500,
                    divisions: 1000,
                    label: powerVal.toString(),
                    onChanged: (value) {
                      setState(() {
                        powerVal = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //tank
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.propaneTankOutline, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Tank",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: tankVal.toDouble(),
                    min: 30,
                    max: 75,
                    divisions: 75,
                    label: tankVal.toString(),
                    onChanged: (value) {
                      setState(() {
                        tankVal = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Divider(
                thickness: 1,
                color: Color.fromRGBO(0, 70, 120, 0.8),
                height: 5,
              ),

              //topspeed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carCruiseControl, color: Colors.blue),
                      SizedBox(width: 15),
                      Text(
                        "Top Speed",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: topspeed.toDouble(),
                    min: 100,
                    max: 450,
                    divisions: 450,
                    label: topspeed.toString(),
                    onChanged: (value) {
                      setState(() {
                        topspeed = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //acceleration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.clock, color: Colors.blue),
                      SizedBox(width: 15),
                      Text(
                        "Acceleration",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: acceleration,
                    min: 2,
                    max: 20,
                    divisions: 100,
                    label: acceleration.toString().substring(0, 3),
                    onChanged: (value) {
                      setState(() {
                        acceleration = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              //consumptions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.drop, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Consumption",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: consumption,
                    min: 2,
                    max: 10,
                    divisions: 65,
                    label: consumption.toString().substring(0, 3),
                    onChanged: (value) {
                      setState(() {
                        consumption = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),

              //turn angle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.angleAcute, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Turn Angle",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 170,
                    //child: Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      controller: angleController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white70),
                      validator: (val) => val.isEmpty
                          ? "Field is required"
                          : !isValidNumber(val)
                              ? "Enter valid number"
                              : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      decoration: InputDecoration(
                        //icon: Icon(MdiIcons.angleAcute, color: Colors.blue),
                        //labelText: "Turn Angle",
                        hintText: "Enter Turn Angle",
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    //),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Divider(
                thickness: 1,
                color: Color.fromRGBO(0, 70, 120, 0.8),
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carTurbocharger, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Turbo",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 180,
                    child: Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          turbo = value;
                        });
                      },
                      value: turbo,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carDefrostFront, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Front Stabilizer",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 180,
                    child: Checkbox(
                      value: frontstabilizer,
                      onChanged: (bool value) {
                        setState(() {
                          frontstabilizer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carShiftPattern, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Rear Stabilizer",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 180,
                    child: Checkbox(
                      value: rearstabilizer,
                      onChanged: (bool value) {
                        setState(() {
                          rearstabilizer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(MdiIcons.carBrakeAbs, color: Colors.blue),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "ABS",
                        style: TextStyle(
                          //fontSize: 4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 180,
                    child: Checkbox(
                      value: abs,
                      onChanged: (bool value) {
                        setState(() {
                          abs = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
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

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: globals.colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
}

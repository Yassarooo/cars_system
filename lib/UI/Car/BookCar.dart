import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

//import 'package:multi_image_picker/multi_image_picker.dart';
//import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class BookCar extends StatefulWidget {
  Car car;

  BookCar({@required this.car});

  @override
  _BookCarState createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  GlobalKey<ScaffoldState> _bookScaffoldKey = GlobalKey<ScaffoldState>();
  ApiManager apiManager = ApiManager();
  File _image;

  int _currentImage = 0;

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < widget.car.images.length; i++) {
      list.add(buildIndicator(i == _currentImage));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[400],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bookScaffoldKey,
      backgroundColor: globals.kBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    border: Border.all(
                                      color: Colors.grey[300],
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Colors.white,
                                    size: 28,
                                  )),
                            ),
                            //share and bookmark
                            Row(
                              children: [
                                widget.car.images.length < 3
                                    ? GestureDetector(
                                        onTap: () {
                                          getAndUpload(context);
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            border: Border.all(
                                              color: Colors.grey[300],
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add_to_photos,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool success = await apiManager.deleteCar(
                                        context, widget.car, _bookScaffoldKey);
                                    if (success) Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.car.model,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //SizedBox(height: 8,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: <Widget>[
                            Image(
                              width: 35,
                              height: 35,
                              fit: BoxFit.scaleDown,
                              image: ExtendedNetworkImageProvider(
                                widget.car.brandlogo,
                                cache: true,
                                retries: 3,
                                //cancelToken: cancellationToken,
                              ),
                            ),
                            Text(
                              " " + widget.car.brand,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(height: 8,),
                      Expanded(
                        child: Container(
                          child: widget.car.images.length != 0
                              ? PageView(
                                  physics: BouncingScrollPhysics(),
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentImage = page;
                                    });
                                  },
                                  children: widget.car.images.map((path) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 100,
                                      ),
                                      child: Hero(
                                        tag: widget.car.model +
                                            (globals.herocnt++).toString(),
                                        child: Image.network(
                                          path,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await getAndUpload(context);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Press to add image\n",
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(Icons.add_to_photos),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      widget.car.images.length > 1
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              height: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: buildPageIndicator(),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildDetailsBox("Year", widget.car.year.toString(),
                                null, context),
                            SizedBox(
                              width: 7,
                            ),
                            buildDetailsBox(
                                "Type", widget.car.type, null, context),
                            SizedBox(
                              width: 7,
                            ),
                            buildDetailsBox(
                                "Status",
                                widget.car.sold ? "Sold" : "Available",
                                widget.car.sold ? Colors.red : Colors.green,
                                context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: globals.kAccentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14, left: 16, right: 16),
                      child: Text(
                        "SPECIFICATIONS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                      ),
                      margin: EdgeInsets.only(bottom: 14),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildSpecificationCar("Color", "White"),
                          buildSpecificationCar("Gearbox", "Automatic"),
                          buildSpecificationCar("Seat", "4"),
                          buildSpecificationCar("Motor", "v10 2.0"),
                          buildSpecificationCar("Speed (0-100)", "3.2 sec"),
                          buildSpecificationCar("Top Speed", "121 mph"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: globals.kBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      "\$" + widget.car.sellprice.round().toString(),
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.car.sold ? "Sold" : "Sell this car",
                    style: TextStyle(
                      color: widget.car.sold
                          ? Colors.red
                          : globals.kBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailsBox(
      String title, String subtitle, Color sub, BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.124,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: globals.kBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
            color: Colors.white, //globals.kPrimaryColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  style: TextStyle(
                    color: globals.kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Center(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: sub,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpecificationCar(String title, String data) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: globals.kBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            data,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  getAndUpload(BuildContext context) async {
    await _getImage();
    if (_image != null) {
      AlertDialog alert = AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text("Uploading..."),
        content: LinearProgressIndicator(),
      ); // show the dialog

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext con) {
          return alert;
        },
      );

      await apiManager.uploadImage(_image, widget.car);
      bool success = await apiManager.fetchCars(context, _bookScaffoldKey);
      setState(() {
        widget.car = globals.carsobj.cars
            .firstWhere((element) => element.id == widget.car.id, orElse: () {
          return null;
        });
      });
      Navigator.pop(context);

      if (success)
        globals.showMessage(
            _bookScaffoldKey, "Image Uploaded Successfully", 2, Colors.green);
      else
        globals.showMessage(
            _bookScaffoldKey, "Error uploading image", 2, Colors.red);
    }
  }

  Future _getImage() async {
    final image = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile.path));
    setState(() {
      _image = image;
    });
  }

/*
  Future<void> getImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      for(var asset in resultList){
        var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
        var file = await File(path);
        _images.add(file);
      }
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;
  }
*/
}

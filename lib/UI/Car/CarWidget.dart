import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:extended_image/extended_image.dart';

import '../../globals.dart' as globals;

Widget buildCar(Car car, int index, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: globals.kAccentColor,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
    margin: EdgeInsets.only(
        right: index != null ? 16 : 0, left: index == 0 ? 16 : 0),
    width: MediaQuery.of(context).size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: globals.setColorfromRate(car.rate),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    car.level,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: globals.kPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    car.year.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 110,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Center(
              child: Hero(
                tag: car.model + (globals.herocnt++).toString(),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: car.images.length >= 1
                      ? ExtendedImage.network(
                          car.images[0],
                          fit: BoxFit.fitWidth,
                          cache: true,
                          border: Border.all(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          //cancelToken: cancellationToken,
                        )
                      : car.brandlogo != ""
                          ? ExtendedImage.network(
                              car.brandlogo,
                              fit: BoxFit.fitWidth,
                              cache: true,
                              border: Border.all(color: Colors.red, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              //cancelToken: cancellationToken,
                            )
                          : Image.asset(
                              "assets/images/camaro_0.png",
                              fit: BoxFit.fitWidth,
                            ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              car.brand + " ${car.model}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "\$" + car.price.toInt().toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
            height: 1,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Align(
          widthFactor: 1,
          alignment: Alignment.centerLeft,
          child: LinearPercentIndicator(
            animation: true,
            animationDuration: 1000,
            width: 120,
            lineHeight: 8.0,
            percent: car.rate,
            backgroundColor: Colors.grey,
            progressColor: globals.setColorfromRate(car.rate),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../globals.dart' as globals;

class DetailPage extends StatelessWidget {
  final Car car;

  DetailPage({Key key, this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearPercentIndicator(
          animation: true,
          backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
          percent: car.rate,
          animationDuration: 1000,
          width: MediaQuery.of(context).size.width * 0.3,
          lineHeight: 8.0,
          progressColor: car.rate < 0.4
              ? Colors.red
              : car.rate >= 0.4 && car.rate < 0.6
                  ? Colors.yellow
                  : car.rate >= 0.6 && car.rate < 0.8
                      ? Colors.lightGreen
                      : car.rate >= 0.8
                          ? Colors.green
                          : Colors.grey,
        ),
      ),
    );

    final carPrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.amber),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        // "\$20",
        "\$" + car.price.toString().trim(),
        style: TextStyle(color: Colors.amber),
      ),
    );
    final carSold = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: !car.sold ? Colors.green : Colors.red),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        !car.sold ? "Available" : "Sold",
        style: TextStyle(color: !car.sold ? Colors.green : Colors.red),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.18 /*115.0*/),
        Icon(
          CupertinoIcons.car_detailed,
          color: Colors.white,
          size: MediaQuery.of(context).size.aspectRatio * 70, //40.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.23,
          child: Divider(color: Colors.white70),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.009 /*5.0*/),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  car.model,
                  style: TextStyle(color: Colors.white, fontSize: 45.0),
                ),
              ),
            ),
          ],
        ),
        //SizedBox(height: MediaQuery.of(context).size.height * 0.046 /*30.0*/),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 0, child: levelIndicator),
            Expanded(
                flex: 2,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      car.level,
                      style: TextStyle(color: Colors.white),
                    ))),
            Column(
              children: <Widget>[
                carSold,
                SizedBox(height: 7),
                carPrice,
              ],
            )
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            //padding: EdgeInsets.fromLTRB(50, 500, 50, 0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/drive-steering-wheel.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.03,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.03,
              0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 60)),
          //.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.height * 0.01, //8.0,
          top: MediaQuery.of(context).size.height * 0.07, //45.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: globals.kBackgroundColor,
      body: Column(
        children: <Widget>[
          topContent,
        ],
      ),
    );
  }
}

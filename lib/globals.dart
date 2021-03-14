library project.globals;

import 'package:flutter/material.dart';
import 'package:flutterapp/Model/Car.dart';
import 'package:flutterapp/Model/Parameters.dart';
import 'package:flutterapp/Model/User.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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

class Brand {
  String name, picurl;

  Brand(this.name, this.picurl);
}

List<Brand> brands = [
  Brand("Acura", "https://pngimg.com/uploads/acura/acura_PNG80.png"),
  Brand("Alfa Romeo",
      "https://pngimg.com/uploads/alfa_romeo/alfa_romeo_PNG71.png"),
  Brand("Aston Martin",
      "http://pngimg.com/uploads/aston_martin/aston_martin_PNG17.png"),
  Brand("Audi",
      "https://assets.stickpng.com/images/580b585b2edbce24c47b2c18.png"),
  Brand("Bentley",
      "https://assets.stickpng.com/images/580b585b2edbce24c47b2c2c.png"),
  Brand("BMW",
      "https://www.pinclipart.com/picdir/big/361-3619725_bmw-clip-art.png"),
  Brand("Bugatti",
      "https://pngimg.com/uploads/bugatti_logo/bugatti_logo_PNG5.png"),
  Brand("Cadillac", "https://pngimg.com/uploads/cadillac/cadillac_PNG34.png"),
  Brand("Chevrolet",
      "https://pngimg.com/uploads/chevrolet/%D1%81hevrolet_PNG109.png"),
  Brand("Chrysler", "https://pngimg.com/uploads/chrysler/chrysler_PNG28.png"),
  Brand("Citroen",
      "https://upload.wikimedia.org/wikipedia/commons/0/0b/Citroen-logo-2009.png"),
  Brand("Dodge", "https://pngimg.com/uploads/dodge/dodge_PNG47.png"),
  Brand("Ferrari",
      "https://assets.stickpng.com/images/580b585b2edbce24c47b2c52.png"),
  Brand("Fiat",
      "http://www.pngall.com/wp-content/uploads/5/Fiat-Logo-Transparent.png"),
  Brand("Ford",
      "https://logos-download.com/wp-content/uploads/2016/02/Ford_logo_motor_company_transparent.png"),
  Brand("Geely", "https://www.carlogos.org/logo/Geely-logo-2014-2560x1440.png"),
  Brand("Genesis",
      "https://toppng.com/download/TT5bPfBbviPB7Q9p5VeCWX1QgaHQhy3hCHGQUyAM5tBrfqdMlrE9wlwDv1ABrzSdHNMTFGvOFTD2P5rVtv1UU6auXD4crYanrhRQrjvpWuu915YEQc8GuW5004tiXwkIoZYCv2GAbn51St7gU2EiBFL9gcPpJO4x5RLJ6Lfk7DJE94iA8OIy1qQuJ2sv0x6NjdLm0WMu/large"),
  Brand("GMC",
      "https://logodownload.org/wp-content/uploads/2019/08/gmc-logo-0.png"),
  Brand("Honda",
      "https://www.freeiconspng.com/uploads/honda-logo-transparent-background-0.jpg"),
  Brand("Hummer", "https://logodix.com/logo/91857.png"),
  Brand("Hyundai",
      "https://logos-download.com/wp-content/uploads/2016/03/Hyundai_Motor_Company_logo.png"),
  Brand("Infiniti",
      "https://www.stickpng.com/img/download/580b57fcd9996e24bc43c483/image"),
  Brand("Jaguar",
      "https://freepngimg.com/thumb/car%20logo/12-jaguar-car-logo-png-brand-image.png"),
  Brand("Jeep",
      "https://r1.hiclipart.com/path/427/594/445/9adse6qvto3ge4jqsvjqs0nb7n.png"),
  Brand("Koenigsegg",
      "https://www.stickpng.com/img/download/580b57fcd9996e24bc43c486/image"),
  Brand("Kia",
      "https://cdn.freebiesupply.com/logos/large/2x/kia-logo-png-transparent.png"),
  Brand("Lancia", "http://pngimg.com/uploads/car_logo/car_logo_PNG1650.png"),
  Brand("Lada", "https://pngimg.com/uploads/lada/lada_PNG111.png"),
  Brand("Lamborghini",
      "https://assets.stickpng.com/images/580b585b2edbce24c47b2c8c.png"),
  Brand("Land Rover",
      "https://toppng.com/download/EzQhs5hh8uPdDBA1nS7rXB1QbtzJPvajyvSTtAPpbL2QoQeyu8bOJc4xaRwaaqz7gTtz3Igkb0wQi1rr1OJnr1R9DZi8zUxmXXty55xV4WUuF5879hAfDONf14X9gDfHfGWNmiwK96t4dUh9sCkYF4T4aR2Vm6YyphWK5aApxxksLX9HjK2tg0Qg5YVCivIub5xR9ImC/large"),
  Brand("Lexus", "http://pngimg.com/uploads/lexus/lexus_PNG37.png"),
  Brand("Maserati", "https://pngimg.com/uploads/maserati/maserati_PNG73.png"),
  Brand("Mazda", "https://pngimg.com/uploads/mazda/mazda_PNG86.png"),
  Brand("Maybach",
      "https://1000logos.net/wp-content/uploads/2020/04/Maybach_logo_PNG2.png"),
  Brand("Mclaren", "https://pngimg.com/uploads/Mclaren/Mclaren_PNG49.png"),
  Brand("Mercedes",
      "https://cdn.freebiesupply.com/logos/large/2x/mercedes-benz-9-logo-png-transparent.png"),
  Brand("Mitsubishi",
      "https://logos-download.com/wp-content/uploads/2016/02/Mitsubishi_logo_standart.png"),
  Brand("Nissan",
      "https://purepng.com/public/uploads/large/purepng.com-nissan-logonissannissan-motorautomobile-manufactureryokohamanissan-logo-1701527528584gkr0t.png"),
  Brand("Opel", "https://pngimg.com/uploads/opel/opel_PNG11.png"),
  Brand("Peageot",
      "https://www.stickpng.com/img/download/584831f6cef1014c0b5e4aa6/image"),
  Brand("Porsche",
      "https://www.stickpng.com/img/download/580b585b2edbce24c47b2cac/image"),
  Brand("Renault", "https://pngimg.com/uploads/renault/renault_PNG39.png"),
  Brand("Rolls Royce",
      "https://pngimg.com/uploads/rolls_royce/rolls_royce_PNG34.png"),
  Brand("Skoda",
      "https://www.stickpng.com/img/download/580b585b2edbce24c47b2cb7/image"),
  Brand("Subaru",
      "https://assets.stickpng.com/images/580b585b2edbce24c47b2cbf.png"),
  Brand("Suzuki",
      "https://assets.stickpng.com/images/580b57fcd9996e24bc43c4a4.png"),
  Brand("Tesla", "https://www.carlogos.org/car-logos/tesla-logo-2200x2800.png"),
  Brand("Toyota",
      "https://www.vhv.rs/dpng/f/57-576848_whatsapp-logo-png-transparent-background.png"),
  Brand("Volkswagen",
      "https://assets.stickpng.com/images/580b585b2edbce24c47b2cf2.png"),
  Brand("Volvo", "https://pngimg.com/uploads/volvo/volvo_PNG64.png"),
];
List<String> fueltypes = [
  "Gasoline",
  "Diesel",
  "Battery",
];
List<String> shifts = [
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
];

List<String> transmissions = [
  "Automatic",
  "Manual",
];
List<String> drivewheel = [
  "Front",
  "Rear",
  "Four",
];

Color white = Colors.white;
Color whiteVariant = Colors.grey;
Color grey = Colors.grey[800];
Color black = Colors.black;
Color blue = Colors.blue;
Color red = Colors.red;
Color yellow = Colors.yellow;
Color amber = Colors.amber;
Color orange = Colors.orange;
Color pink = Colors.pink;
Color lightGreen = Colors.lightGreen;
Color green = Colors.green;

final Map<ColorSwatch<Object>, String> colorsNameMap =
    <ColorSwatch<Object>, String>{
  ColorTools.createPrimarySwatch(white): 'White',
  ColorTools.createPrimarySwatch(whiteVariant): 'White Variant',
  ColorTools.createAccentSwatch(grey): 'Grey',
  ColorTools.createAccentSwatch(black): 'Black',
  ColorTools.createPrimarySwatch(blue): 'Blue',
  ColorTools.createPrimarySwatch(red): 'Red',
  ColorTools.createPrimarySwatch(yellow): 'Yellow',
  ColorTools.createPrimarySwatch(amber): 'Amber',
  ColorTools.createPrimarySwatch(orange): 'Orange',
  ColorTools.createPrimarySwatch(pink): 'Pink',
  ColorTools.createPrimarySwatch(lightGreen): 'Light Green',
  ColorTools.createPrimarySwatch(green): 'Green',
};

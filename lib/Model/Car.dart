
class Car {
  String model, brand, brandlogo,type, buyername, level;
  double price, sellprice, rate;
  int id,version, paramid, specsid, seats,year;
  bool sold;
  List<String> images;

  Car(
      this.id,
      this.version,
      this.model,
      this.brand,
      this.brandlogo,
      this.buyername,
      this.type,
      this.price,
      this.sellprice,
      this.seats,
      this.sold,
      this.paramid,
      this.level,
      this.rate,
      this.specsid,
      this.year,
      this.images);

  factory Car.fromJson(dynamic json) {
    return Car(
      json['id'] as int,
      json['version'] as int,
      json['model'] as String,
      json['brand'] as String,
      json['brandlogo'] as String,
      json['buyername'] as String,
      json['type'] as String,
      json['price'] as double,
      json['sellprice'] as double,
      json['seats'] as int,
      json['sold'] as bool,
      json['paramid'] as int,
      json['level'] as String,
      json['rate'] as double,
      json['specsid'] as int,
      json['year'] as int,
      List<String>.from(json['images']),
    );
  }

  Map toJson() => {
        'id': id,
        'version': version,
        'model': model,
        'brand': brand,
        'brandlogo': brand,
        'price': price,
        'seats': seats,
        'paramid': paramid,
        'buyername': buyername,
        'sellprice': sellprice,
        'sold': sold,
        'level': level,
        'rate': rate,
        'specsid': specsid,
        'year': year.toString(),
        'images': images,
      };

  @override
  String toString() {
    return 'Car{id: $id,model: $model,brandL:$brand, buyername: $buyername, price: $price, sellprice: $sellprice, seats: $seats, sold: $sold, level: $level,rate: $rate,specsid: $specsid}';
  }
}

class Cars {
  List<Car> cars;

  Cars({
    this.cars,
  });

  factory Cars.fromJson(List<dynamic> parsedJson) {
    List<Car> cars = parsedJson.map((i) => Car.fromJson(i)).toList();

    return new Cars(
      cars: cars,
    );
  }
}

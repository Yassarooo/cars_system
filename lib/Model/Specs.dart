class Specs {
  int id, carid, doors, tank, topspeed;
  double power, acceleration, consumption, turnangle;
  String color, fueltype, drive, gears, transmission;
  bool turbo, frontstabilizer, rearstabilizer, abs;

  Specs(
      this.id,
      this.carid,
      this.doors,
      this.tank,
      this.topspeed,
      this.transmission,
      this.power,
      this.acceleration,
      this.consumption,
      this.turnangle,
      this.color,
      this.fueltype,
      this.drive,
      this.gears,
      this.turbo,
      this.frontstabilizer,
      this.rearstabilizer,
      this.abs);

  factory Specs.fromJson(dynamic json) {
    return Specs(
        json['id'] as int,
        json['carid'] as int,
        json['doors'] as int,
        json['tank'] as int,
        json['topspeed'] as int,
        json['transmission'] as String,
        json['power'] as double,
        json['acceleration'] as double,
        json['consumption'] as double,
        json['turnangle'] as double,
        json['color'] as String,
        json['fueltype'] as String,
        json['drive'] as String,
        json['gears'] as String,
        json['turbo'] as bool,
        json['frontstabilizer'] as bool,
        json['rearstabilizer'] as bool,
        json['abs'] as bool);
  }

  Map toJson() => {
        'id': id,
        'carid': carid,
        'doors': doors,
        'tank': tank,
        'topspeed': topspeed,
        'transmission': transmission,
        'power': power,
        'acceleration': acceleration,
        'consumption': consumption,
        'turnangle': turnangle,
        'color': color,
        'fueltype': fueltype,
        'drive': drive,
        'gears': gears,
        'turbo': turbo,
        'frontstabilizer': frontstabilizer,
        'rearstabilizer': rearstabilizer,
        'abs': abs,
      };

  @override
  String toString() {
    return 'Specs{id: $id,carid: $carid,doors: $doors, power: $power}';
  }

  @override
  int compareTo(other) {
    if (this.id == null || other.id == null) {
      return null;
    }

    if (this.id < other.id) {
      return 1;
    }

    if (this.id > other.id) {
      return -1;
    }

    if (this.id == other.id) {
      return 0;
    }

    return null;
  }
}

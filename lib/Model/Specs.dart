class Specs {
  int id, seats;
  String name;
  double percent;

  Specs(this.id, this.seats, this.name, this.percent);

  factory Specs.fromJson(dynamic json) {
    return Specs(json['id'] as int, json['seats'] as int,
        json['name'] as String, json['percentage'] as double);
  }

  Map toJson() => {
        'id': id,
        'seats': seats,
        'name': name,
        'percentage': percent,
      };

  @override
  String toString() {
    return 'Car{id: $id,seats: $seats,name: $name, percentage: $percent}';
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

class User {
  int id;
  String name, password, username, profilepic, gender, email, phonenumber;
  DateTime dob;

  User(this.id, this.name, this.username, this.profilepic, this.password,
      this.email, this.phonenumber, this.gender, this.dob);

  factory User.fromJson(dynamic json) {
    return User(
        json['id'] as int,
        json['name'] as String,
        json['username'] as String,
        json['profilepic'] as String,
        json['password'] as String,
        json['email'] as String,
        json['phonenumber'] as String,
        json['gender'] as String,
        DateTime.parse(json['dob']));
  }

  Map toJson() => {
        'name': name,
        'username': username,
        'password': password,
        'phonenumber': phonenumber,
        'email': email,
        'gender': gender,
        'dob': dob.toIso8601String(),
      };

  @override
  String toString() {
    return '{ ${this.name}, ${this.username},${this.email},${this.phonenumber},${this.gender} }';
  }
}

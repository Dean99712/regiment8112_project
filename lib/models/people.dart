class People {

  String name;
  String lastName;
  String phoneNumber;
  String city;
  String cls;

  People(this.name, this.lastName, this.phoneNumber, this.city, this.cls);

  factory People.fromJson(Map<String, dynamic> json) {
    return People(json['name'], json['lastName'], json['phoneNumber'], json['city'], json['cls']);
  }

  Map toJson() => {
    'name': name,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'city': city,
    'cls': cls,
  };
}


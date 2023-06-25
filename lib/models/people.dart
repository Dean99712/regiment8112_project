import 'package:cloud_firestore/cloud_firestore.dart';

class People {
  String name;
  String lastName;
  String phoneNumber;
  String city;
  String platoon;

  People(this.name, this.lastName, this.phoneNumber, this.city, this.platoon);

  factory People.fromJson(Map<String, dynamic> json) {
    return People(json['name'], json['lastName'], json['phoneNumber'],
        json['city'], json['platoon']);
  }

  People.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot['name'],
        lastName = snapshot['lastName'],
        phoneNumber = snapshot['phoneNumber'],
        city = snapshot['city'],
        platoon = snapshot['platoon'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'city': city,
      'platoon': platoon
    };
  }
}

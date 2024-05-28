import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String id;
  String name;
  String lastName;
  String phoneNumber;
  String city;
  String platoon;
  String role;

  MyUser(this.id,this.name, this.lastName, this.phoneNumber, this.city, this.platoon, this.role);

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(json['name'], json['lastName'], json['phoneNumber'],
        json['city'], json['platoon'], json['role'], json['id']);
  }

  MyUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        lastName = snapshot['lastName'],
        phoneNumber = snapshot['phoneNumber'],
        city = snapshot['city'],
        platoon = snapshot['platoon'],
        role = snapshot['role'];

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'city': city,
      'platoon': platoon,
      'role': role
    };
  }
}

enum Role {
  admin,
  user
}

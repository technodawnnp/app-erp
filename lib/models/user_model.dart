import 'dart:convert';

class User {
  int id;
  String name;
  String email;
  String image;
  String phoneNumber;
  String role;

  User({this.id, this.email, this.name, this.image, this.phoneNumber,this.role});

  String toJson() {
    Map<String, dynamic> myMap = {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'phoneNumber': phoneNumber,
      'role':role
    };

    return jsonEncode(myMap).toString();
  }

  User getUser(Map<String, dynamic> map) {
    User user = User(
        name: map['name'],
        id: map['id'],
        email: map['email'],
        image: map['image'],
        phoneNumber: map['phoneNumber'],
        role: map['role']
    );

    return user;
  }
}

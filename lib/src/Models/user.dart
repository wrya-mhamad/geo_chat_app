import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? imagePath;
  Map<String, dynamic>? location;
  DocumentReference? uid;

  UserModel({this.username, this.imagePath, this.location, this.uid});

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
      username: json['username'],
      imagePath: json['imagePath'],
      location: json['location'],
      uid: json['uid']);

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'UserModelname': username,
        'imagePath': imagePath,
        'location': location
      };
}

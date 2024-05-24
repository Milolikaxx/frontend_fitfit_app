// To parse this JSON data, do
//
//     final userEditPutRequest = userEditPutRequestFromJson(jsonString);

import 'dart:convert';

UserEditPutRequest userEditPutRequestFromJson(String str) =>
    UserEditPutRequest.fromJson(json.decode(str));

String userEditPutRequestToJson(UserEditPutRequest data) =>
    json.encode(data.toJson());

class UserEditPutRequest {
  String name;
  DateTime birthday;
  String email;
  String imageProfile;
  String googleId;

  UserEditPutRequest({
    required this.name,
    required this.birthday,
    required this.email,
    required this.imageProfile,
    required this.googleId,
  });

  factory UserEditPutRequest.fromJson(Map<String, dynamic> json) =>
      UserEditPutRequest(
        name: json["name"],
        birthday: DateTime.parse(json["Birthday"]),
        email: json["email"],
        imageProfile: json["imageProfile"],
        googleId: json["googleID"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "Birthday": birthday.toIso8601String(),
        "email": email,
        "imageProfile": imageProfile,
        "googleID": googleId,
      };
}

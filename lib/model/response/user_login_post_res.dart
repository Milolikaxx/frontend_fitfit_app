// To parse this JSON data, do
//
//     final userLoginPostResponse = userLoginPostResponseFromJson(jsonString);

import 'dart:convert';

UserLoginPostResponse userLoginPostResponseFromJson(String str) =>
    UserLoginPostResponse.fromJson(json.decode(str));

String userLoginPostResponseToJson(UserLoginPostResponse data) =>
    json.encode(data.toJson());

class UserLoginPostResponse {
  int? uid;
  String? name;
  DateTime? birthday;
  String? email;
  String? password;
  String? imageProfile;
  String? googleId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserLoginPostResponse({
    this.uid,
    this.name,
    this.birthday,
    this.email,
    this.password,
    this.imageProfile,
    this.googleId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLoginPostResponse.fromJson(Map<String, dynamic> json) =>
      UserLoginPostResponse(
        uid: json["Uid"],
        name: json["Name"],
        birthday: DateTime.parse(json["Birthday"]),
        email: json["Email"],
        password: json["Password"],
        imageProfile: json["ImageProfile"],
        googleId: json["GoogleID"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "Uid": uid,
        "Name": name,
        "Birthday": birthday?.toIso8601String(),
        "Email": email,
        "Password": password,
        "ImageProfile": imageProfile,
        "GoogleID": googleId,
        "CreatedAt": createdAt?.toIso8601String(),
        "UpdatedAt": updatedAt?.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final userRegisterPostRequest = userRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

UserRegisterPostRequest userRegisterPostRequestFromJson(String str) =>
    UserRegisterPostRequest.fromJson(json.decode(str));

String userRegisterPostRequestToJson(UserRegisterPostRequest data) =>
    json.encode(data.toJson());

class UserRegisterPostRequest {
  String name;
  DateTime birthday;
  String email;
  String password;
  dynamic imageProfile;
  dynamic googleId;

  UserRegisterPostRequest({
     required this.name,
     required this.birthday,
     required  this.email,
     required this.password,
     required this.imageProfile,
     this.googleId,
  });

  factory UserRegisterPostRequest.fromJson(Map<String, dynamic> json) =>
      UserRegisterPostRequest(
        name: json["Name"],
        birthday: DateTime.parse(json["Birthday"]),
        email: json["Email"],
        password: json["Password"],
        imageProfile: json["ImageProfile"],
        googleId: json["GoogleID"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Birthday": birthday.toIso8601String(),
        "Email": email,
        "Password": password,
        "ImageProfile": imageProfile,
        "GoogleID": googleId,
      };
}

// To parse this JSON data, do
//
//     final userLoginPostRequest = userLoginPostRequestFromJson(jsonString);

import 'dart:convert';

UserLoginPostRequest userLoginPostRequestFromJson(String str) =>
    UserLoginPostRequest.fromJson(json.decode(str));

String userLoginPostRequestToJson(UserLoginPostRequest data) =>
    json.encode(data.toJson());

class UserLoginPostRequest {
  String email;
  String password;

  UserLoginPostRequest({
    required this.email,
    required this.password,
  });

  factory UserLoginPostRequest.fromJson(Map<String, dynamic> json) =>
      UserLoginPostRequest(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

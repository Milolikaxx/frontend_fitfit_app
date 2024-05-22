// To parse this JSON data, do
//
//     final userEditPasswordPostRequest = userEditPasswordPostRequestFromJson(jsonString);

import 'dart:convert';

UserEditPasswordPostRequest userEditPasswordPostRequestFromJson(String str) =>
    UserEditPasswordPostRequest.fromJson(json.decode(str));

String userEditPasswordPostRequestToJson(UserEditPasswordPostRequest data) =>
    json.encode(data.toJson());

class UserEditPasswordPostRequest {
  String password;
  String passwordNew;

  UserEditPasswordPostRequest({
    required this.password,
    required this.passwordNew,
  });

  factory UserEditPasswordPostRequest.fromJson(Map<String, dynamic> json) =>
      UserEditPasswordPostRequest(
        password: json["Password"],
        passwordNew: json["PasswordNew"],
      );

  Map<String, dynamic> toJson() => {
        "Password": password,
        "PasswordNew": passwordNew,
      };
}

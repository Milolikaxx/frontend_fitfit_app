// To parse this JSON data, do
//
//     final userRegisterPostRequest = userRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

UserLoginGooglePostRequest userRegisterPostRequestFromJson(String str) =>
    UserLoginGooglePostRequest.fromJson(json.decode(str));

String userRegisterPostRequestToJson(UserLoginGooglePostRequest data) =>
    json.encode(data.toJson());

class UserLoginGooglePostRequest {
  String name;
  final DateTime? birthday;
  String email;
  dynamic imageProfile;
  dynamic googleId;

  UserLoginGooglePostRequest({
    required this.name,
    this.birthday,
    required this.email,
    required this.imageProfile,
    this.googleId,
  });

  factory UserLoginGooglePostRequest.fromJson(Map<String, dynamic> json) =>
      UserLoginGooglePostRequest(
        name: json["Name"],
        birthday: DateTime.parse(json["Birthday"]),
        email: json["Email"],
        imageProfile: json["ImageProfile"],
        googleId: json["GoogleID"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Birthday": birthday?.toIso8601String(),
        "Email": email,
        "ImageProfile": imageProfile,
        "GoogleID": googleId,
      };
}

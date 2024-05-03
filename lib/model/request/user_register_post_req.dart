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

  UserRegisterPostRequest({
    required this.name,
    required this.birthday,
    required this.email,
    required this.password,
  });

  factory UserRegisterPostRequest.fromJson(Map<String, dynamic> json) =>
      UserRegisterPostRequest(
        name: json["name"],
        birthday: DateTime.parse(json["birthday"]),
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "birthday": birthday.toIso8601String(),
        "email": email,
        "password": password,
      };
}

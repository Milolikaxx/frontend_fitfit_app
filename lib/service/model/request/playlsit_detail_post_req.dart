// To parse this JSON data, do
//
//     final playlsitDetailPostRequest = playlsitDetailPostRequestFromJson(jsonString);

import 'dart:convert';

PlaylsitDetailPostRequest playlsitDetailPostRequestFromJson(String str) =>
    PlaylsitDetailPostRequest.fromJson(json.decode(str));

String playlsitDetailPostRequestToJson(PlaylsitDetailPostRequest data) =>
    json.encode(data.toJson());

class PlaylsitDetailPostRequest {
  int pid;
  int mid;

  PlaylsitDetailPostRequest({
    required this.pid,
    required this.mid,
  });

  factory PlaylsitDetailPostRequest.fromJson(Map<String, dynamic> json) =>
      PlaylsitDetailPostRequest(
        pid: json["pid"],
        mid: json["mid"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "mid": mid,
      };
}

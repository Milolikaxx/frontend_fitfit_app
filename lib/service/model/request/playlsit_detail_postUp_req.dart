// To parse this JSON data, do
//
//     final playlsitDetailPostUpdateRequest = playlsitDetailPostUpdateRequestFromJson(jsonString);

import 'dart:convert';

PlaylsitDetailPostUpdateRequest playlsitDetailPostUpdateRequestFromJson(
        String str) =>
    PlaylsitDetailPostUpdateRequest.fromJson(json.decode(str));

String playlsitDetailPostUpdateRequestToJson(
        PlaylsitDetailPostUpdateRequest data) =>
    json.encode(data.toJson());

class PlaylsitDetailPostUpdateRequest {
  int id;
  int pid;
  int mid;

  PlaylsitDetailPostUpdateRequest({
    required this.id,
    required this.pid,
    required this.mid,
  });

  factory PlaylsitDetailPostUpdateRequest.fromJson(Map<String, dynamic> json) =>
      PlaylsitDetailPostUpdateRequest(
        id: json["ID"],
        pid: json["Pid"],
        mid: json["Mid"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Pid": pid,
        "Mid": mid,
      };
}

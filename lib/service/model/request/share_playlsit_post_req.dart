// To parse this JSON data, do
//
//     final sharePlaylsitPostRequest = sharePlaylsitPostRequestFromJson(jsonString);

import 'dart:convert';

SharePlaylsitPostRequest sharePlaylsitPostRequestFromJson(String str) =>
    SharePlaylsitPostRequest.fromJson(json.decode(str));

String sharePlaylsitPostRequestToJson(SharePlaylsitPostRequest data) =>
    json.encode(data.toJson());

class SharePlaylsitPostRequest {
  int uid;
  int pid;
  String playlistName;
  String description;

  SharePlaylsitPostRequest({
    required this.uid,
    required this.pid,
    required this.playlistName,
    required this.description,
  });

  factory SharePlaylsitPostRequest.fromJson(Map<String, dynamic> json) =>
      SharePlaylsitPostRequest(
        uid: json["Uid"],
        pid: json["Pid"],
        playlistName: json["PlaylistName"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "Uid": uid,
        "Pid": pid,
        "PlaylistName": playlistName,
        "Description": description,
      };
}

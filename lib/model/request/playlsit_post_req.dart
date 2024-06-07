// To parse this JSON data, do
//
//     final playlsitPostRequest = playlsitPostRequestFromJson(jsonString);

import 'dart:convert';

PlaylsitPostRequest playlsitPostRequestFromJson(String str) =>
    PlaylsitPostRequest.fromJson(json.decode(str));

String playlsitPostRequestToJson(PlaylsitPostRequest data) =>
    json.encode(data.toJson());

class PlaylsitPostRequest {
  int wpid;
  String playlistName;
  int durationPlaylist;
  String imagePlaylist;

  PlaylsitPostRequest({
    required this.wpid,
    required this.playlistName,
    required this.durationPlaylist,
    required this.imagePlaylist,
  });

  factory PlaylsitPostRequest.fromJson(Map<String, dynamic> json) =>
      PlaylsitPostRequest(
        wpid: json["Wpid"],
        playlistName: json["PlaylistName"],
        durationPlaylist: json["DurationPlaylist"],
        imagePlaylist: json["ImagePlaylist"],
      );

  Map<String, dynamic> toJson() => {
        "Wpid": wpid,
        "PlaylistName": playlistName,
        "DurationPlaylist": durationPlaylist,
        "ImagePlaylist": imagePlaylist,
      };
}

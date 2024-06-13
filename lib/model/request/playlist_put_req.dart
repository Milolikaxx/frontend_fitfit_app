// To parse this JSON data, do
//
//     final playlsitPutRequest = playlsitPutRequestFromJson(jsonString);

import 'dart:convert';

PlaylsitPutRequest playlsitPutRequestFromJson(String str) =>
    PlaylsitPutRequest.fromJson(json.decode(str));

String playlsitPutRequestToJson(PlaylsitPutRequest data) =>
    json.encode(data.toJson());

class PlaylsitPutRequest {
  String playlistName;
  String imagePlaylist;

  PlaylsitPutRequest({
    required this.playlistName,
    required this.imagePlaylist,
  });

  factory PlaylsitPutRequest.fromJson(Map<String, dynamic> json) =>
      PlaylsitPutRequest(
        playlistName: json["PlaylistName"],
        imagePlaylist: json["ImagePlaylist"],
      );

  Map<String, dynamic> toJson() => {
        "PlaylistName": playlistName,
        "ImagePlaylist": imagePlaylist,
      };
}


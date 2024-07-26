// To parse this JSON data, do
//
//     final randOneSongOfPlaylistRequest = randOneSongOfPlaylistRequestFromJson(jsonString);

import 'dart:convert';
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart';

RandOneSongOfPlaylistRequest randOneSongOfPlaylistRequestFromJson(String str) =>
    RandOneSongOfPlaylistRequest.fromJson(json.decode(str));

String randOneSongOfPlaylistRequestToJson(RandOneSongOfPlaylistRequest data) =>
    json.encode(data.toJson());

class RandOneSongOfPlaylistRequest {
  List<PlaylistDetail> playlistDetail;
  int index;
  int wpid;

  RandOneSongOfPlaylistRequest({
    required this.playlistDetail,
    required this.index,
    required this.wpid,
  });

  factory RandOneSongOfPlaylistRequest.fromJson(Map<String, dynamic> json) =>
      RandOneSongOfPlaylistRequest(
        playlistDetail: List<PlaylistDetail>.from(
            json["PlaylistDetail"].map((x) => PlaylistDetail.fromJson(x))),
        index: json["Index"],
        wpid: json["Wpid"],
      );

  Map<String, dynamic> toJson() => {
        "PlaylistDetail":
            List<dynamic>.from(playlistDetail.map((x) => x.toJson())),
        "Index": index,
        "Wpid": wpid,
      };
}


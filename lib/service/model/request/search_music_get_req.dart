// To parse this JSON data, do
//
//     final searchMusicGetRequest = searchMusicGetRequestFromJson(jsonString);

import 'dart:convert';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';

SearchMusicGetRequest searchMusicGetRequestFromJson(String str) =>
    SearchMusicGetRequest.fromJson(json.decode(str));

String searchMusicGetRequestToJson(SearchMusicGetRequest data) =>
    json.encode(data.toJson());

class SearchMusicGetRequest {
  List<MusicGetResponse> music;
  String key;

  SearchMusicGetRequest({
    required this.music,
    required this.key,
  });

  factory SearchMusicGetRequest.fromJson(Map<String, dynamic> json) =>
      SearchMusicGetRequest(
        music: List<MusicGetResponse>.from(json["Music"].map((x) => MusicGetResponse.fromJson(x))),
        key: json["Key"],
      );

  Map<String, dynamic> toJson() => {
        "Music": List<dynamic>.from(music.map((x) => x.toJson())),
        "Key": key,
      };
}


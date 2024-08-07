import 'dart:convert';

import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';

AddMusicRequest addMusicRequestFromJson(String str) =>
    AddMusicRequest.fromJson(json.decode(str));

String addMusicRequestToJson(AddMusicRequest data) =>
    json.encode(data.toJson());

class AddMusicRequest {
  List<MusicGetResponse> musicList;
  List<MusicGetResponse> music;
  int indexMl;
  int indexMusic;

  AddMusicRequest({
    required this.musicList,
    required this.music,
    required this.indexMl,
    required this.indexMusic,
  });

  AddMusicRequest copyWith({
    List<MusicGetResponse>? musicList,
    List<MusicGetResponse>? music,
    int? indexMl,
    int? indexMusic,
  }) =>
      AddMusicRequest(
        musicList: musicList ?? this.musicList,
        music: music ?? this.music,
        indexMl: indexMl ?? this.indexMl,
        indexMusic: indexMusic ?? this.indexMusic,
      );

  factory AddMusicRequest.fromJson(Map<String, dynamic> json) =>
      AddMusicRequest(
        musicList:
            List<MusicGetResponse>.from(json["MusicList"].map((x) => MusicGetResponse.fromJson(x))),
        music: List<MusicGetResponse>.from(json["Music"].map((x) => MusicGetResponse.fromJson(x))),
        indexMl: json["IndexML"],
        indexMusic: json["IndexMusic"],
      );

  Map<String, dynamic> toJson() => {
        "MusicList": List<dynamic>.from(musicList.map((x) => x.toJson())),
        "Music": List<dynamic>.from(music.map((x) => x.toJson())),
        "IndexML": indexMl,
        "IndexMusic": indexMusic,
      };
}

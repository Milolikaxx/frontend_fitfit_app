import 'dart:convert';

import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart';

AddMusicInPlaylistDetailRequest addMusicInPlaylistDetailRequestFromJson(
        String str) =>
    AddMusicInPlaylistDetailRequest.fromJson(json.decode(str));

String addMusicInPlaylistDetailRequestToJson(
        AddMusicInPlaylistDetailRequest data) =>
    json.encode(data.toJson());

class AddMusicInPlaylistDetailRequest {
  List<PlaylistDetail> playlistDetail;
  List<MusicGetResponse> music;
  int indexPl;
  int indexMusic;

  AddMusicInPlaylistDetailRequest({
    required this.playlistDetail,
    required this.music,
    required this.indexPl,
    required this.indexMusic,
  });

  AddMusicInPlaylistDetailRequest copyWith({
    List<PlaylistDetail>? playlistDetail,
    List<MusicGetResponse>? music,
    int? indexPl,
    int? indexMusic,
  }) =>
      AddMusicInPlaylistDetailRequest(
        playlistDetail: playlistDetail ?? this.playlistDetail,
        music: music ?? this.music,
        indexPl: indexPl ?? this.indexPl,
        indexMusic: indexMusic ?? this.indexMusic,
      );

  factory AddMusicInPlaylistDetailRequest.fromJson(Map<String, dynamic> json) =>
      AddMusicInPlaylistDetailRequest(
        playlistDetail: List<PlaylistDetail>.from(
            json["PlaylistDetail"].map((x) => PlaylistDetail.fromJson(x))),
        music: List<MusicGetResponse>.from(
            json["Music"].map((x) => MusicGetResponse.fromJson(x))),
        indexPl: json["IndexPL"],
        indexMusic: json["IndexMusic"],
      );

  Map<String, dynamic> toJson() => {
        "PlaylistDetail":
            List<dynamic>.from(playlistDetail.map((x) => x.toJson())),
        "Music": List<dynamic>.from(music.map((x) => x.toJson())),
        "IndexPL": indexPl,
        "IndexMusic": indexMusic,
      };
}

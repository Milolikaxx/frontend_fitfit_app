// To parse this JSON data, do
//
//     final randOneSongOfPlaylistRequest = randOneSongOfPlaylistRequestFromJson(jsonString);

import 'dart:convert';
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart' as playlistGet;

RandOneSongOfPlaylistRequest randOneSongOfPlaylistRequestFromJson(String str) =>
    RandOneSongOfPlaylistRequest.fromJson(json.decode(str));

String randOneSongOfPlaylistRequestToJson(RandOneSongOfPlaylistRequest data) =>
    json.encode(data.toJson());

class RandOneSongOfPlaylistRequest {
  List<playlistGet.PlaylistDetail> playlistDetail;
  int index;
  int wpid;

  RandOneSongOfPlaylistRequest({
    required this.playlistDetail,
    required this.index,
    required this.wpid,
  });

  factory RandOneSongOfPlaylistRequest.fromJson(Map<String, dynamic> json) =>
      RandOneSongOfPlaylistRequest(
        playlistDetail: List<playlistGet.PlaylistDetail>.from(
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

class PlaylistDetail {
  int id;
  int pid;
  int mid;
  Music music;

  PlaylistDetail({
    required this.id,
    required this.pid,
    required this.mid,
    required this.music,
  });

  factory PlaylistDetail.fromJson(Map<String, dynamic> json) => PlaylistDetail(
        id: json["ID"],
        pid: json["Pid"],
        mid: json["Mid"],
        music: Music.fromJson(json["Music"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Pid": pid,
        "Mid": mid,
        "Music": music.toJson(),
      };
}

class Music {
  int mid;
  int mtid;
  MusicType musicType;
  String mLink;
  String name;
  String musicImage;
  String artist;
  double duration;
  int bpm;

  Music({
    required this.mid,
    required this.mtid,
    required this.musicType,
    required this.mLink,
    required this.name,
    required this.musicImage,
    required this.artist,
    required this.duration,
    required this.bpm,
  });

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        mid: json["Mid"],
        mtid: json["Mtid"],
        musicType: MusicType.fromJson(json["MusicType"]),
        mLink: json["MLink"],
        name: json["Name"],
        musicImage: json["MusicImage"],
        artist: json["Artist"],
        duration: json["Duration"]?.toDouble(),
        bpm: json["Bpm"],
      );

  Map<String, dynamic> toJson() => {
        "Mid": mid,
        "Mtid": mtid,
        "MusicType": musicType.toJson(),
        "MLink": mLink,
        "Name": name,
        "MusicImage": musicImage,
        "Artist": artist,
        "Duration": duration,
        "Bpm": bpm,
      };
}

class MusicType {
  int mtid;
  String name;

  MusicType({
    required this.mtid,
    required this.name,
  });

  factory MusicType.fromJson(Map<String, dynamic> json) => MusicType(
        mtid: json["Mtid"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Mtid": mtid,
        "Name": name,
      };
}

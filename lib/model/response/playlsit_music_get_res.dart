// To parse this JSON data, do
//
//     final playlsitMusicGetResponse = playlsitMusicGetResponseFromJson(jsonString);

import 'dart:convert';

PlaylsitMusicGetResponse playlsitMusicGetResponseFromJson(String str) =>
    PlaylsitMusicGetResponse.fromJson(json.decode(str));

String playlsitMusicGetResponseToJson(PlaylsitMusicGetResponse data) =>
    json.encode(data.toJson());

class PlaylsitMusicGetResponse {
  int pid;
  int wpid;
  String playlistName;
  int durationPlaylist;
  String imagePlaylist;
  DateTime createdAt;
  DateTime updatedAt;
  List<PlaylistDetail> playlistDetail;

  PlaylsitMusicGetResponse({
    required this.pid,
    required this.wpid,
    required this.playlistName,
    required this.durationPlaylist,
    required this.imagePlaylist,
    required this.createdAt,
    required this.updatedAt,
    required this.playlistDetail,
  });

  factory PlaylsitMusicGetResponse.fromJson(Map<String, dynamic> json) =>
      PlaylsitMusicGetResponse(
        pid: json["Pid"],
        wpid: json["Wpid"],
        playlistName: json["PlaylistName"],
        durationPlaylist: json["DurationPlaylist"],
        imagePlaylist: json["ImagePlaylist"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        playlistDetail: List<PlaylistDetail>.from(
            json["PlaylistDetail"].map((x) => PlaylistDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Pid": pid,
        "Wpid": wpid,
        "PlaylistName": playlistName,
        "DurationPlaylist": durationPlaylist,
        "ImagePlaylist": imagePlaylist,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "PlaylistDetail":
            List<dynamic>.from(playlistDetail.map((x) => x.toJson())),
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

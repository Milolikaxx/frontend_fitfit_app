// To parse this JSON data, do
//
//     final musicGetResponse = musicGetResponseFromJson(jsonString);

import 'dart:convert';

import 'package:frontend_fitfit_app/service/model/request/rand_music1_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart' as getPlaylist;

List<MusicGetResponse> musicGetResponseFromJson(String str) =>
    List<MusicGetResponse>.from(
        json.decode(str).map((x) => MusicGetResponse.fromJson(x)));

String musicGetResponseToJson(List<MusicGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MusicGetResponse {
  int mid;
  int mtid;
  MusicType musicType;
  String mLink;
  String name;
  String musicImage;
  String artist;
  double duration;
  int bpm;
  

  MusicGetResponse({
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

  factory MusicGetResponse.fromJson(Map<String, dynamic> json) =>
      MusicGetResponse(
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
 // เพิ่มเมธอด toMusic
  Music toMusic() {
    return Music(
      mid: mid,
      mtid: mtid,
      musicType: MusicGenre(mtid: mtid, name: name),
      mLink: mLink,
      name: name,
      musicImage: musicImage,
      artist: artist,
      duration: duration,
      bpm: bpm,
    );
  }
  
  getPlaylist.Music toMusicPl() {
      return getPlaylist.Music(
      mid: mid,
      mtid: mtid,
      musicType: getPlaylist.MusicType(mtid: mtid, name: name),
      mLink: mLink,
      name: name,
      musicImage: musicImage,
      artist: artist,
      duration: duration,
      bpm: bpm,
    );
  }
  
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

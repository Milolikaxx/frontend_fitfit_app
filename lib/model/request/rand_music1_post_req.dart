// To parse this JSON data, do
//
//     final randMusic1PostRequest = randMusic1PostRequestFromJson(jsonString);

import 'dart:convert';

RandMusic1PostRequest randMusic1PostRequestFromJson(String str) =>
    RandMusic1PostRequest.fromJson(json.decode(str));

String randMusic1PostRequestToJson(RandMusic1PostRequest data) =>
    json.encode(data.toJson());

class RandMusic1PostRequest {
  List<MusicList> musicList;
  int index;
  int wpid;

  RandMusic1PostRequest({
    required this.musicList,
    required this.index,
    required this.wpid,
  });

  factory RandMusic1PostRequest.fromJson(Map<String, dynamic> json) =>
      RandMusic1PostRequest(
        musicList: List<MusicList>.from(
            json["MusicList"].map((x) => MusicList.fromJson(x))),
        index: json["Index"],
        wpid: json["Wpid"],
      );

  Map<String, dynamic> toJson() => {
        "MusicList": List<dynamic>.from(musicList.map((x) => x.toJson())),
        "Index": index,
        "Wpid": wpid,
      };
}

class MusicList {
  int mid;
  int mtid;
  MusicType musicType;
  String mLink;
  String name;
  String musicImage;
  String artist;
  double duration;
  int bpm;

  MusicList({
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

  factory MusicList.fromJson(Map<String, dynamic> json) => MusicList(
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

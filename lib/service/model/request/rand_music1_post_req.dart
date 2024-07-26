// To parse this JSON data, do
//
//     final randMusic1PostRequest = randMusic1PostRequestFromJson(jsonString);

import 'dart:convert';

import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';

RandMusic1PostRequest randMusic1PostRequestFromJson(String str) =>
    RandMusic1PostRequest.fromJson(json.decode(str));

String randMusic1PostRequestToJson(RandMusic1PostRequest data) =>
    json.encode(data.toJson());

class RandMusic1PostRequest {
  List<MusicGetResponse> musicList;
  int index;
  int wpid;

  RandMusic1PostRequest({
    required this.musicList,
    required this.index,
    required this.wpid,
  });

  factory RandMusic1PostRequest.fromJson(Map<String, dynamic> json) =>
      RandMusic1PostRequest(
        musicList: List<MusicGetResponse>.from(
            json["MusicList"].map((x) => MusicGetResponse.fromJson(x))),
        index: json["Index"],
        wpid: json["Wpid"],
      );

  Map<String, dynamic> toJson() => {
        "MusicList": List<dynamic>.from(musicList.map((x) => x.toJson())),
        "Index": index,
        "Wpid": wpid,
      };
}


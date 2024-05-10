// To parse this JSON data, do
//
//     final musictypeGetResponse = musictypeGetResponseFromJson(jsonString);

import 'dart:convert';

List<MusictypeGetResponse> musictypeGetResponseFromJson(String str) =>
    List<MusictypeGetResponse>.from(
        json.decode(str).map((x) => MusictypeGetResponse.fromJson(x)));

String musictypeGetResponseToJson(List<MusictypeGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MusictypeGetResponse {
  int mtid;
  String name;

  MusictypeGetResponse({
    required this.mtid,
    required this.name,
  });

  factory MusictypeGetResponse.fromJson(Map<String, dynamic> json) =>
      MusictypeGetResponse(
        mtid: json["Mtid"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Mtid": mtid,
        "Name": name,
      };
}

// To parse this JSON data, do
//
//     final workoutProfileMusictypeGetResponse = workoutProfileMusictypeGetResponseFromJson(jsonString);

import 'dart:convert';

List<WorkoutProfileMusictypeGetResponse>
    workoutProfileMusictypeGetResponseFromJson(String str) =>
        List<WorkoutProfileMusictypeGetResponse>.from(json
            .decode(str)
            .map((x) => WorkoutProfileMusictypeGetResponse.fromJson(x)));

String workoutProfileMusictypeGetResponseToJson(
        List<WorkoutProfileMusictypeGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkoutProfileMusictypeGetResponse {
  int id;
  int wpid;
  int mtid;
  MusicType musicType;

  WorkoutProfileMusictypeGetResponse({
    required this.id,
    required this.wpid,
    required this.mtid,
    required this.musicType,
  });

  factory WorkoutProfileMusictypeGetResponse.fromJson(
          Map<String, dynamic> json) =>
      WorkoutProfileMusictypeGetResponse(
        id: json["ID"],
        wpid: json["Wpid"],
        mtid: json["Mtid"],
        musicType: MusicType.fromJson(json["MusicType"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Wpid": wpid,
        "Mtid": mtid,
        "MusicType": musicType.toJson(),
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

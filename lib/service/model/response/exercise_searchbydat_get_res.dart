// To parse this JSON data, do
//
//     final exerciseSearchbydayGetResponse = exerciseSearchbydayGetResponseFromJson(jsonString);

import 'dart:convert';

List<ExerciseSearchbydayGetResponse> exerciseSearchbydayGetResponseFromJson(
        String str) =>
    List<ExerciseSearchbydayGetResponse>.from(json
        .decode(str)
        .map((x) => ExerciseSearchbydayGetResponse.fromJson(x)));

String exerciseSearchbydayGetResponseToJson(
        List<ExerciseSearchbydayGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseSearchbydayGetResponse {
  int eid;
  int uid;
  String edate;
  String estart;
  String estop;
  String playlistName;
  String exerciseType;
  int levelExercise;
  String imagePlaylist;
  double durationEx;

  ExerciseSearchbydayGetResponse({
    required this.eid,
    required this.uid,
    required this.edate,
    required this.estart,
    required this.estop,
    required this.playlistName,
    required this.exerciseType,
    required this.levelExercise,
    required this.imagePlaylist,
    required this.durationEx,
  });

  factory ExerciseSearchbydayGetResponse.fromJson(Map<String, dynamic> json) =>
      ExerciseSearchbydayGetResponse(
        eid: json["Eid"],
        uid: json["Uid"],
        edate: json["Edate"],
        estart: json["Estart"],
        estop: json["Estop"],
        playlistName: json["PlaylistName"],
        exerciseType: json["ExerciseType"],
        levelExercise: json["LevelExercise"],
        imagePlaylist: json["ImagePlaylist"],
        durationEx: json["DurationEx"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Eid": eid,
        "Uid": uid,
        "Edate": edate,
        "Estart": estart,
        "Estop": estop,
        "PlaylistName": playlistName,
        "ExerciseType": exerciseType,
        "LevelExercise": levelExercise,
        "ImagePlaylist": imagePlaylist,
        "DurationEx": durationEx,
      };
}

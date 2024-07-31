// To parse this JSON data, do
//
//     final exerciseShowbydayGetResponse = exerciseShowbydayGetResponseFromJson(jsonString);

import 'dart:convert';

List<ExerciseShowbydayGetResponse> exerciseShowbydayGetResponseFromJson(
        String str) =>
    List<ExerciseShowbydayGetResponse>.from(
        json.decode(str).map((x) => ExerciseShowbydayGetResponse.fromJson(x)));

String exerciseShowbydayGetResponseToJson(
        List<ExerciseShowbydayGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseShowbydayGetResponse {
  DateTime date;
  List<Exercise> exercises;
  int count;

  ExerciseShowbydayGetResponse({
    required this.date,
    required this.exercises,
    required this.count,
  });

  factory ExerciseShowbydayGetResponse.fromJson(Map<String, dynamic> json) =>
      ExerciseShowbydayGetResponse(
        date: DateTime.parse(json["date"]),
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
        "count": count,
      };
}

class Exercise {
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

  Exercise({
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

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
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

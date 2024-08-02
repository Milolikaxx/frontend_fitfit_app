// To parse this JSON data, do
//
//     final exerciseLast12MonthGetResponse = exerciseLast12MonthGetResponseFromJson(jsonString);

import 'dart:convert';

List<ExerciseLast12MonthGetResponse> exerciseLast12MonthGetResponseFromJson(
        String str) =>
    List<ExerciseLast12MonthGetResponse>.from(json
        .decode(str)
        .map((x) => ExerciseLast12MonthGetResponse.fromJson(x)));

String exerciseLast12MonthGetResponseToJson(
        List<ExerciseLast12MonthGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExerciseLast12MonthGetResponse {
  int monthNumber;
  String monthName;
  int exerciseCount;
  List<Exercise> exercises;

  ExerciseLast12MonthGetResponse({
    required this.monthNumber,
    required this.monthName,
    required this.exerciseCount,
    required this.exercises,
  });

  factory ExerciseLast12MonthGetResponse.fromJson(Map<String, dynamic> json) =>
      ExerciseLast12MonthGetResponse(
        monthNumber: json["month_number"],
        monthName: json["month_name"],
        exerciseCount: json["exercise_count"],
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "month_number": monthNumber,
        "month_name": monthName,
        "exercise_count": exerciseCount,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
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

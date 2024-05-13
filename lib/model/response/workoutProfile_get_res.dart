// To parse this JSON data, do
//
//     final workoutProfileGetResponse = workoutProfileGetResponseFromJson(jsonString);

import 'dart:convert';

List<WorkoutProfileGetResponse> workoutProfileGetResponseFromJson(String str) =>
    List<WorkoutProfileGetResponse>.from(
        json.decode(str).map((x) => WorkoutProfileGetResponse.fromJson(x)));

String workoutProfileGetResponseToJson(List<WorkoutProfileGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkoutProfileGetResponse {
  int wpid;
  int uid;
  int levelExercise;
  int duration;
  String exerciseType;
  DateTime createdAt;
  DateTime updatedAt;

  WorkoutProfileGetResponse({
    required this.wpid,
    required this.uid,
    required this.levelExercise,
    required this.duration,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutProfileGetResponse.fromJson(Map<String, dynamic> json) =>
      WorkoutProfileGetResponse(
        wpid: json["Wpid"],
        uid: json["Uid"],
        levelExercise: json["LevelExercise"],
        duration: json["Duration"],
        exerciseType: json["ExerciseType"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "Wpid": wpid,
        "Uid": uid,
        "LevelExercise": levelExercise,
        "Duration": duration,
        "ExerciseType": exerciseType,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final workoutProfilePostRequest = workoutProfilePostRequestFromJson(jsonString);

import 'dart:convert';

WorkoutProfilePostRequest workoutProfilePostRequestFromJson(String str) =>
    WorkoutProfilePostRequest.fromJson(json.decode(str));

String workoutProfilePostRequestToJson(WorkoutProfilePostRequest data) =>
    json.encode(data.toJson());

class WorkoutProfilePostRequest {
  int uid;
  int levelExercise;
  int duration;
  String exerciseType;

  WorkoutProfilePostRequest({
    required this.uid,
    required this.levelExercise,
    required this.duration,
    required this.exerciseType,
  });

  factory WorkoutProfilePostRequest.fromJson(Map<String, dynamic> json) =>
      WorkoutProfilePostRequest(
        uid: json["Uid"],
        levelExercise: json["LevelExercise"],
        duration: json["Duration"],
        exerciseType: json["ExerciseType"],
      );

  Map<String, dynamic> toJson() => {
        "Uid": uid,
        "LevelExercise": levelExercise,
        "Duration": duration,
        "ExerciseType": exerciseType,
      };
}


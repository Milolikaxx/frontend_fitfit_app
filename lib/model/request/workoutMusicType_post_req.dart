// To parse this JSON data, do
//
//     final workoutMusicTypePostRequest = workoutMusicTypePostRequestFromJson(jsonString);

import 'dart:convert';

WorkoutMusicTypePostRequest workoutMusicTypePostRequestFromJson(String str) =>
    WorkoutMusicTypePostRequest.fromJson(json.decode(str));

String workoutMusicTypePostRequestToJson(WorkoutMusicTypePostRequest data) =>
    json.encode(data.toJson());

class WorkoutMusicTypePostRequest {
  int wpid;
  int mtid;

  WorkoutMusicTypePostRequest({
    required this.wpid,
    required this.mtid,
  });

  factory WorkoutMusicTypePostRequest.fromJson(Map<String, dynamic> json) =>
      WorkoutMusicTypePostRequest(
        wpid: json["wpid"],
        mtid: json["mtid"],
      );

  Map<String, dynamic> toJson() => {
        "wpid": wpid,
        "mtid": mtid,
      };
}


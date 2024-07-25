// To parse this JSON data, do
//
//     final exercisePostRequest = exercisePostRequestFromJson(jsonString);

import 'dart:convert';

ExercisePostRequest exercisePostRequestFromJson(String str) =>
    ExercisePostRequest.fromJson(json.decode(str));

String exercisePostRequestToJson(ExercisePostRequest data) =>
    json.encode(data.toJson());

class ExercisePostRequest {
  int? uid;
  String? edate;
  String? estart;
  String? estop;
  String? playlistName;
  String? exerciseType;
  int? levelExercise;
  String? imagePlaylist;
  int? duration;

  ExercisePostRequest({
    this.uid,
    this.edate,
    this.estart,
    this.estop,
    this.playlistName,
    this.exerciseType,
    this.levelExercise,
    this.imagePlaylist,
    this.duration,
  });

  factory ExercisePostRequest.fromJson(Map<String, dynamic> json) =>
      ExercisePostRequest(
        uid: json["Uid"],
        edate: json["Edate"],
        estart: json["Estart"],
        estop: json["Estop"],
        playlistName: json["PlaylistName"],
        exerciseType: json["ExerciseType"],
        levelExercise: json["LevelExercise"],
        imagePlaylist: json["ImagePlaylist"],
        duration: json["Duration"],
      );

  Map<String, dynamic> toJson() => {
        "Uid": uid,
        "Edate": edate,
        "Estart": estart,
        "Estop": estop,
        "PlaylistName": playlistName,
        "ExerciseType": exerciseType,
        "LevelExercise": levelExercise,
        "ImagePlaylist": imagePlaylist,
        "Duration": duration,
      };
}

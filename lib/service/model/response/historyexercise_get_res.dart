// To parse this JSON data, do
//
//     final historyExerciseGetResponse = historyExerciseGetResponseFromJson(jsonString);

import 'dart:convert';

List<HistoryExerciseGetResponse> historyExerciseGetResponseFromJson(
        String str) =>
    List<HistoryExerciseGetResponse>.from(
        json.decode(str).map((x) => HistoryExerciseGetResponse.fromJson(x)));

String historyExerciseGetResponseToJson(
        List<HistoryExerciseGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryExerciseGetResponse {
  int eid;
  int uid;
  int mHistoryid;
  String edate;
  String estart;
  String estop;
  String playlistName;
  String exerciseType;
  int levelExercise;
  String imagePlaylist;
  int duration;

  HistoryExerciseGetResponse({
    required this.eid,
    required this.uid,
    required this.mHistoryid,
    required this.edate,
    required this.estart,
    required this.estop,
    required this.playlistName,
    required this.exerciseType,
    required this.levelExercise,
    required this.imagePlaylist,
    required this.duration,
  });

  factory HistoryExerciseGetResponse.fromJson(Map<String, dynamic> json) =>
      HistoryExerciseGetResponse(
        eid: json["Eid"],
        uid: json["Uid"],
        mHistoryid: json["MHistoryid"],
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
        "Eid": eid,
        "Uid": uid,
        "MHistoryid": mHistoryid,
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

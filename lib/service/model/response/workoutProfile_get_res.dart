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
  List<WorkoutMusictype> workoutMusictype;

  WorkoutProfileGetResponse({
    required this.wpid,
    required this.uid,
    required this.levelExercise,
    required this.duration,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
    required this.workoutMusictype,
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
        workoutMusictype: List<WorkoutMusictype>.from(
            json["WorkoutMusictype"].map((x) => WorkoutMusictype.fromJson(x))),
      );

  get isNotEmpty => null;

  Map<String, dynamic> toJson() => {
        "Wpid": wpid,
        "Uid": uid,
        "LevelExercise": levelExercise,
        "Duration": duration,
        "ExerciseType": exerciseType,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "WorkoutMusictype":
            List<dynamic>.from(workoutMusictype.map((x) => x.toJson())),
      };
}

class WorkoutMusictype {
  int id;
  int wpid;
  int mtid;
  MusicType musicType;

  WorkoutMusictype({
    required this.id,
    required this.wpid,
    required this.mtid,
    required this.musicType,
  });

  factory WorkoutMusictype.fromJson(Map<String, dynamic> json) =>
      WorkoutMusictype(
        id: json["ID"],
        wpid: json["Wpid"],
        mtid: json["Mtid"],
        musicType: MusicType.fromJson(json["MusicType"]),
      );

  get workoutMusictype => null;

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

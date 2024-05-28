// To parse this JSON data, do
//
//     final workoutProfileMusicTypeGetResponse = workoutProfileMusicTypeGetResponseFromJson(jsonString);

import 'dart:convert';

List<WorkoutProfileMusicTypeGetResponse>
    workoutProfileMusicTypeGetResponseFromJson(String str) =>
        List<WorkoutProfileMusicTypeGetResponse>.from(json
            .decode(str)
            .map((x) => WorkoutProfileMusicTypeGetResponse.fromJson(x)));

String workoutProfileMusicTypeGetResponseToJson(
        List<WorkoutProfileMusicTypeGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkoutProfileMusicTypeGetResponse {
  int wpid;
  int uid;
  int levelExercise;
  int duration;
  String exerciseType;
  DateTime createdAt;
  DateTime updatedAt;
  WorkoutMusictype workoutMusictype;

  WorkoutProfileMusicTypeGetResponse({
    required this.wpid,
    required this.uid,
    required this.levelExercise,
    required this.duration,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
    required this.workoutMusictype,
  });

  factory WorkoutProfileMusicTypeGetResponse.fromJson(
          Map<String, dynamic> json) =>
      WorkoutProfileMusicTypeGetResponse(
        wpid: json["Wpid"],
        uid: json["Uid"],
        levelExercise: json["LevelExercise"],
        duration: json["Duration"],
        exerciseType: json["ExerciseType"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        workoutMusictype: WorkoutMusictype.fromJson(json["WorkoutMusictype"]),
      );

  Map<String, dynamic> toJson() => {
        "Wpid": wpid,
        "Uid": uid,
        "LevelExercise": levelExercise,
        "Duration": duration,
        "ExerciseType": exerciseType,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "WorkoutMusictype": workoutMusictype.toJson(),
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

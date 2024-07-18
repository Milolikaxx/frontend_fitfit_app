// To parse this JSON data, do
//
//     final playlistWithWorkoutGetResponse = playlistWithWorkoutGetResponseFromJson(jsonString);

import 'dart:convert';

PlaylistWithWorkoutGetResponse playlistWithWorkoutGetResponseFromJson(
        String str) =>
    PlaylistWithWorkoutGetResponse.fromJson(json.decode(str));

String playlistWithWorkoutGetResponseToJson(
        PlaylistWithWorkoutGetResponse data) =>
    json.encode(data.toJson());

class PlaylistWithWorkoutGetResponse {
  int pid;
  int wpid;
  WorkoutProfile workoutProfile;
  String playlistName;
  int durationPlaylist;
  String imagePlaylist;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic playlistDetail;

  PlaylistWithWorkoutGetResponse({
    required this.pid,
    required this.wpid,
    required this.workoutProfile,
    required this.playlistName,
    required this.durationPlaylist,
    required this.imagePlaylist,
    required this.createdAt,
    required this.updatedAt,
    required this.playlistDetail,
  });

  factory PlaylistWithWorkoutGetResponse.fromJson(Map<String, dynamic> json) =>
      PlaylistWithWorkoutGetResponse(
        pid: json["Pid"],
        wpid: json["Wpid"],
        workoutProfile: WorkoutProfile.fromJson(json["WorkoutProfile"]),
        playlistName: json["PlaylistName"],
        durationPlaylist: json["DurationPlaylist"],
        imagePlaylist: json["ImagePlaylist"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        playlistDetail: json["PlaylistDetail"],
      );

  Map<String, dynamic> toJson() => {
        "Pid": pid,
        "Wpid": wpid,
        "WorkoutProfile": workoutProfile.toJson(),
        "PlaylistName": playlistName,
        "DurationPlaylist": durationPlaylist,
        "ImagePlaylist": imagePlaylist,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "PlaylistDetail": playlistDetail,
      };
}

class WorkoutProfile {
  int wpid;
  int uid;
  int levelExercise;
  int duration;
  String exerciseType;
  DateTime createdAt;
  DateTime updatedAt;
  List<WorkoutMusictype> workoutMusictype;

  WorkoutProfile({
    required this.wpid,
    required this.uid,
    required this.levelExercise,
    required this.duration,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
    required this.workoutMusictype,
  });

  factory WorkoutProfile.fromJson(Map<String, dynamic> json) => WorkoutProfile(
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

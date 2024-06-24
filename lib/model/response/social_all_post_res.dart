// To parse this JSON data, do
//
//     final socialAllPostResonse = socialAllPostResonseFromJson(jsonString);

import 'dart:convert';

SocialAllPostResonse socialAllPostResonseFromJson(String str) => SocialAllPostResonse.fromJson(json.decode(str));

String socialAllPostResonseToJson(SocialAllPostResonse data) => json.encode(data.toJson());

class SocialAllPostResonse {
    int postid;
    int uid;
    User user;
    int pid;
    Playlist playlist;
    String playlistName;
    String description;
    DateTime pDatetime;
    DateTime createdAt;
    DateTime updatedAt;

    SocialAllPostResonse({
        required this.postid,
        required this.uid,
        required this.user,
        required this.pid,
        required this.playlist,
        required this.playlistName,
        required this.description,
        required this.pDatetime,
        required this.createdAt,
        required this.updatedAt,
    });

    factory SocialAllPostResonse.fromJson(Map<String, dynamic> json) => SocialAllPostResonse(
        postid: json["Postid"],
        uid: json["Uid"],
        user: User.fromJson(json["User"]),
        pid: json["Pid"],
        playlist: Playlist.fromJson(json["Playlist"]),
        playlistName: json["PlaylistName"],
        description: json["Description"],
        pDatetime: DateTime.parse(json["PDatetime"]),
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Postid": postid,
        "Uid": uid,
        "User": user.toJson(),
        "Pid": pid,
        "Playlist": playlist.toJson(),
        "PlaylistName": playlistName,
        "Description": description,
        "PDatetime": pDatetime.toIso8601String(),
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
    };
}

class Playlist {
    int pid;
    int wpid;
    WorkoutProfile workoutProfile;
    String playlistName;
    int durationPlaylist;
    String imagePlaylist;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic playlistDetail;

    Playlist({
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

    factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
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
        workoutMusictype: List<WorkoutMusictype>.from(json["WorkoutMusictype"].map((x) => WorkoutMusictype.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Wpid": wpid,
        "Uid": uid,
        "LevelExercise": levelExercise,
        "Duration": duration,
        "ExerciseType": exerciseType,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "WorkoutMusictype": List<dynamic>.from(workoutMusictype.map((x) => x.toJson())),
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

    factory WorkoutMusictype.fromJson(Map<String, dynamic> json) => WorkoutMusictype(
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

class User {
    int uid;
    String name;
    DateTime birthday;
    String email;
    String password;
    String imageProfile;
    String googleId;
    DateTime createdAt;
    DateTime updatedAt;

    User({
        required this.uid,
        required this.name,
        required this.birthday,
        required this.email,
        required this.password,
        required this.imageProfile,
        required this.googleId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["Uid"],
        name: json["Name"],
        birthday: DateTime.parse(json["Birthday"]),
        email: json["Email"],
        password: json["Password"],
        imageProfile: json["ImageProfile"],
        googleId: json["GoogleID"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Uid": uid,
        "Name": name,
        "Birthday": birthday.toIso8601String(),
        "Email": email,
        "Password": password,
        "ImageProfile": imageProfile,
        "GoogleID": googleId,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
    };
}

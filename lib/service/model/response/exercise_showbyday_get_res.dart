// To parse this JSON data, do
//
//     final exerciseShowbydayGetResponse = exerciseShowbydayGetResponseFromJson(jsonString);

import 'dart:convert';

ExerciseShowbydayGetResponse exerciseShowbydayGetResponseFromJson(String str) => ExerciseShowbydayGetResponse.fromJson(json.decode(str));

String exerciseShowbydayGetResponseToJson(ExerciseShowbydayGetResponse data) => json.encode(data.toJson());

class ExerciseShowbydayGetResponse {
    The202407 the20240725;
    The202407 the20240726;
    The202407 the20240727;
    The20240728 the20240728;
    The202407 the20240729;
    The202407 the20240730;
    The20240731 the20240731;

    ExerciseShowbydayGetResponse({
        required this.the20240725,
        required this.the20240726,
        required this.the20240727,
        required this.the20240728,
        required this.the20240729,
        required this.the20240730,
        required this.the20240731,
    });

    factory ExerciseShowbydayGetResponse.fromJson(Map<String, dynamic> json) => ExerciseShowbydayGetResponse(
        the20240725: The202407.fromJson(json["2024-07-25"]),
        the20240726: The202407.fromJson(json["2024-07-26"]),
        the20240727: The202407.fromJson(json["2024-07-27"]),
        the20240728: The20240728.fromJson(json["2024-07-28"]),
        the20240729: The202407.fromJson(json["2024-07-29"]),
        the20240730: The202407.fromJson(json["2024-07-30"]),
        the20240731: The20240731.fromJson(json["2024-07-31"]),
    );

    Map<String, dynamic> toJson() => {
        "2024-07-25": the20240725.toJson(),
        "2024-07-26": the20240726.toJson(),
        "2024-07-27": the20240727.toJson(),
        "2024-07-28": the20240728.toJson(),
        "2024-07-29": the20240729.toJson(),
        "2024-07-30": the20240730.toJson(),
        "2024-07-31": the20240731.toJson(),
    };
}

class The202407 {
    int count;
    List<dynamic> exercises;

    The202407({
        required this.count,
        required this.exercises,
    });

    factory The202407.fromJson(Map<String, dynamic> json) => The202407(
        count: json["count"],
        exercises: List<dynamic>.from(json["exercises"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "exercises": List<dynamic>.from(exercises.map((x) => x)),
    };
}

class The20240728 {
    int count;
    List<The20240728Exercise> exercises;

    The20240728({
        required this.count,
        required this.exercises,
    });

    factory The20240728.fromJson(Map<String, dynamic> json) => The20240728(
        count: json["count"],
        exercises: List<The20240728Exercise>.from(json["exercises"].map((x) => The20240728Exercise.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
    };
}

class The20240728Exercise {
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

    The20240728Exercise({
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

    factory The20240728Exercise.fromJson(Map<String, dynamic> json) => The20240728Exercise(
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

class The20240731 {
    int count;
    List<The20240731Exercise> exercises;

    The20240731({
        required this.count,
        required this.exercises,
    });

    factory The20240731.fromJson(Map<String, dynamic> json) => The20240731(
        count: json["count"],
        exercises: List<The20240731Exercise>.from(json["exercises"].map((x) => The20240731Exercise.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
    };
}

class The20240731Exercise {
    int eid;
    int uid;
    String edate;
    String estart;
    String estop;
    String playlistName;
    String exerciseType;
    int levelExercise;
    String imagePlaylist;
    int durationEx;

    The20240731Exercise({
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

    factory The20240731Exercise.fromJson(Map<String, dynamic> json) => The20240731Exercise(
        eid: json["Eid"],
        uid: json["Uid"],
        edate: json["Edate"],
        estart: json["Estart"],
        estop: json["Estop"],
        playlistName: json["PlaylistName"],
        exerciseType: json["ExerciseType"],
        levelExercise: json["LevelExercise"],
        imagePlaylist: json["ImagePlaylist"],
        durationEx: json["DurationEx"],
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

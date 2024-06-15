// To parse this JSON data, do
//
//     final playlsitlInWorkoutprofileGetResponse = playlsitlInWorkoutprofileGetResponseFromJson(jsonString);

import 'dart:convert';

List<PlaylistInWorkoutprofileGetResponse>
    playlsitlInWorkoutprofileGetResponseFromJson(String str) =>
        List<PlaylistInWorkoutprofileGetResponse>.from(json
            .decode(str)
            .map((x) => PlaylistInWorkoutprofileGetResponse.fromJson(x)));

String playlsitlInWorkoutprofileGetResponseToJson(
        List<PlaylistInWorkoutprofileGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaylistInWorkoutprofileGetResponse {
  int pid;
  int wpid;
  String playlistName;
  int durationPlaylist;
  String imagePlaylist;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic playlistDetail;

  PlaylistInWorkoutprofileGetResponse({
    required this.pid,
    required this.wpid,
    required this.playlistName,
    required this.durationPlaylist,
    required this.imagePlaylist,
    required this.createdAt,
    required this.updatedAt,
    required this.playlistDetail,
  });

  factory PlaylistInWorkoutprofileGetResponse.fromJson(
          Map<String, dynamic> json) =>
      PlaylistInWorkoutprofileGetResponse(
        pid: json["Pid"],
        wpid: json["Wpid"],
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
        "PlaylistName": playlistName,
        "DurationPlaylist": durationPlaylist,
        "ImagePlaylist": imagePlaylist,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "PlaylistDetail": playlistDetail,
      };
}

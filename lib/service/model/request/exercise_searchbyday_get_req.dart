// To parse this JSON data, do
//
//     final exerciseSearchbydayGetRequest = exerciseSearchbydayGetRequestFromJson(jsonString);

import 'dart:convert';

ExerciseSearchbydayGetRequest exerciseSearchbydayGetRequestFromJson(
        String str) =>
    ExerciseSearchbydayGetRequest.fromJson(json.decode(str));

String exerciseSearchbydayGetRequestToJson(
        ExerciseSearchbydayGetRequest data) =>
    json.encode(data.toJson());

class ExerciseSearchbydayGetRequest {
  DateTime keyword;

  ExerciseSearchbydayGetRequest({
    required this.keyword,
  });

  factory ExerciseSearchbydayGetRequest.fromJson(Map<String, dynamic> json) =>
      ExerciseSearchbydayGetRequest(
        keyword: DateTime.parse(json["keyword"]),
      );

  Map<String, dynamic> toJson() => {
        "keyword":
            "${keyword.year.toString().padLeft(4, '0')}-${keyword.month.toString().padLeft(2, '0')}-${keyword.day.toString().padLeft(2, '0')}",
      };
}

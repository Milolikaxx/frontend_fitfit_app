// To parse this JSON data, do
//
//     final exerciseSearchByMonthGetRequest = exerciseSearchByMonthGetRequestFromJson(jsonString);

import 'dart:convert';

ExerciseSearchByMonthGetRequest exerciseSearchByMonthGetRequestFromJson(String str) => ExerciseSearchByMonthGetRequest.fromJson(json.decode(str));

String exerciseSearchByMonthGetRequestToJson(ExerciseSearchByMonthGetRequest data) => json.encode(data.toJson());

class ExerciseSearchByMonthGetRequest {
    String numMonth;

    ExerciseSearchByMonthGetRequest({
        required this.numMonth,
    });

    factory ExerciseSearchByMonthGetRequest.fromJson(Map<String, dynamic> json) => ExerciseSearchByMonthGetRequest(
        numMonth: json["num_month"],
    );

    Map<String, dynamic> toJson() => {
        "num_month": numMonth,
    };
}

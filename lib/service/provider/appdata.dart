import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/api/workout_musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';

class AppData with ChangeNotifier {
  //Api baseurl
  // String baseUrl = "http://202.28.34.197:8020";
  String baseUrl = "http://192.168.1.6:8080";
  // String baseUrl = "http://192.168.1.36:8080";

  late UserLoginPostResponse user = UserLoginPostResponse();

  UserService get userService => UserService(Dio(), baseUrl: baseUrl);
   WorkoutMusicTypeService get workoutMusicType => WorkoutMusicTypeService(Dio(), baseUrl: baseUrl);
   WorkoutProfileService get workoutProfile => WorkoutProfileService(Dio(), baseUrl: baseUrl);
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/history_exercise.dart';
import 'package:frontend_fitfit_app/service/api/musictype.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/api/post.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/api/workout_musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';

class AppData with ChangeNotifier {
  //Api baseurl
  String baseUrl = "http://202.28.34.197:8020";
  // String baseUrl = "http://10.160.86.246:8080";
  // String baseUrl = "http://172.20.10.8:8080";
  // String baseUrl = "http://172.16.1.98:8080";

  late UserLoginPostResponse user = UserLoginPostResponse();

  UserService get userService => UserService(Dio(), baseUrl: baseUrl);
  WorkoutMusicTypeService get workoutMusicType =>
      WorkoutMusicTypeService(Dio(), baseUrl: baseUrl);
  WorkoutProfileService get workoutProfileService =>
      WorkoutProfileService(Dio(), baseUrl: baseUrl);
  MusicTypeService get musicTypeService =>
      MusicTypeService(Dio(), baseUrl: baseUrl);
  PlaylistDetailService get playlistDetailService =>
      PlaylistDetailService(Dio(), baseUrl: baseUrl);
  PlaylistService get playlistService =>
      PlaylistService(Dio(), baseUrl: baseUrl);
  PostService get postService => PostService(Dio(), baseUrl: baseUrl);
  HistoryExerciseService get historyExerciseService =>
      HistoryExerciseService(Dio(), baseUrl: baseUrl);
}

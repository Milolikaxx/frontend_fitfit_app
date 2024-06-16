import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/musictype.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/api/workout_musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';

class AppData with ChangeNotifier {
  //Api baseurl
  // String baseUrl = "http://202.28.34.197:8020";
  String baseUrl = "http://192.168.1.5:8080";
  // String baseUrl = "http://192.168.1.44:8080";

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
}

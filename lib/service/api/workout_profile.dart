import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/workoutProfile_post_req.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfileMusicType_get_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/workout_profile.g.dart';

@RestApi()
abstract class WorkoutProfileService {
  factory WorkoutProfileService(Dio dio, {String baseUrl}) =
      _WorkoutProfileService;

  @POST("/workprofile/save")
  Future<int> saveWP(@Body() WorkoutProfilePostRequest saveWp);

  @GET("/workprofile/user/{id}")
  Future<List<WorkoutProfileGetResponse>> getWorkoutProfile(@Path() int id);

  @GET("/workprofile/list/{id}")
  Future<List<WorkoutProfileMusicTypeGetResponse>> getListWorkoutProfile(@Path() int id);
}

import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/service/model/request/workoutProfile_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/workoutProfile_get_res.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/workout_profile.g.dart';

@RestApi()
abstract class WorkoutProfileService {
  factory WorkoutProfileService(Dio dio, {String baseUrl}) =
      _WorkoutProfileService;

  @POST("/workprofile/save")
  Future<int> saveWP(@Body() WorkoutProfilePostRequest saveWp);

  @GET("/workprofile/{id}")
  Future<WorkoutProfileGetResponse> getProfileByWpid(@Path() int id);

  @GET("/workprofile/user/{id}")
  Future<List<WorkoutProfileGetResponse>> getListWorkoutProfileByUid(
      @Path() int id);

  @DELETE("/workprofile/delprofile/{id}")
  Future<int> deleteWorkoutProfileByWpid(@Path() int id);
}

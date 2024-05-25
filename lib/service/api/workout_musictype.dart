import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/workoutMusicType_post_req.dart';

import 'package:retrofit/retrofit.dart';

part 'generated/workout_musictype.g.dart';

@RestApi()
abstract class WorkoutMusicTypeService {
  factory WorkoutMusicTypeService(Dio dio, {String baseUrl}) =
      _WorkoutMusicTypeService;

  @POST("/wpmt/save")
  Future<int> saveWPMT(@Body() WorkoutMusicTypePostRequest saveWpMt);

  //  @GET("/workprofile/user/{id}")
  // Future<List<WorkoutProfileGetResponse>> getMorkoutProfile(@Path() int id);
}

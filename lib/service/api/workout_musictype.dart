import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/workoutMusicType_post_req.dart';
import 'package:frontend_fitfit_app/model/response/workout_profile_musictype_get_res.dart';

import 'package:retrofit/retrofit.dart';

part 'generated/workout_musictype.g.dart';

@RestApi()
abstract class WorkoutMusicTypeService {
  factory WorkoutMusicTypeService(Dio dio, {String baseUrl}) =
      _WorkoutMusicTypeService;

  @POST("/wpmt/save")
  Future<int> saveWPMT(@Body() WorkoutMusicTypePostRequest saveWpMt);

  @GET("/wpmt/{id}")
  Future<List<WorkoutProfileMusictypeGetResponse>> getMusicTypeByWpid(
      @Path() int id);
}

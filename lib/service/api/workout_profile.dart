import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/workoutProfile_post_req.dart';
import 'package:retrofit/retrofit.dart';


part 'generated/workout_profile.g.dart';

@RestApi()
abstract class WorkoutProfileService {
  factory WorkoutProfileService(Dio dio, {String baseUrl}) = _WorkoutProfileService;

  @POST("/workprofile/save")
  Future<int> saveWP(@Body() WorkoutProfilePostRequest saveWp);
  
}

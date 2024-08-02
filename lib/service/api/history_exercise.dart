import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/service/model/request/exercise_post_req.dart';
import 'package:frontend_fitfit_app/service/model/request/exercise_searchbyday_get_req.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_searchbydat_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_showbyday_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_showbymonth_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/historyexercise_get_res.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/history_exercise.g.dart';

@RestApi()
abstract class HistoryExerciseService {
  factory HistoryExerciseService(Dio dio, {String baseUrl}) =
      _HistoryExerciseService;

  @GET("/exercise")
  Future<List<HistoryExerciseGetResponse>> getAllHistoryExercise();

  @GET("/exercise/{id}")
  Future<List<HistoryExerciseGetResponse>> getHisExByUid(@Path() int id);

  @POST("/exercise/addexercise")
  Future<int> addExerciseHistory(@Body() ExercisePostRequest addExercise);

  @PUT("/exercise/edithistory/{id}")
  Future<List<int>> editExerciseHistory(
      @Path() int id, @Body() ExercisePostRequest updateExercise);

  @GET("/exercise/last7day")
  Future<List<ExerciseShowbydayGetResponse>> getLast7Day();

  @GET("/exercise/searchbyday")
  Future<List<ExerciseSearchbydayGetResponse>> searchByday(
      @Body() ExerciseSearchbydayGetRequest searchByDay);

  @GET("/exercise/getmonth")
  Future<List<ExerciseLast12MonthGetResponse>> getlast12month();
}

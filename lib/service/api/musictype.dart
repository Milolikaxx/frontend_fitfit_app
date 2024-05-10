import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/response/musictype_get_res.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/musictype.g.dart';

@RestApi()
abstract class MusicTypeService {
  factory MusicTypeService(Dio dio, {String baseUrl}) =
      _MusicTypeService;

  @GET("/mt")
  //Result ของการเรียกเส้นจะได้มาเป็น  List<TripGetResponse>
  Future<List<MusictypeGetResponse>> getMusictype();
}

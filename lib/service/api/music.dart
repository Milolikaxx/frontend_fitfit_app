import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/service/model/request/search_music_get_req.dart';
import 'package:frontend_fitfit_app/service/model/request/share_playlsit_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/social_all_post_res.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/music.g.dart';

@RestApi()
abstract class MusicService {
  factory MusicService(Dio dio, {String baseUrl}) = _MusicService;

  @GET("/music/search")
  Future<List<MusicGetResponse>> getSearchMusic(
      @Body() SearchMusicGetRequest key);

@GET("/music/findbywp/{id}")
  Future<List<MusicGetResponse>> getMusicByWorkoutProfile(
      @Path() int id);
}

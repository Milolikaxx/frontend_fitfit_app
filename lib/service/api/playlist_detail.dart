import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/playlsit_detail_post_req.dart';
import 'package:frontend_fitfit_app/model/request/rand_music1_post_req.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart' ;

import 'package:retrofit/retrofit.dart';

part 'generated/playlist_detail.g.dart';

@RestApi()
abstract class PlaylistDetailService {
  factory PlaylistDetailService(Dio dio, {String baseUrl}) =
      _PlaylistDetailService;

  @GET("/playlist_detail/musiclist/{id}")
  Future<List<MusicGetResponse>> getMusicDetailGen(
    @Path() int id,
  );
  @GET("/playlist_detail/rand")
  Future<List<MusicGetResponse>> randomMusic(
      @Body() RandMusic1PostRequest randMusic);

  @POST("/playlist_detail/addmusic")
  Future<int> addMusicToPlaylist(@Body() PlaylsitDetailPostRequest addMusic);
}

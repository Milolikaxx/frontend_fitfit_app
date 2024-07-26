import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/service/model/request/playlsit_detail_postUp_req.dart';
import 'package:frontend_fitfit_app/service/model/request/playlsit_detail_post_req.dart';
import 'package:frontend_fitfit_app/service/model/request/rand_music1_post_req.dart';
import 'package:frontend_fitfit_app/service/model/request/rand_one_song_of_playlist_req.dart';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart' ;
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart';

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

  @GET("/playlist_detail/rand1song")
  Future<List<PlaylistDetail>> random1song(
      @Body() RandOneSongOfPlaylistRequest randMusicOfPlaylist);
  @POST("/playlist_detail/addmusic")
  Future<int> addMusicToPlaylist(@Body() PlaylsitDetailPostRequest addMusic);

  @POST("/playlist_detail/update")
  Future<int> update(@Body() PlaylsitDetailPostUpdateRequest upMusic);
}

import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/service/model/request/playlist_put_req.dart';
import 'package:frontend_fitfit_app/service/model/request/playlsit_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:retrofit/retrofit.dart';

part 'generated/playlist.g.dart';

@RestApi()
abstract class PlaylistService {
  factory PlaylistService(Dio dio, {String baseUrl}) = _PlaylistService;

  @POST("/playlist/save")
  Future<int> addPlaylsit(@Body() PlaylsitPostRequest add);

  @GET("/playlist/wp/{id}")
  Future<List<PlaylistWithWorkoutGetResponse>> getPlaylistByWpid(
    @Path() int id,
  );
  @GET("/playlist/{id}")
  Future<PlaylsitMusicGetResponse> getPlaylistMusicByPid(
    @Path() int id,
  );
@GET("/playlist/nomusic/{id}")
  Future<PlaylistWithWorkoutGetResponse> getPlaylistWithOutMusicByPid(
    @Path() int id,
  );

  @PUT("/playlist/update/{id}")
  Future<int> editPlaylist(
    @Path() int id, @Body() PlaylsitPutRequest edit
  );

  @DELETE("/playlist/del/{id}")
  Future<int> deletePlaylsit(@Path() int id);
}

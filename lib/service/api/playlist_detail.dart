import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';

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
}

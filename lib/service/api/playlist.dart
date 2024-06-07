import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/playlsit_post_req.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';

import 'package:retrofit/retrofit.dart';

part 'generated/playlist.g.dart';

@RestApi()
abstract class PlaylistService {
  factory PlaylistService(Dio dio, {String baseUrl}) =
      _PlaylistService;

  @POST("/playlist/save")
  Future<int> addPlaylsit(
     @Body() PlaylsitPostRequest add
  );
}

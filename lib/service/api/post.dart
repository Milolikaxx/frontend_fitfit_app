import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/share_playlsit_post_req.dart';
import 'package:retrofit/retrofit.dart';


part 'generated/post.g.dart';

@RestApi()
abstract class PostService {
  factory PostService(Dio dio, {String baseUrl}) = _PostService;

  @POST("/post/save")
  Future<int> addPost(@Body() SharePlaylsitPostRequest add);

  
}

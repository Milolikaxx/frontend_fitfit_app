import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/share_playlsit_post_req.dart';
import 'package:frontend_fitfit_app/model/response/social_all_post_res.dart';
import 'package:retrofit/retrofit.dart';


part 'generated/post.g.dart';

@RestApi()
abstract class PostService {
  factory PostService(Dio dio, {String baseUrl}) = _PostService;

  @POST("/post/save")
  Future<int> addPost(@Body() SharePlaylsitPostRequest add);

  @GET("/post/")
  Future<List<SocialAllPostResonse>> getPostAll();

  @GET("/post/{id}")
  Future<List<SocialAllPostResonse>> getPostByUid(@Path() int id);
}

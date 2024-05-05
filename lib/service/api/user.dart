import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/user_register_post_req.dart';
import 'package:retrofit/retrofit.dart';
import 'package:frontend_fitfit_app/model/request/user_login_post_req.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/request/user_edit_put_req.dart';

part 'generated/user.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @POST("/user/login")
  Future<UserLoginPostResponse> login(@Body() UserLoginPostRequest user);

  @PUT("/user/update/{id}")
  Future<UserLoginPostResponse> edit(
      @Body() UserEditPutRequest edituser, @Path() int id);

  @POST("/user/register")
  Future<int> register(@Body() UserRegisterPostRequest userRegister);
}

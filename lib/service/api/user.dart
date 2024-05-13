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
  Future<UserLoginPostResponse> login(@Body() UserLoginPostRequest userLogin);

  @PUT("/user/update/{id}")
  Future<int> edit(@Path() int id, @Body() UserEditPutRequest edituser);

  @PUT("/user/updatepassword/{id}")
  Future<int> editPassword(@Path() int id, @Body() UserEditPutRequest edituser);

  @POST("/user/register")
  Future<int> register(@Body() UserRegisterPostRequest userRegister);
}

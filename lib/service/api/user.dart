import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/service/model/request/user_login%20google_req.dart';
import 'package:frontend_fitfit_app/service/model/request/user_register_post_req.dart';
import 'package:retrofit/retrofit.dart';
import 'package:frontend_fitfit_app/service/model/request/user_login_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/model/request/user_edit_put_req.dart';
import 'package:frontend_fitfit_app/service/model/request/user_editpassword_post_req.dart';

part 'generated/user.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @POST("/user/login")
  Future<UserLoginPostResponse> login(@Body() UserLoginPostRequest userLogin);

  @POST("/user/loginGoogle")
  Future<UserLoginPostResponse> loginGoogle(@Body() UserLoginGooglePostRequest userLoginGoogle);

  @PUT("/user/update/{id}")
  Future<UserLoginPostResponse> edit(@Path() int id, @Body() UserEditPutRequest edituser);

  @POST("/user/updatepassword/{id}")
  Future<int> editPassword(
      @Path() int id, @Body() UserEditPasswordPostRequest edituser);

  @POST("/user/register")
  Future<int> register(@Body() UserRegisterPostRequest userRegister);
}





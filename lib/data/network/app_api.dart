import "package:retrofit/http.dart";
import "package:dio/dio.dart";

import "../../app/constant.dart";
import "../responses/responses.dart";

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/auth/login')
  Future<AuthenticationResponse> login(
      @Field("email") String email,
      @Field("password") String password,
      @Field("imei") String imei,
      @Field("deviceType") String deviceType);

  @POST('/auth/forgot-password')
  Future<ForgotPasswordResponse> forgotPassword(@Field("email") String email);

  @POST('/auth/register')
  Future<AuthenticationResponse> register({
    @Field("country_mobile_code") required String countryMobileCode,
    @Field("user_name") required String userName,
    @Field("email") required String email,
    @Field("password") required String password,
    @Field("mobile_number") required String mobileNumber,
    @Field("profile_picture") required String profilePicture,
  });

  @GET('/home')
  Future<HomeResponse> getHome();
}

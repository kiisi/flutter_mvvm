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
}
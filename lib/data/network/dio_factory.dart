import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/constant.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  Future<Dio> getDio() async {
    Dio dio = Dio();
    const Duration timeout = Duration(milliseconds: 60 * 1000);

    Map<String, dynamic> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constant.token,
      DEFAULT_LANGUAGE: "en" // get language from app preference
    };

    dio.options = BaseOptions(
        baseUrl: Constant.baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        headers: headers);

    if (kReleaseMode) {
      print("Release mode no logs");
    } else {
      dio.interceptors.add(PrettyDioLogger(
          requestBody: true, requestHeader: true, responseBody: true));
    }

    return dio;
  }
}

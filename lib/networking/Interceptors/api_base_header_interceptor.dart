import 'package:dio/dio.dart';

import '../api_constant.dart';

class BaseHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiParam.CONTENT_TYPE] = ApiParam.APPLICATION_JSON;
    options.headers[ApiParam.ACCEPT] = ApiParam.APPLICATION_JSON;
    options.headers[ApiParam.ACCEPT_LANGUAGE] = "en";

    return super.onRequest(options, handler);
  }
}

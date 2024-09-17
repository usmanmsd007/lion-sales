import 'dart:convert';

import 'package:dio/dio.dart';

import 'Interceptors/api_base_authorization_header_interceptor.dart';
import 'Interceptors/api_base_connectivity_interceptor.dart';
import 'Interceptors/api_base_header_interceptor.dart';
import 'api_constant.dart';

export 'api_constant.dart';
export 'api_exceptions.dart';
export 'api_response.dart';

Dio getDio() {
  final Dio dio = Dio();

  dio.options.baseUrl = BaseUrl.baseUrlProduction;
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  dio.interceptors.add(ConnectivityInterceptor());
  dio.interceptors.add(BaseHeaderInterceptor());
  dio.interceptors.add(AuthorizationHeaderInterceptor());
  return dio;
}

class ApiBaseHelper {
  final Dio _dio = getDio();

  Future<dynamic> get(String url,
      {Map<String, dynamic> params = const {}}) async {
    return await _dio.get(url, queryParameters: params);
  }

  Future<dynamic> post(String url, {dynamic body}) async {
    return await _dio.post(url, data: jsonEncode(body));
  }

  Future<dynamic> delete(String url) async {
    return await _dio.delete(url);
  }

/*

dynamic _returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
      return response.data;
    case 400:
      throw BadRequestException(response.data.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.data.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

String _handleError(dynamic error) {
  String errorDescription = "";
  if (error is DioException) {
    DioException dioError = error;
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorDescription = "languages.apiErrorCancelMsg";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "languages.apiErrorConnectTimeoutMsg";
        break;
      case DioExceptionType.unknown:
        errorDescription = "languages.apiErrorOtherMsg";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "languages.apiErrorReceiveTimeoutMsg";
        break;
      case DioExceptionType.badResponse:
        errorDescription =
            "{languages.apiErrorResponseMsg}: ${dioError.response?.statusCode}";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "languages.apiErrorSendTimeoutMsg";
        break;
      case DioExceptionType.badCertificate:
        errorDescription =
            "{languages.apiErrorResponseMsg}: ${dioError.response?.statusCode}";
        break;
      default:
        errorDescription = "languages.apiErrorOtherMsg";
        break;
    }
  } else {
    errorDescription = "languages.apiErrorUnexpectedErrorMsg";
  }
  return errorDescription;
}
*/
}

import 'package:dio/dio.dart';

import '../../main.dart';
import '../../routes/app_routes.dart';
import '../../utils/constant_strings.dart';
import '../../utils/flutter_secure_storage_utils.dart';
import '../api_constant.dart';

/// Handle Authorization header
class AuthorizationHeaderInterceptor extends Interceptor {
  Future<String?> getToken() async {
    return await AppEncryptedStorage().readItem(key: ConstantStrings.TOKEN_KEY);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[ApiParam.ACCEPT] = ApiParam.APPLICATION_JSON;
    await getToken().then((value) {
      if (value != null && value != "") {
        options.headers[ApiParam.AUTHORIZATION] = "${ApiParam.BEARER} $value";
      }
    });
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // remove any key that might be present
      AppEncryptedStorage().deleteItem(key: ConstantStrings.TOKEN_KEY);

      navigatorKey.currentState!
          .pushNamedAndRemoveUntil(AppRoutes.DEFAULT, (route) => false);
    }
    return super.onError(err, handler);
  }
}

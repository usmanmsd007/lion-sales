import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../utils/constant_strings.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Fluttertoast.showToast(
      //     msg: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE);
      throw DioException(
        error: ConstantStrings.INTERNET_CONNECTION_LOST_TITLE,
        requestOptions: options,
      );
    }
    return super.onRequest(options, handler);
  }
}

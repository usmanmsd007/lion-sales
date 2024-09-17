import 'package:lion_sales/networking/api_base_helper.dart';

class SplashRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getApiVersion() async {
 

    return await _apiBaseHelper.get(ApiEndPoints.ApiVersion, );
  }
}
import '../../../networking/api_base_helper.dart';

class SettingRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> logout() async {
    return await _apiBaseHelper.post(
      ApiEndPoints.Logout,
    );
  }
}

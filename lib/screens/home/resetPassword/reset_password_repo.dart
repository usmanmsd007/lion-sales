import '../../../networking/api_base_helper.dart';

class ResetPasswordRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> resetPassword(String email, String oldPassword,
      String newPassword, String confirmPassword) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.OLD_PASSWORD] = oldPassword;
    body[ApiParam.NEW_PASSWORD] = newPassword;
    body[ApiParam.NEW_CONFIRM_PASSWORD] = confirmPassword;
    body[ApiParam.EMAIL] = email;

    return await _apiBaseHelper.post(ApiEndPoints.RESET_PASSWORD, body: body);
  }

  Future<dynamic> logout() async {
    return await _apiBaseHelper.post(
      ApiEndPoints.Logout,
    );
  }
}

import '../../../networking/api_base_helper.dart';

class ForgetPasswordRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> forgetPassword({required String email}) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.EMAIL] = email;

    return await _apiBaseHelper.post(ApiEndPoints.ForgetPassword, body: body);
  }

  Future<dynamic> changePassword(
      String password, String confirmPassword, String email, String otp) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PASSWORD] = password;
    body[ApiParam.CONFIRM_PASSWORD] = confirmPassword;
    body[ApiParam.EMAIL] = email;
    body[ApiParam.OTP] = otp;

    return await _apiBaseHelper.post(ApiEndPoints.ResetPassword, body: body);
  }

  Future<dynamic> verifyOtp(String otp, String email) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.OTP] = otp;

    body[ApiParam.EMAIL] = email;

    return await _apiBaseHelper.post(ApiEndPoints.VerifyOtp, body: body);
  }
}

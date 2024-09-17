import '../../../networking/api_base_helper.dart';

class RegisterRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> register(
      String firstName, String lastName, String email, String password) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.EMAIL] = email;
    body[ApiParam.PASSWORD] = password;
    body[ApiParam.FIRST_NAME] = firstName;
    body[ApiParam.LAST_NAME] = lastName;

    return await _apiBaseHelper.post(ApiEndPoints.Register, body: body);
  }
}

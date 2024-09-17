import 'package:lion_sales/blocs/bloc.dart';

class LoginRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> login(
      {required String email, required String password}) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.EMAIL] = email;
    body[ApiParam.PASSWORD] = password;

    return await _apiBaseHelper.post(ApiEndPoints.Login, body: body);
  }
}

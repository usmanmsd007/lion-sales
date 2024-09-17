import '../../../networking/api_base_helper.dart';

class TotalProductRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getAllProducts() async {
    return await _apiBaseHelper.get(
      ApiEndPoints.Total_Products,
    );
  }
}

import '../../../networking/api_base_helper.dart';

class OrderRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getOrderList() async {
    return await _apiBaseHelper.get(
      ApiEndPoints.Order_List,
    );
  }
}

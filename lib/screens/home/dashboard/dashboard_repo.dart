 

import '../../../networking/api_base_helper.dart';

class DashboardRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getTotalOrder() async {
   

    return await _apiBaseHelper.get(
      ApiEndPoints.Total_Orders,
    );
  }

  Future<dynamic> getTotalProduct() async {
    
    return await _apiBaseHelper.get(
      ApiEndPoints.Total_Porducts_New,
    );
  }
}

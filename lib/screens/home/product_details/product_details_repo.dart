import '../../../networking/api_base_helper.dart';

class ProductDetailRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getProductDetails(int productId) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PRODUCT_ID] = productId.toString();

    return await _apiBaseHelper.post(
      ApiEndPoints.Product_Details,
      body: body,
    );
  }

  Future<dynamic> addToCart(int productId) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PRODUCT_ID] = productId.toString();

    return await _apiBaseHelper.post(
      ApiEndPoints.Add_To_Cart,
      body: body,
    );
  }
  
  Future<dynamic> getCartList() async {
    return await _apiBaseHelper.get(
      ApiEndPoints.Cart_List,
    );
  }
}

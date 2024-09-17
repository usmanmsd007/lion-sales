import '../../../networking/api_base_helper.dart';

class CartRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> sendOrder(int orderId, List<Map<String, int>> products,
      int? userId, String desc) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.ORDER_ID] = orderId.toString();
    body[ApiParam.ORDER_PRODUCTS] = products;
    body[ApiParam.DESCRIPTION] = desc;
    if (userId != null) {
      body[ApiParam.USER_ID] = userId;
    }

    return await _apiBaseHelper.post(
      ApiEndPoints.Send_Order,
      body: body,
    );
  }

  Future<dynamic> getCartList() async {
    return await _apiBaseHelper.get(
      ApiEndPoints.Cart_List,
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

  Future<dynamic> decrementProductFromCart(int productId) async {
    final Map<String, dynamic> body = <String, dynamic>{};

    body[ApiParam.PRODUCT_ID] = productId.toString();

    return await _apiBaseHelper.post(
      ApiEndPoints.Remove_From_Cart,
      body: body,
    );
  }

  Future<dynamic> removeProductFromCart(int productId) async {
    final Map<String, dynamic> body = <String, dynamic>{};

    body[ApiParam.PRODUCT_ID] = productId.toString();

    return await _apiBaseHelper.post(
      ApiEndPoints.Remove_Product_From_Product,
      body: body,
    );
  }

  Future<dynamic> clearCart() async {
    return await _apiBaseHelper.post(
      ApiEndPoints.Clear_Cart,
    );
  }
}

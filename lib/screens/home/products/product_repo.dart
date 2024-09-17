import '../../../networking/api_base_helper.dart';

class ProductRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
//
  Future<dynamic> getProducts(int pageNo) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PAGE_NO] = pageNo;
    return await _apiBaseHelper.post(ApiEndPoints.All_Products, body: body);
  }

  Future<dynamic> searchProducts(
      int pageNo, String text, List<int> categories) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PAGE_NO] = pageNo;
    body["category_id"] = categories;
    body[ApiParam.SEARCH_TITLE] = text;
    return await _apiBaseHelper.post(ApiEndPoints.Search_Products, body: body);
  }

  Future<dynamic> addToCart(int productId) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PRODUCT_ID] = productId.toString();

    return await _apiBaseHelper.post(
      ApiEndPoints.Add_To_Cart,
      body: body,
    );
  }

  Future<dynamic> getCategories() async {
    return await _apiBaseHelper.get(
      ApiEndPoints.Categories,
    );
  }

  Future<dynamic> addToCartWithQuantity(int productId, int quantity) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PRODUCT_ID] = productId.toString();
    body["quantity"] = quantity;

    return await _apiBaseHelper.post(
      ApiEndPoints.Add_To_Cart,
      body: body,
    );
  }

  Future<dynamic> removeFromCart(int productId) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.PRODUCT_ID] = productId.toString();

    return await _apiBaseHelper.post(
      ApiEndPoints.Remove_From_Cart,
      body: body,
    );
  }
}

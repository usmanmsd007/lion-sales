import '../../../networking/api_base_helper.dart';

class InvoiceRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> getInvoice(int orderId) async {
    final Map<String, dynamic> body = <String, dynamic>{};
    body[ApiParam.ORDER_ID] = orderId.toString();

    return await _apiBaseHelper.post(ApiEndPoints.Invoice_Details, body: body);
  }
}

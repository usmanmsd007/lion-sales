import 'package:intl/intl.dart';

class InvoiceModel {
  final String status;
  final int statusCode;
  final InvoiceData data;

  InvoiceModel({
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        status: json["status"],
        statusCode: json["status_code"],
        data: InvoiceData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

class InvoiceData {
  final String userName;
  final DateTime orderUpdateDate;
  final int totalQuantity;
  final double totalPrice;
  final List<Product> products;

  InvoiceData({
    required this.userName,
    required this.orderUpdateDate,
    required this.totalQuantity,
    required this.totalPrice,
    required this.products,
  });

  String convertDateFormat(DateTime dateTime) {
    // Format the DateTime object to the desired format.
    final formattedDate = DateFormat('MM-dd-yyyy hh:mm a').format(dateTime);

    // Return the formatted date.
    return formattedDate;
  }

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        userName: json["user_name"],
        orderUpdateDate: DateTime.parse(json["order_update_date"]),
        totalQuantity: json["total_quantity"],
        totalPrice: json["total_price"]?.toDouble(),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "order_update_date": orderUpdateDate.toIso8601String(),
        "total_quantity": totalQuantity,
        "total_price": totalPrice,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  final int productId;
  final String productTitle;
  final int productQuantity;
  final String upc;
  final double price;

  final double productTotalPrice;

  Product({
    required this.productId,
    required this.productTitle,
    required this.productQuantity,
    required this.upc,
    required this.price,
    required this.productTotalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        productTitle: json["product_title"],
        productQuantity: json["product_quantity"],
        upc: json["upc"],
        price: double.parse(json["price"].toString()),
        productTotalPrice: json["product_total_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_title": productTitle,
        "product_quantity": productQuantity,
        "upc": upc,
        "price": price,
        "product_total_price": productTotalPrice,
      };
}

// class InvoiceModel {
//   final String status;
//   final int statusCode;
//   final InvoiceData data;
//
//   InvoiceModel({
//     required this.status,
//     required this.statusCode,
//     required this.data,
//   });
//
//   factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
//         status: json["status"],
//         statusCode: json["status_code"],
//         data: InvoiceData.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "status_code": statusCode,
//         "data": data.toJson(),
//       };
// }
//
// class InvoiceData {
//   final String userName;
//   final DateTime orderUpdateDate;
//   final int totalQuantity;
//   final double totalPrice;
//   final List<Product> products;
//
//   InvoiceData({
//     required this.userName,
//     required this.orderUpdateDate,
//     required this.totalQuantity,
//     required this.totalPrice,
//     required this.products,
//   });
//
//   factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
//         userName: json["user_name"],
//         orderUpdateDate: DateTime.parse(json["order_update_date"]),
//         totalQuantity: json["total_quantity"],
//         totalPrice: json["total_price"]?.toDouble(),
//         products: List<Product>.from(
//             json["products"].map((x) => Product.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "user_name": userName,
//         "order_update_date": orderUpdateDate.toIso8601String(),
//         "total_quantity": totalQuantity,
//         "total_price": totalPrice,
//         "products": List<dynamic>.from(products.map((x) => x.toJson())),
//       };
// }
//
// class Product {
//   final int id;
//   final String productTitle;
//   final int productQuantity;
//   final String upc;
//   final String price;
//   final double productTotalPrice;
//
//   Product({
//     required this.id,
//     required this.productTitle,
//     required this.productQuantity,
//     required this.upc,
//     required this.price,
//     required this.productTotalPrice,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         productTitle: json["product_title"],
//         id: json['id'],
//         productQuantity: json["product_quantity"],
//         upc: json["upc"],
//         price: json["price"],
//         productTotalPrice: json["product_total_price"]?.toDouble(),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "product_title": productTitle,
//         "product_quantity": productQuantity,
//         "upc": upc,
//         'id': this.id,
//         "price": price,
//         "product_total_price": productTotalPrice,
//       };
// }

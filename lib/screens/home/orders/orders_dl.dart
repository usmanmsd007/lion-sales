// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  final String status;
  final int statusCode;
  final List<OrderModel> orderListData;

  OrderListModel({
    required this.status,
    required this.statusCode,
    required this.orderListData,
  });

  OrderListModel copyWith({
    String? status,
    int? statusCode,
    List<OrderModel>? orderListData,
  }) =>
      OrderListModel(
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode,
        orderListData: orderListData ?? this.orderListData,
      );

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        status: json["status"],
        statusCode: json["status_code"],
        orderListData: List<OrderModel>.from(
            json["order_list_data"].map((x) => OrderModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "order_list_data":
            List<dynamic>.from(orderListData.map((x) => x.toJson())),
      };
}

class OrderModel {
  final int orderId;
  final double totalAmount;
  final String userName;
  final OderStatus status;

  OrderModel({
    required this.orderId,
    required this.totalAmount,
    required this.userName,
    required this.status,
  });

  OrderModel copyWith({
    int? orderId,
    double? totalAmount,
    String? userName,
    OderStatus? status,
  }) =>
      OrderModel(
        orderId: orderId ?? this.orderId,
        totalAmount: totalAmount ?? this.totalAmount,
        userName: userName ?? this.userName,
        status: status ?? this.status,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["order_id"] ?? "N/A",
        totalAmount: json["total_amount"]?.toDouble() ?? "N/A",
        userName: json["user_name"] ?? "N/A",
        status: OderStatus.fromJson(json["status"] ?? "N/A"),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total_amount": totalAmount,
        "user_name": userName,
        "status": status.toJson(),
      };
}

class OderStatus {
  final int id;
  final String name;

  OderStatus({
    required this.id,
    required this.name,
  });

  OderStatus copyWith({
    int? id,
    String? name,
  }) =>
      OderStatus(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory OderStatus.fromJson(Map<String, dynamic> json) => OderStatus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// class OrderListModel {
//   final String status;
//   final int statusCode;
//   final List<OrderModel> orderListData;

//   OrderListModel({
//     required this.status,
//     required this.statusCode,
//     required this.orderListData,
//   });

//   factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
//         status: json["status"],
//         statusCode: json["status_code"],
//         orderListData: List<OrderModel>.from(
//             json["order_list_data"].map((x) => OrderModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "status_code": statusCode,
//         "order_list_data":
//             List<dynamic>.from(orderListData.map((x) => x.toJson())),
//       };
// }

// class OrderModel {
//   final int orderId;
//   final double totalAmount;
//   final String userName;

//   OrderModel({
//     required this.orderId,
//     required this.totalAmount,
//     required this.userName,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
//         orderId: json["order_id"],
//         totalAmount: json["total_amount"]?.toDouble(),
//         userName: json["user_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "order_id": orderId,
//         "total_amount": totalAmount,
//         "user_name": userName,
//       };
// }

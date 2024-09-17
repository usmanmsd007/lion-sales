// class CartListModel {
//   final String status;
//   final int statusCode;
//   final List<CartModel> cartList;

//   CartListModel({
//     required this.status,
//     required this.statusCode,
//     required this.cartList,
//   });

//   factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
//         status: json["status"],
//         statusCode: json["status_code"],
//         cartList: List<CartModel>.from(
//             json["cart_list"].map((x) => CartModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "status_code": statusCode,
//         "cart_list": List<dynamic>.from(cartList.map((x) => x.toJson())),
//       };
// }

// class CartModel {
//   final int orderId;
//   final List<CartProduct> products;

//   CartModel({
//     required this.orderId,
//     required this.products,
//   });

//   factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
//         orderId: json["order_id"],
//         products: List<CartProduct>.from(
//             json["products"].map((x) => CartProduct.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "order_id": orderId,
//         "products": List<dynamic>.from(products.map((x) => x.toJson())),
//       };
// }

// class CartProduct {
//   final int productId;
//   final String productName;
//   final int quantity;
//   final double amount;
//   final String imagePath;

//   CartProduct({
//     required this.productId,
//     required this.productName,
//     required this.quantity,
//     required this.amount,
//     required this.imagePath,
//   });

//   factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
//         productId: json["product_id"],
//         productName: json["product_name"],
//         quantity: json["quantity"],
//         amount: json["amount"]?.toDouble(),
//         imagePath: json["image_path"],
//       );

//   Map<String, dynamic> toJson() => {
//         "product_id": productId,
//         "product_name": productName,
//         "quantity": quantity,
//         "amount": amount,
//         "image_path": imagePath,
//       };
// }

class CartListModel {
  String status;
  int statusCode;
  List<CartUser> usersList;
  List<CartList> cartList;

  CartListModel({
    required this.status,
    required this.statusCode,
    required this.usersList,
    required this.cartList,
  });

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
        status: json["status"],
        statusCode: json["status_code"],
        usersList: List<CartUser>.from(
            json["users_list"].map((x) => CartUser.fromJson(x))),
        cartList: List<CartList>.from(
            json["cart_list"].map((x) => CartList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "users_list": List<dynamic>.from(usersList.map((x) => x.toJson())),
        "cart_list": List<dynamic>.from(cartList.map((x) => x.toJson())),
      };
}

class CartList {
  int orderId;
  List<CartProduct> products;

  CartList({
    required this.orderId,
    required this.products,
  });

  factory CartList.fromJson(Map<String, dynamic> json) => CartList(
        orderId: json["order_id"],
        products: List<CartProduct>.from(
            json["products"].map((x) => CartProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class CartProduct {
  int authenticatedUserId;
  int productId;
  String productName;
  int quantity;
  double amount;
  String imagePath;

  CartProduct({
    required this.authenticatedUserId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.imagePath,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        authenticatedUserId: json["authenticated_user_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        amount: json["amount"]?.toDouble(),
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "authenticated_user_id": authenticatedUserId,
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "amount": amount,
        "image_path": imagePath,
      };
}

class CartUser {
  int id;
  String name;

  CartUser({
    required this.id,
    required this.name,
  });

  factory CartUser.fromJson(Map<String, dynamic> json) => CartUser(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ClearCartModel {
  String status;
  int statusCode;
  String message;

  ClearCartModel({
    required this.status,
    required this.statusCode,
    required this.message,
  });

  factory ClearCartModel.fromJson(Map<String, dynamic> json) => ClearCartModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
      };
}

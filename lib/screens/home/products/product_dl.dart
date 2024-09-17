// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);
import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final String status;
  final int statusCode;
  final List<AllProductModel> allProducts;

  ProductModel({
    required this.status,
    required this.statusCode,
    required this.allProducts,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        status: json["status"],
        statusCode: json["status_code"],
        allProducts: List<AllProductModel>.from(
            json["all_products"].map((x) => AllProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "all_products": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class AllProductModel {
  final int id;
  final String title;
  final String price;
  final String imagePath;
  int quantity;

  AllProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });
  incrementQuantity() {
    quantity++;
  }

  decrementQuantity() {
    quantity--;
  }

  factory AllProductModel.fromJson(Map<String, dynamic> json) =>
      AllProductModel(
          id: json["id"],
          title: json["title"],
          price: json["price"],
          imagePath: json["image_path"],
          quantity: json["cart_quantity"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "image_path": imagePath,
        "cart_quantity": quantity,
      };
}

class Categories {
  String status;
  int statusCode;
  List<Category> categories;

  Categories({
    required this.status,
    required this.statusCode,
    required this.categories,
  });

  Categories copyWith({
    String? status,
    int? statusCode,
    List<Category>? categories,
  }) =>
      Categories(
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode,
        categories: categories ?? this.categories,
      );

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        status: json["status"],
        statusCode: json["status_code"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  int id;
  String name;
  String path;
  bool isSelected;

  Category({
    this.isSelected = false,
    required this.id,
    required this.name,
    required this.path,
  });

  Category copyWith({
    int? id,
    bool? isSelected,
    String? name,
    String? path,
  }) =>
      Category(
        id: id ?? this.id,
        isSelected: isSelected ?? this.isSelected,
        name: name ?? this.name,
        path: path ?? this.path,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        path: json["path"] ??
            "https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.svg",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "path": path,
      };
}

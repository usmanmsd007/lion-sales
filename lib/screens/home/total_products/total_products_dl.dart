class TotalProductsModel {
  final String status;
  final int statusCode;
  final List<Product> products;

  TotalProductsModel({
    required this.status,
    required this.statusCode,
    required this.products,
  });

  factory TotalProductsModel.fromJson(Map<String, dynamic> json) =>
      TotalProductsModel(
        status: json["status"],
        statusCode: json["status_code"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  final int id;
  final String title;
  final String price;
  final String imagePath;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "image_path": imagePath,
      };
}

class ProductDetailModel {
  final String status;
  final int statusCode;
  final ProductDetail productDetail;

  ProductDetailModel({
    required this.status,
    required this.statusCode,
    required this.productDetail,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        status: json["status"],
        statusCode: json["status_code"],
        productDetail: ProductDetail.fromJson(json["product_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "product_detail": productDetail.toJson(),
      };
}

class ProductDetail {
  final int id;
  final String title;
  final String upc;
  final String price;
  final String sap;
  final String ac;
  final String srp;
  final String size;
  final String prodCase;
  final String pallet;
  final String layer;
  final String weight;
  final String dimension;
  final String companyName;
  final String imagePath;

  ProductDetail({
    required this.id,
    required this.title,
    required this.upc,
    required this.price,
    required this.sap,
    required this.ac,
    required this.srp,
    required this.size,
    required this.prodCase,
    required this.pallet,
    required this.layer,
    required this.weight,
    required this.dimension,
    required this.companyName,
    required this.imagePath,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"],
        title: json["title"],
        upc: json["upc"],
        price: json["price"],
        sap: json["sap"],
        ac: json["ac"],
        srp: json["srp"],
        size: json["size"],
        prodCase: json["prod_case"],
        pallet: json["pallet"],
        layer: json["layer"],
        weight: json["weight"],
        dimension: json["dimension"],
        companyName: json["company_name"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "upc": upc,
        "price": price,
        "sap": sap,
        "ac": ac,
        "srp": srp,
        "size": size,
        "prod_case": prodCase,
        "pallet": pallet,
        "layer": layer,
        "weight": weight,
        "dimension": dimension,
        "company_name": companyName,
        "image_path": imagePath,
      };
}

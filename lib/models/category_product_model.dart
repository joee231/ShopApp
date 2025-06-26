class CategoryProductModel {
  bool? status;
  String? message;
  List<CatData>? data;


  CategoryProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CatData>[];
      json['data'].forEach((v) {
        data!.add(new CatData.fromJson(v));
      });
    }
  }

}

class CatData {
  int? id;
  int? price;
  int? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  late int cat_id;

  CatData(
      {this.id,
        this.price,
        this.oldPrice,
        this.discount,
        this.image,
        this.name,
        this.description,
        required this.cat_id
      });

  CatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    cat_id = json['category_id'] ?? 0; // Default to 0 if not present
  }

}

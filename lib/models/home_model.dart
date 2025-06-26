class HomeModel {
  late bool status;

  late HomeDataModel data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      json['banners'].forEach((element) {
        banners.add(BannerModel.fromJson(element)); // ✅ Parse into BannerModel
      });
    }

    if (json['products'] != null) {
      json['products'].forEach((element) {
        products.add(ProductModel.fromJson(element)); // ✅ Parse into ProductModel
      });
    }
  }
}
class BannerModel {
  late int id;
  late String image;

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel {
  late int id;

  late dynamic price;

  late dynamic old_price;

  late dynamic discount;

  late String image;

  late String name;

  late bool in_favorites;

  late bool in_cart;

  late int cat_id;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    in_favorites = json['in_favorites'];
    in_cart = json['in_cart'];
    cat_id = json['category_id'];
  }
}

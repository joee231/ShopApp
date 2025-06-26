class CartModel {
  late bool status;
  late String message;
  late Data data;


  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

}

class Data {
  int? currentPage;
  List<CartData>? data;

  List<Promocodes>? promocodes;


  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <CartData>[];
      json['data'].forEach((v) {
        data!.add(new CartData.fromJson(v));
      });
    }
    if (json['promocodes'] != null) {
      promocodes = <Promocodes>[];
      json['promocodes'].forEach((v) {
        promocodes!.add(new Promocodes.fromJson(v));
      });
    }
  }

}

class CartData {
  int? id;
  CartProduct? data;


  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data =
     CartProduct.fromJson(json['product']);
  }

}

class CartProduct {
  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  late  String image;
  String? name;
  String? description;

  late int quantity = 1;

  CartProduct(
      {this.id,
        this.price,
        this.oldPrice,
        this.discount,
        required this.image,
        this.name,
        this.description,
        required this.quantity});

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    quantity = json['quantity'] ?? 1; // Default to 1 if quantity is not provided
  }

}
class Promocodes {
  String? code;
  int? discountPercent;
  String? description;

  Promocodes({this.code, this.discountPercent, this.description});
  Promocodes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    discountPercent = json['discount_percent'];
    description = json['description'];
  }
}
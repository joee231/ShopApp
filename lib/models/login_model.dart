class ShopLoginModel {
  late bool status;
  late String message;
  late UserData data;

  ShopLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['meessage'] ?? json['message'] ?? '';
    data = UserData.fromJson(json['data'] ?? {});
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  double? credit;
  String? access_token;
  String? tokenType;
  List? addresses;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = (json['credit'] as num?)?.toDouble();
    access_token = json['access_token'];
    tokenType = json['token_type'];
    addresses = json['addresses'];
  }
}

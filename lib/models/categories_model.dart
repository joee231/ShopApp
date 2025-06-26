class CategoriesModel {
  late bool status;
  late CategoriesDataModel data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  int? currentPage;
  List<DataModel>? data;

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page']; // ✅ fixed typo from current_Page
    data = (json['data'] as List<dynamic>)
        .map((e) => DataModel.fromJson(e))
        .toList();
  }
}

class DataModel {
  late int id;
  late String name;
  late String image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    image = json['image'] ?? '';
  }
}

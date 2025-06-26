class ChangeCartModel
{
  late bool status;

  late String message;

  ChangeCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    message = json['message'] ?? '';
  }
}
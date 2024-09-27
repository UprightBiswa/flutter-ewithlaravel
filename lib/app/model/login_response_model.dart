// login_response_model.dart
class LoginResponseModel {
  final bool success;
  final String token;
  final String message;

  LoginResponseModel({
    required this.success,
    required this.token,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      token: json['token'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

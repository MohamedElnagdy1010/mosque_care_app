class LoginResponseModel {
  const LoginResponseModel({
    required this.token,
    required this.email,
    required this.nicename,
    required this.displayName,
  });

  final String token;
  final String email;
  final String nicename;
  final String displayName;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];

    if (token is! String || token.trim().isEmpty) {
      throw const FormatException('رد تسجيل الدخول لا يحتوي على توكن صالح.');
    }

    return LoginResponseModel(
      token: token,
      email: json['user_email'] as String? ?? '',
      nicename: json['user_nicename'] as String? ?? '',
      displayName: json['user_display_name'] as String? ?? '',
    );
  }
}

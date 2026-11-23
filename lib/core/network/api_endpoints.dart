class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = 'https://wordpress.aait-sa.com/khadm-ele/wp-json/';

  static const login = 'khadim/v1/auth/login';
  static const logout = 'khadim/v1/auth/logout';

  static const profile = 'khadim/v1/me';
  static const mosques = 'khadim/v1/mosques';
  static const catalog = 'khadim/v1/catalog';
  static const requests = 'khadim/v1/requests';
  static const statistics = 'khadim/v1/statistics';
}

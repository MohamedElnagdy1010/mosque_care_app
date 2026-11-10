class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = 'https://wordpress.aait-sa.com/khadm-ele/wp-json/';

  static const login = 'jwt-auth/v1/token';
  static const validateToken = 'jwt-auth/v1/token/validate';

  static const profile = 'khadim/v1/me';
  static const mosques = 'khadim/v1/mosques';
  static const catalog = 'khadim/v1/catalog';
  static const requests = 'khadim/v1/requests';
}

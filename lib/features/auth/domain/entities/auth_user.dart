class AuthUser {
  const AuthUser({
    required this.email,
    required this.nicename,
    required this.displayName,
    this.roles = const [],
  });

  final String email;
  final String nicename;
  final String displayName;
  final List<String> roles;

  bool get isAdmin => roles.contains('administrator');
}

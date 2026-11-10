class AuthUser {
  const AuthUser({
    required this.email,
    required this.nicename,
    required this.displayName,
  });

  final String email;
  final String nicename;
  final String displayName;
}

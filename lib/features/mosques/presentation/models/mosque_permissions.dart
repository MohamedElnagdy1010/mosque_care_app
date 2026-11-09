import '../../../home/presentation/models/user_role.dart';

class MosquePermissions {
  const MosquePermissions._();

  static bool canViewOperationalDetails(UserRole role) {
    return switch (role) {
      UserRole.visitor => false,
      UserRole.imam => true,
      UserRole.supervisor => true,
      UserRole.ministry => true,
    };
  }

  static bool canViewMosque({
    required UserRole role,
    required String mosqueId,
    String? assignedMosqueId,
  }) {
    return switch (role) {
      UserRole.visitor => true,
      UserRole.imam => assignedMosqueId == mosqueId,
      UserRole.supervisor => true,
      UserRole.ministry => true,
    };
  }
}

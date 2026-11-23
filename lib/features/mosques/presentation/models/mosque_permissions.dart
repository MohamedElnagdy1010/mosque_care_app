import '../../../home/presentation/models/user_role.dart';

class MosquePermissions {
  const MosquePermissions._();

  static bool canViewOperationalDetails(UserRole role) {
    // التفاصيل التشغيلية غير متاحة حتى تحديد صلاحياتها من API.
    return false;
  }

  static bool canViewMosque({
    required UserRole role,
    required String mosqueId,
    String? assignedMosqueId,
  }) {
    // قائمة المساجد المعتمدة متاحة للجميع.
    return true;
  }
}

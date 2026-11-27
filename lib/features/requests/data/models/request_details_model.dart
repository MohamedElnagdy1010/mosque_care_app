import '../../domain/entities/request_details.dart';
import 'request_summary_model.dart';

class RequestDetailsModel extends RequestDetails {
  RequestDetailsModel({
    required super.id,
    required super.title,
    required super.mosqueId,
    required super.status,
    required super.createdAt,
    required super.mosqueName,
    required super.supervisorName,
    required super.supervisorPhone,
    required super.supervisorRole,
    required super.generalNotes,
    required super.needs,
  });

  factory RequestDetailsModel.fromJson(Map<String, dynamic> json) {
    final summary = RequestSummaryModel.fromJson(json);
    final rawNeeds = json['needs'];

    if (rawNeeds is! List) {
      throw const FormatException('بيانات احتياجات الطلب غير صالحة.');
    }

    final needs = rawNeeds.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('بيانات الاحتياج غير صالحة.');
      }

      return _parseNeed(item);
    }).toList();

    return RequestDetailsModel(
      id: summary.id,
      title: summary.title,
      mosqueId: summary.mosqueId,
      status: summary.status,
      createdAt: summary.createdAt,
      mosqueName: _readString(json['mosque_name']),
      supervisorName: _readString(json['supervisor_name']),
      supervisorPhone: _readString(json['supervisor_phone']),
      supervisorRole: _readString(json['supervisor_role']),
      generalNotes: _readString(json['general_notes']),
      needs: needs,
    );
  }

  static RequestNeedDetails _parseNeed(Map<String, dynamic> json) {
    final id = int.tryParse(json['id']?.toString() ?? '');

    if (id == null || id <= 0) {
      throw const FormatException('رقم الاحتياج غير صالح.');
    }

    final photo = json['photo'];
    String? photoUrl;

    if (photo is Map) {
      final rawUrl = _readString(photo['url']);
      final uri = Uri.tryParse(rawUrl);

      if (uri != null && uri.scheme == 'https' && uri.host.isNotEmpty) {
        photoUrl = rawUrl;
      }
    }

    return RequestNeedDetails(
      id: id,
      title: _readString(json['title']),
      category: _readString(json['category']),
      group: _readString(json['group']),
      itemKey: _readString(json['item_key']),
      status: _readString(json['status']),
      supervisorPriority: _readString(json['supervisor_priority']),
      adminPriority: _readString(json['admin_priority']),
      notes: _readString(json['notes']),
      photoUrl: photoUrl,
    );
  }

  static String _readString(dynamic value) {
    return value?.toString() ?? '';
  }
}

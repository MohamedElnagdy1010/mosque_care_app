import '../../domain/entities/request_summary.dart';

class RequestSummaryModel extends RequestSummary {
  const RequestSummaryModel({
    required super.id,
    required super.title,
    required super.mosqueId,
    required super.status,
    required super.createdAt,
  });

  factory RequestSummaryModel.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(json['id']?.toString() ?? '');
    final mosqueId = int.tryParse(json['mosque_id']?.toString() ?? '');

    final title = json['title'];
    final status = json['status'];

    final createdAt = DateTime.tryParse(json['created_at']?.toString() ?? '');

    if (id == null ||
        id <= 0 ||
        mosqueId == null ||
        mosqueId <= 0 ||
        title is! String ||
        title.trim().isEmpty ||
        status is! String ||
        status.trim().isEmpty ||
        createdAt == null) {
      throw const FormatException('بيانات الطلب غير صالحة.');
    }

    return RequestSummaryModel(
      id: id,
      title: title,
      mosqueId: mosqueId,
      status: status,
      createdAt: createdAt,
    );
  }
}

import 'request_summary.dart';

class RequestDetails extends RequestSummary {
  RequestDetails({
    required super.id,
    required super.title,
    required super.mosqueId,
    required super.status,
    required super.createdAt,
    required this.mosqueName,
    required this.supervisorName,
    required this.supervisorPhone,
    required this.supervisorRole,
    required this.generalNotes,
    required List<RequestNeedDetails> needs,
  }) : needs = List.unmodifiable(needs);

  final String mosqueName;
  final String supervisorName;
  final String supervisorPhone;
  final String supervisorRole;
  final String generalNotes;
  final List<RequestNeedDetails> needs;
}

class RequestNeedDetails {
  const RequestNeedDetails({
    required this.id,
    required this.title,
    required this.category,
    required this.group,
    required this.itemKey,
    required this.status,
    required this.supervisorPriority,
    required this.adminPriority,
    required this.notes,
    this.photoUrl,
  });

  final int id;
  final String title;
  final String category;
  final String group;
  final String itemKey;
  final String status;
  final String supervisorPriority;
  final String adminPriority;
  final String notes;
  final String? photoUrl;
}

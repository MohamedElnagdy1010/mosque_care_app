class RequestSummary {
  const RequestSummary({
    required this.id,
    required this.title,
    required this.mosqueId,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String title;
  final int mosqueId;
  final String status;
  final DateTime createdAt;
}

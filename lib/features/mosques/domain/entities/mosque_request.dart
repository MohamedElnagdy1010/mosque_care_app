class MosqueRequest {
  const MosqueRequest({
    required this.id,
    required this.mosqueId,
    required this.title,
    required this.source,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String mosqueId;
  final String title;
  final String source;
  final String status;
  final DateTime createdAt;
}

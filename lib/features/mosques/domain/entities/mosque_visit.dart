class MosqueVisit {
  const MosqueVisit({
    required this.id,
    required this.mosqueId,
    required this.visitDate,
    required this.serviceType,
    required this.status,
  });

  final String id;
  final String mosqueId;
  final DateTime visitDate;
  final String serviceType;
  final String status;
}

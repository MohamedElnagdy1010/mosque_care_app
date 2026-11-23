sealed class MosqueNeedsState {
  const MosqueNeedsState();
}

class MosqueNeedsInitial extends MosqueNeedsState {
  const MosqueNeedsInitial();
}

class MosqueNeedsLoading extends MosqueNeedsState {
  const MosqueNeedsLoading();
}

class MosqueNeedsLoaded extends MosqueNeedsState {
  const MosqueNeedsLoaded({
    required this.items,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  final List<Map<String, dynamic>> items;
  final int total;
  final int page;
  final int totalPages;

  bool get isEmpty => items.isEmpty;
  bool get hasMore => page < totalPages;
}

class MosqueNeedsError extends MosqueNeedsState {
  const MosqueNeedsError(this.message);

  final String message;
}

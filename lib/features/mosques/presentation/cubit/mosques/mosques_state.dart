import '../../../domain/entities/mosque.dart';

sealed class MosquesState {
  const MosquesState();
}

class MosquesInitial extends MosquesState {
  const MosquesInitial();
}

class MosquesLoading extends MosquesState {
  const MosquesLoading();
}

class MosquesLoaded extends MosquesState {
  const MosquesLoaded(
    this.mosques, {
    this.page = 1,
    this.totalPages = 1,
    this.total = 0,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final List<Mosque> mosques;
  final int page;
  final int totalPages;
  final int total;
  final bool loadingMore;
  final bool loadMoreError;

  bool get hasMore => page < totalPages;

  MosquesLoaded copyWith({
    List<Mosque>? mosques,
    int? page,
    int? totalPages,
    int? total,
    bool? loadingMore,
    bool? loadMoreError,
  }) {
    return MosquesLoaded(
      mosques ?? this.mosques,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      loadingMore: loadingMore ?? this.loadingMore,
      loadMoreError: loadMoreError ?? this.loadMoreError,
    );
  }
}

class MosquesError extends MosquesState {
  const MosquesError(this.message);

  final String message;
}

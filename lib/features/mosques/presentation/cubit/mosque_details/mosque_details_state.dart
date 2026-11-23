import '../../../domain/entities/mosque.dart';

sealed class MosqueDetailsState {
  const MosqueDetailsState();
}

class MosqueDetailsInitial extends MosqueDetailsState {
  const MosqueDetailsInitial();
}

class MosqueDetailsLoading extends MosqueDetailsState {
  const MosqueDetailsLoading();
}

class MosqueDetailsLoaded extends MosqueDetailsState {
  const MosqueDetailsLoaded(this.mosque);

  final Mosque mosque;
}

class MosqueDetailsError extends MosqueDetailsState {
  const MosqueDetailsError(this.message);

  final String message;
}

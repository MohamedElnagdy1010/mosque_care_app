import '../../domain/entities/mosque.dart';

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
  const MosquesLoaded(this.mosques);

  final List<Mosque> mosques;
}

class MosquesError extends MosquesState {
  const MosquesError(this.message);

  final String message;
}

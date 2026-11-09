import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/mosque_repository.dart';
import 'mosques_state.dart';

class MosquesCubit extends Cubit<MosquesState> {
  MosquesCubit(this.repository) : super(const MosquesInitial());

  final MosqueRepository repository;

  Future<void> loadMosques() async {
    emit(const MosquesLoading());

    try {
      final mosques = await repository.getMosques();

      if (isClosed) return;

      emit(MosquesLoaded(mosques));
    } catch (_) {
      if (isClosed) return;

      emit(const MosquesError('تعذر تحميل المساجد، حاول مرة أخرى'));
    }
  }
}

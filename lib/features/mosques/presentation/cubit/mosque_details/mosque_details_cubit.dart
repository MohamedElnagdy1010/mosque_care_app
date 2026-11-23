import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/mosque_repository.dart';
import 'mosque_details_state.dart';

class MosqueDetailsCubit extends Cubit<MosqueDetailsState> {
  MosqueDetailsCubit(this.repository) : super(const MosqueDetailsInitial());

  final MosqueRepository repository;

  Future<void> loadMosque(String mosqueId) async {
    if (isClosed) return;

    emit(const MosqueDetailsLoading());

    try {
      final mosque = await repository.getMosqueById(mosqueId);

      if (isClosed) return;

      if (mosque == null) {
        emit(const MosqueDetailsError('لم يتم العثور على بيانات المسجد.'));
        return;
      }

      emit(MosqueDetailsLoaded(mosque));
    } catch (_) {
      if (isClosed) return;

      emit(
        const MosqueDetailsError('تعذر تحميل تفاصيل المسجد، حاول مرة أخرى.'),
      );
    }
  }
}

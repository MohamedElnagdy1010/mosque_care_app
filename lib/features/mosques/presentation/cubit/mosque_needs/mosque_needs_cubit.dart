import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/mosque_needs_repository.dart';
import 'mosque_needs_state.dart';

class MosqueNeedsCubit extends Cubit<MosqueNeedsState> {
  MosqueNeedsCubit(this.repository) : super(const MosqueNeedsInitial());

  final MosqueNeedsRepository repository;

  int _revision = 0;

  Future<void> loadNeeds(String mosqueId) async {
    if (isClosed) return;

    final revision = ++_revision;

    emit(const MosqueNeedsLoading());

    try {
      final result = await repository.getNeeds(mosqueId: mosqueId);

      if (isClosed || revision != _revision) return;

      emit(
        MosqueNeedsLoaded(
          items: result.items,
          total: result.total,
          page: result.page,
          totalPages: result.totalPages,
        ),
      );
    } catch (_) {
      if (isClosed || revision != _revision) return;

      emit(
        const MosqueNeedsError('تعذر تحميل احتياجات المسجد، حاول مرة أخرى.'),
      );
    }
  }
}

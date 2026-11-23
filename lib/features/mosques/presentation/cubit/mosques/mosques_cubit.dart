import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/remote_mosque_repository.dart';
import '../../../domain/repositories/mosque_repository.dart';
import 'mosques_state.dart';

class MosquesCubit extends Cubit<MosquesState> {
  MosquesCubit(this.repository) : super(const MosquesInitial());

  final MosqueRepository repository;

  String _search = '';
  String _status = 'all';
  String _sort = 'newest';
  int? _categoryId;

  int _revision = 0;

  Future<void> loadMosques({
    String search = '',
    String status = 'all',
    String sort = 'newest',
    int? categoryId,
  }) async {
    _search = search.trim();
    _status = status;
    _sort = sort;
    _categoryId = categoryId;

    final revision = ++_revision;

    emit(const MosquesLoading());

    try {
      final currentRepository = repository;

      if (currentRepository is RemoteMosqueRepository) {
        final result = await currentRepository.getDirectoryPage(
          search: _search,
          status: _status,
          sort: _sort,
          categoryId: _categoryId,
        );

        if (isClosed || revision != _revision) return;

        emit(
          MosquesLoaded(
            result.items,
            page: result.page,
            totalPages: result.totalPages,
            total: result.total,
          ),
        );
      } else {
        final mosques = await currentRepository.getMosques();

        if (isClosed || revision != _revision) return;

        emit(
          MosquesLoaded(mosques, page: 1, totalPages: 1, total: mosques.length),
        );
      }
    } catch (_) {
      if (isClosed || revision != _revision) return;

      emit(
        const MosquesError(
          'تعذر تحميل المساجد، تحقق من الاتصال وحاول مرة أخرى.',
        ),
      );
    }
  }

  Future<void> refresh() {
    return loadMosques(
      search: _search,
      status: _status,
      sort: _sort,
      categoryId: _categoryId,
    );
  }

  Future<void> loadMore() async {
    final current = state;
    final currentRepository = repository;

    if (currentRepository is! RemoteMosqueRepository ||
        current is! MosquesLoaded ||
        current.loadingMore ||
        !current.hasMore) {
      return;
    }

    final revision = _revision;

    emit(current.copyWith(loadingMore: true, loadMoreError: false));

    try {
      final result = await currentRepository.getDirectoryPage(
        page: current.page + 1,
        search: _search,
        status: _status,
        sort: _sort,
        categoryId: _categoryId,
      );

      if (isClosed || revision != _revision) return;

      final existingIds = current.mosques.map((m) => m.id).toSet();

      final newItems = result.items
          .where((mosque) => existingIds.add(mosque.id))
          .toList();

      emit(
        MosquesLoaded(
          [...current.mosques, ...newItems],
          page: result.page,
          totalPages: result.totalPages,
          total: result.total,
        ),
      );
    } catch (_) {
      if (isClosed || revision != _revision) return;

      emit(current.copyWith(loadingMore: false, loadMoreError: true));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/service_catalog_repository.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this.repository) : super(const CatalogInitial());

  final ServiceCatalogRepository repository;

  Future<void> loadCatalog() async {
    if (isClosed) return;

    emit(const CatalogLoading());

    try {
      final catalog = await repository.getCatalog();

      if (isClosed) return;

      emit(CatalogLoaded(catalog));
    } catch (_) {
      if (isClosed) return;

      emit(const CatalogError('تعذر تحميل أقسام الخدمات، حاول مرة أخرى.'));
    }
  }
}

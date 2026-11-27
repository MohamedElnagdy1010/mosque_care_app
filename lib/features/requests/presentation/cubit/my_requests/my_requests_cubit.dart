import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/request_repository.dart';
import '../../../domain/entities/request_summary.dart';
import 'my_requests_state.dart';

class MyRequestsCubit extends Cubit<MyRequestsState> {
  MyRequestsCubit(this._repository) : super(const MyRequestsState());

  final RequestRepository _repository;

  static const int _perPage = 20;

  Future<void> loadRequests() async {
    if (isClosed ||
        state.status == MyRequestsStatus.loading ||
        state.isLoadingMore) {
      return;
    }

    emit(const MyRequestsState(status: MyRequestsStatus.loading));

    try {
      final result = await _repository.getMyRequests(
        page: 1,
        perPage: _perPage,
      );

      if (isClosed) return;

      emit(
        MyRequestsState(
          status: MyRequestsStatus.success,
          items: result.items,
          total: result.total,
          page: result.page,
        ),
      );
    } catch (error) {
      if (isClosed) return;

      emit(
        MyRequestsState(
          status: MyRequestsStatus.failure,
          errorMessage: _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> refresh() => loadRequests();

  Future<void> loadMore() async {
    if (isClosed ||
        state.status != MyRequestsStatus.success ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final previous = state;

    emit(
      MyRequestsState(
        status: MyRequestsStatus.success,
        items: previous.items,
        total: previous.total,
        page: previous.page,
        isLoadingMore: true,
      ),
    );

    try {
      final result = await _repository.getMyRequests(
        page: previous.page + 1,
        perPage: _perPage,
      );

      if (isClosed) return;

      final merged = <int, RequestSummary>{
        for (final item in previous.items) item.id: item,
        for (final item in result.items) item.id: item,
      };

      if (merged.length == previous.items.length &&
          merged.length < result.total) {
        throw const FormatException('لم يتم استرجاع طلبات إضافية.');
      }

      emit(
        MyRequestsState(
          status: MyRequestsStatus.success,
          items: List.unmodifiable(merged.values),
          total: result.total,
          page: result.page,
        ),
      );
    } catch (error) {
      if (isClosed) return;

      emit(
        MyRequestsState(
          status: MyRequestsStatus.success,
          items: previous.items,
          total: previous.total,
          page: previous.page,
          errorMessage: _getErrorMessage(error),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final code = error.response?.statusCode;

      if (code == 401) {
        return 'انتهت جلسة تسجيل الدخول.';
      }

      if (code == 403) {
        return 'ليس لديك صلاحية لعرض الطلبات.';
      }

      return 'تعذر الاتصال بالخادم. حاول مرة أخرى.';
    }

    if (error is FormatException) {
      return 'تعذر قراءة بيانات الطلبات.';
    }

    return 'حدث خطأ أثناء تحميل الطلبات.';
  }
}

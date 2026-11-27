import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/request_repository.dart';
import '../../../domain/entities/request_details.dart';

sealed class RequestDetailsState {
  const RequestDetailsState();
}

class RequestDetailsInitial extends RequestDetailsState {
  const RequestDetailsInitial();
}

class RequestDetailsLoading extends RequestDetailsState {
  const RequestDetailsLoading();
}

class RequestDetailsLoaded extends RequestDetailsState {
  const RequestDetailsLoaded(this.details);

  final RequestDetails details;
}

class RequestDetailsFailure extends RequestDetailsState {
  const RequestDetailsFailure(this.message);

  final String message;
}

class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  RequestDetailsCubit(this._repository) : super(const RequestDetailsInitial());

  final RequestRepository _repository;

  Future<void> loadDetails(int id) async {
    if (isClosed || state is RequestDetailsLoading) {
      return;
    }

    emit(const RequestDetailsLoading());

    try {
      final details = await _repository.getRequestDetails(id);

      if (isClosed) return;

      emit(RequestDetailsLoaded(details));
    } catch (error) {
      if (isClosed) return;

      emit(RequestDetailsFailure(_errorMessage(error)));
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 401:
          return 'انتهت جلسة تسجيل الدخول.';
        case 403:
        case 404:
          return 'الطلب غير متاح لحسابك.';
      }

      return 'تعذر الاتصال بالخادم.';
    }

    if (error is FormatException) {
      return 'تعذر قراءة تفاصيل الطلب.';
    }

    return 'حدث خطأ أثناء تحميل الطلب.';
  }
}

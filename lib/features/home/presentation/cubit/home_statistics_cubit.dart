import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_statistics_model.dart';
import '../../data/repositories/home_statistics_repository.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum HomeStatisticsStatus { initial, loading, success, failure }

class HomeStatisticsState {
  const HomeStatisticsState({
    this.status = HomeStatisticsStatus.initial,
    this.statistics,
    this.errorMessage,
  });

  final HomeStatisticsStatus status;
  final HomeStatisticsModel? statistics;
  final String? errorMessage;
}

class HomeStatisticsCubit extends Cubit<HomeStatisticsState> {
  HomeStatisticsCubit(this._repository) : super(const HomeStatisticsState());

  final HomeStatisticsRepository _repository;

  Future<void> loadStatistics() async {
    if (state.status == HomeStatisticsStatus.loading) return;

    emit(
      HomeStatisticsState(
        status: HomeStatisticsStatus.loading,
        statistics: state.statistics,
      ),
    );

    try {
      final statistics = await _repository.getStatistics();

      if (isClosed) return;

      emit(
        HomeStatisticsState(
          status: HomeStatisticsStatus.success,
          statistics: statistics,
        ),
      );
    } catch (error) {
      debugPrint('STATISTICS ERROR: ${error.runtimeType}');
      debugPrint('STATISTICS MESSAGE: $error');

      if (error is DioException) {
        debugPrint('STATISTICS HTTP STATUS: ${error.response?.statusCode}');
        debugPrint('STATISTICS RESPONSE: ${error.response?.data}');
        debugPrint('STATISTICS URL: ${error.requestOptions.uri}');
      }

      if (isClosed) return;

      emit(
        HomeStatisticsState(
          status: HomeStatisticsStatus.failure,
          statistics: state.statistics,
          errorMessage: 'تعذر تحميل الإحصائيات.',
        ),
      );
    }
  }
}

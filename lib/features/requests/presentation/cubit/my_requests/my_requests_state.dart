import '../../../domain/entities/request_summary.dart';

enum MyRequestsStatus { initial, loading, success, failure }

class MyRequestsState {
  const MyRequestsState({
    this.status = MyRequestsStatus.initial,
    this.items = const [],
    this.total = 0,
    this.page = 0,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final MyRequestsStatus status;
  final List<RequestSummary> items;
  final int total;
  final int page;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get hasMore => items.length < total;
  bool get isEmpty => status == MyRequestsStatus.success && items.isEmpty;
}

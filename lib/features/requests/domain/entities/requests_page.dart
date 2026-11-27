import 'request_summary.dart';

class RequestsPage {
  RequestsPage({
    required List<RequestSummary> items,
    required this.total,
    required this.page,
  }) : items = List.unmodifiable(items);

  final List<RequestSummary> items;
  final int total;
  final int page;
}

import '../../domain/entities/requests_page.dart';
import 'request_summary_model.dart';

class RequestsPageModel extends RequestsPage {
  RequestsPageModel({
    required super.items,
    required super.total,
    required super.page,
  });

  factory RequestsPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    final total = int.tryParse(json['total']?.toString() ?? '');

    final page = int.tryParse(json['page']?.toString() ?? '');

    if (rawItems is! List ||
        total == null ||
        total < 0 ||
        page == null ||
        page <= 0 ||
        rawItems.length > total) {
      throw const FormatException('استجابة قائمة الطلبات غير صالحة.');
    }

    final items = rawItems.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('بيانات أحد الطلبات غير صالحة.');
      }

      return RequestSummaryModel.fromJson(item);
    }).toList();

    return RequestsPageModel(items: items, total: total, page: page);
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_care_app/features/requests/data/models/requests_page_model.dart';

void main() {
  Map<String, dynamic> validItem() => {
    'id': 1623,
    'title': 'طلب خدمة — جامع المرقب',
    'mosque_id': 984,
    'status': 'under_review',
    'created_at': '2026-11-26T08:25:07+00:00',
  };

  group('RequestsPageModel', () {
    test('parses valid requests page', () {
      final result = RequestsPageModel.fromJson({
        'items': [validItem()],
        'total': 1,
        'page': 1,
      });

      expect(result.total, 1);
      expect(result.page, 1);
      expect(result.items.length, 1);

      final request = result.items.first;

      expect(request.id, 1623);
      expect(request.mosqueId, 984);
      expect(request.status, 'under_review');
      expect(request.createdAt.isUtc, isTrue);
    });

    test('supports empty requests page', () {
      final result = RequestsPageModel.fromJson({
        'items': [],
        'total': 0,
        'page': 1,
      });

      expect(result.items, isEmpty);
      expect(result.total, 0);
    });

    test('rejects invalid items format', () {
      expect(
        () => RequestsPageModel.fromJson({
          'items': 'invalid',
          'total': 1,
          'page': 1,
        }),
        throwsFormatException,
      );
    });

    test('rejects invalid request id', () {
      expect(
        () => RequestsPageModel.fromJson({
          'items': [
            {...validItem(), 'id': 0},
          ],
          'total': 1,
          'page': 1,
        }),
        throwsFormatException,
      );
    });

    test('rejects invalid date', () {
      expect(
        () => RequestsPageModel.fromJson({
          'items': [
            {...validItem(), 'created_at': 'invalid'},
          ],
          'total': 1,
          'page': 1,
        }),
        throwsFormatException,
      );
    });

    test('rejects invalid pagination', () {
      expect(
        () => RequestsPageModel.fromJson({'items': [], 'total': -1, 'page': 0}),
        throwsFormatException,
      );
    });

    test('supports numeric string identifiers', () {
      final result = RequestsPageModel.fromJson({
        'items': [
          {...validItem(), 'id': '1623', 'mosque_id': '984'},
        ],
        'total': 1,
        'page': 1,
      });

      expect(result.items.first.id, 1623);
      expect(result.items.first.mosqueId, 984);
    });
  });
}

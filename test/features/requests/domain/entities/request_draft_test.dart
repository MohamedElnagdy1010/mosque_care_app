import 'package:flutter_test/flutter_test.dart';

import 'package:mosque_care_app/features/requests/domain/entities/request_draft.dart';

void main() {
  RequestDraft createDraft({
    String phone = '0500000000',
    List<RequestNeedDraft>? needs,
  }) {
    return RequestDraft(
      supervisorName: 'مشرف اختبار',
      supervisorPhone: phone,
      supervisorRole: 'مشرف',
      mosqueId: 1486,
      needs:
          needs ??
          [
            const RequestNeedDraft(
              catalogCategory: 'maintenance_electrical',
              itemKey: 'bulb',
              notes: 'استبدال الإنارة',
            ),
          ],
    );
  }

  group('RequestDraft validation', () {
    test('accepts a valid draft', () {
      final draft = createDraft();

      expect(draft.validate(), isNull);
    });

    test('rejects an invalid Saudi phone number', () {
      final draft = createDraft(phone: '12345');

      expect(draft.validate(), isNotNull);
    });

    test('requires at least one need', () {
      final draft = createDraft(needs: []);

      expect(draft.validate(), isNotNull);
    });

    test('requires notes when item is other', () {
      final draft = createDraft(
        needs: [
          const RequestNeedDraft(
            catalogCategory: 'maintenance_electrical',
            itemKey: 'other',
          ),
        ],
      );

      expect(draft.validate(), isNotNull);
    });

    test('rejects more than 30 needs', () {
      final needs = List.generate(
        31,
        (index) => RequestNeedDraft(
          catalogCategory: 'maintenance_electrical',
          itemKey: 'item_$index',
        ),
      );

      expect(createDraft(needs: needs).validate(), isNotNull);
    });
  });

  group('RequestDraft API payload', () {
    test('maps electrical maintenance correctly', () {
      final json = createDraft().toApiJson();

      expect(json['mosque_mode'], 'existing');
      expect(json['mosque_id'], 1486);
      expect(json['inventory'], isEmpty);

      final needs = json['needs'] as List;
      final need = needs.first as Map<String, dynamic>;

      expect(need['category'], 'maintenance');
      expect(need['group'], 'electrical');
      expect(need['item_maintenance_electrical'], 'bulb');
      expect(need['priority'], 'medium');
      expect(need['photo'], 0);
    });

    test('maps cleaning without maintenance group', () {
      const need = RequestNeedDraft(
        catalogCategory: 'cleaning',
        itemKey: 'mosqueCleaning',
        priority: 'low',
      );

      final json = need.toApiJson();

      expect(json['category'], 'cleaning');
      expect(json['group'], '');
      expect(json['item_cleaning'], 'mosqueCleaning');
      expect(json['priority'], 'low');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:mosque_care_app/features/inventory/domain/entities/inventory_item_draft.dart';
import 'package:mosque_care_app/features/inventory/domain/entities/inventory_draft.dart';
import 'package:mosque_care_app/features/inventory/presentation/cubit/inventory_cubit.dart';

InventoryDraft createDraft(List<InventoryItemDraft> items) {
  return InventoryDraft(
    mosqueId: 1,
    supervisorName: 'Test Supervisor',
    supervisorPhone: '0500000000',
    supervisorRole: 'مشرف مسجد',
    items: items,
  );
}

void main() {
  group('InventoryItemDraft', () {
    test('calculates healthy quantity correctly', () {
      const item = InventoryItemDraft(
        categoryKey: 'maintenance_hvac',
        categoryName: 'التكييف',
        itemKey: 'split',
        title: 'مكيفات',
        qtyTotal: 12,
        qtyDamaged: 3,
      );

      expect(item.qtyHealthy, 9);
      expect(item.validate(), isNull);
    });
    test('rejects empty title', () {
      const item = InventoryItemDraft();

      expect(item.validate(), isNotNull);
    });

    test('rejects zero total quantity', () {
      const item = InventoryItemDraft(title: 'مكيفات', qtyTotal: 0);

      expect(item.validate(), isNotNull);
    });

    test('rejects damaged quantity greater than total', () {
      const item = InventoryItemDraft(
        title: 'مكيفات',
        qtyTotal: 5,
        qtyDamaged: 6,
      );

      expect(item.validate(), isNotNull);
    });

    test('rejects negative damaged quantity', () {
      const item = InventoryItemDraft(
        title: 'مكيفات',
        qtyTotal: 5,
        qtyDamaged: -1,
      );

      expect(item.validate(), isNotNull);
    });

    test('rejects missing category', () {
      const item = InventoryItemDraft(itemKey: 'split', title: 'مكيف سبليت');

      expect(item.validate(), 'يرجى اختيار الخدمة الرئيسية.');
    });

    test('rejects missing service item', () {
      const item = InventoryItemDraft(
        categoryKey: 'maintenance_hvac',
        categoryName: 'التكييف',
      );

      expect(item.validate(), 'يرجى اختيار الخدمة الفرعية.');
    });

    test('requires custom title for other item', () {
      const item = InventoryItemDraft(
        categoryKey: 'maintenance_hvac',
        categoryName: 'التكييف',
        itemKey: 'other',
      );

      expect(item.isOther, isTrue);
      expect(item.validate(), isNotNull);

      final updated = item.copyWith(title: 'مكيف مركزي');

      expect(updated.validate(), isNull);
    });
  });

  group('InventoryDraft', () {
    test('calculates inventory totals', () {
      final draft = createDraft([
        const InventoryItemDraft(
          categoryKey: 'maintenance_hvac',
          categoryName: 'التكييف',
          itemKey: 'split',
          title: 'مكيفات',
          qtyTotal: 12,
          qtyDamaged: 3,
        ),
        const InventoryItemDraft(
          categoryKey: 'maintenance_electrical',
          categoryName: 'الكهرباء',
          itemKey: 'bulb',
          title: 'مصابيح',
          qtyTotal: 20,
          qtyDamaged: 2,
        ),
      ]);

      expect(draft.totalQuantity, 32);
      expect(draft.damagedQuantity, 5);
      expect(draft.healthyQuantity, 27);
      expect(draft.validate(), isNull);
    });

    test('rejects empty inventory', () {
      expect(createDraft([]).validate(), isNotNull);
    });

    test('rejects more than 30 items', () {
      final draft = createDraft(
        List.generate(31, (index) => InventoryItemDraft(title: 'Item $index')),
      );

      expect(draft.validate(), isNotNull);
    });
  });

  group('InventoryCubit', () {
    late InventoryCubit cubit;

    setUp(() {
      cubit = InventoryCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('starts with one item', () {
      expect(cubit.state.entries.length, 1);
    });

    test('adds an item', () {
      cubit.addItem();

      expect(cubit.state.entries.length, 2);
    });

    test('removes the correct item', () {
      cubit.addItem();

      final id = cubit.state.entries.first.id;
      final remainingId = cubit.state.entries.last.id;

      cubit.removeItem(id);

      expect(cubit.state.entries.length, 1);
      expect(cubit.state.entries.first.id, remainingId);
    });

    test('updates quantities and calculates healthy', () {
      final id = cubit.state.entries.first.id;

      cubit.updateItem(id, title: 'مكيفات', qtyTotal: 10, qtyDamaged: 4);

      final item = cubit.state.entries.first.item;

      expect(item.title, 'مكيفات');
      expect(item.qtyHealthy, 6);
    });

    test('does not exceed 30 items', () {
      for (var i = 0; i < 40; i++) {
        cubit.addItem();
      }

      expect(cubit.state.entries.length, 30);
      expect(cubit.state.canAdd, isFalse);
    });

    test('resets inventory', () {
      cubit.addItem();
      cubit.addItem();

      cubit.reset();

      expect(cubit.state.entries.length, 1);
      expect(cubit.state.entries.first.item.title, isEmpty);
    });

    test('selects category and service item', () {
      final id = cubit.state.entries.first.id;

      cubit.selectCategory(
        id,
        categoryKey: 'maintenance_hvac',
        categoryName: 'التكييف',
      );

      cubit.selectServiceItem(id, itemKey: 'split', itemName: 'مكيف سبليت');

      final item = cubit.state.entries.first.item;

      expect(item.categoryKey, 'maintenance_hvac');
      expect(item.categoryName, 'التكييف');
      expect(item.itemKey, 'split');
      expect(item.title, 'مكيف سبليت');
      expect(item.validate(), isNull);
    });

    test('changing category clears previous service item', () {
      final id = cubit.state.entries.first.id;

      cubit.selectCategory(
        id,
        categoryKey: 'maintenance_hvac',
        categoryName: 'التكييف',
      );

      cubit.selectServiceItem(id, itemKey: 'split', itemName: 'مكيف سبليت');

      cubit.selectCategory(
        id,
        categoryKey: 'maintenance_electrical',
        categoryName: 'الكهرباء',
      );

      final item = cubit.state.entries.first.item;

      expect(item.categoryKey, 'maintenance_electrical');
      expect(item.itemKey, isEmpty);
      expect(item.title, isEmpty);
      expect(item.validate(), isNotNull);
    });

    test('selecting other clears previous title', () {
      final id = cubit.state.entries.first.id;

      cubit.selectCategory(
        id,
        categoryKey: 'maintenance_hvac',
        categoryName: 'التكييف',
      );

      cubit.selectServiceItem(id, itemKey: 'split', itemName: 'مكيف سبليت');

      cubit.selectServiceItem(id, itemKey: 'other', itemName: 'أخرى');

      final item = cubit.state.entries.first.item;

      expect(item.isOther, isTrue);
      expect(item.title, isEmpty);
      expect(item.validate(), isNotNull);
    });
  });
}

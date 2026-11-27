import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mosque_care_app/features/inventory/presentation/cubit/inventory_cubit.dart';

void main() {
  late InventoryCubit cubit;

  setUp(() {
    cubit = InventoryCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('Inventory Multiple Photos', () {
    test('adds multiple photos to an item', () {
      final id = cubit.state.entries.first.id;

      final added = cubit.addPhotos(id, [
        XFile('photo_1.jpg'),
        XFile('photo_2.jpg'),
        XFile('photo_3.jpg'),
      ]);

      expect(added, 3);
      expect(cubit.state.entries.first.photos.length, 3);
      expect(cubit.state.totalPhotos, 3);
    });

    test('enforces maximum photos per item', () {
      final id = cubit.state.entries.first.id;

      cubit.addPhotos(
        id,
        List.generate(8, (index) => XFile('photo_$index.jpg')),
      );

      final entry = cubit.state.entries.first;

      expect(entry.photos.length, InventoryEntry.maxPhotos);
      expect(entry.canAddPhoto, isFalse);
      expect(entry.remainingPhotos, 0);

      expect(cubit.addPhotos(id, [XFile('extra.jpg')]), 0);
    });

    test('prevents duplicate photo paths', () {
      final id = cubit.state.entries.first.id;

      cubit.addPhotos(id, [XFile('photo_1.jpg'), XFile('photo_1.jpg')]);

      cubit.addPhotos(id, [XFile('photo_1.jpg'), XFile('photo_2.jpg')]);

      expect(cubit.state.entries.first.photos.length, 2);
    });

    test('removes only the selected photo', () {
      final id = cubit.state.entries.first.id;

      cubit.addPhotos(id, [
        XFile('photo_1.jpg'),
        XFile('photo_2.jpg'),
        XFile('photo_3.jpg'),
      ]);

      cubit.removePhoto(id, 'photo_2.jpg');

      final photos = cubit.state.entries.first.photos;

      expect(photos.length, 2);

      expect(photos.map((photo) => photo.path).toList(), [
        'photo_1.jpg',
        'photo_3.jpg',
      ]);
    });

    test('keeps photos separate for each item', () {
      final firstId = cubit.state.entries.first.id;

      cubit.addItem();

      final secondId = cubit.state.entries.last.id;

      cubit.addPhotos(firstId, [XFile('first_item.jpg')]);

      cubit.addPhotos(secondId, [
        XFile('second_item_1.jpg'),
        XFile('second_item_2.jpg'),
      ]);

      expect(cubit.state.entries.first.photos.length, 1);

      expect(cubit.state.entries.last.photos.length, 2);

      expect(cubit.state.totalPhotos, 3);

      cubit.removeItem(firstId);

      expect(cubit.state.entries.single.id, secondId);

      expect(cubit.state.entries.single.photos.length, 2);

      expect(cubit.state.totalPhotos, 2);
    });

    test('preserves photos when updating item data', () {
      final id = cubit.state.entries.first.id;

      cubit.addPhotos(id, [XFile('photo_1.jpg'), XFile('photo_2.jpg')]);

      cubit.updateItem(id, qtyTotal: 10, qtyDamaged: 2, notes: 'Updated notes');

      final entry = cubit.state.entries.first;

      expect(entry.photos.length, 2);
      expect(entry.item.qtyTotal, 10);
      expect(entry.item.qtyDamaged, 2);
      expect(entry.item.notes, 'Updated notes');
    });

    test('clears all photos for the selected item', () {
      final id = cubit.state.entries.first.id;

      cubit.addPhotos(id, [XFile('photo_1.jpg'), XFile('photo_2.jpg')]);

      cubit.clearPhotos(id);

      final entry = cubit.state.entries.first;

      expect(entry.photos, isEmpty);
      expect(entry.canAddPhoto, isTrue);
      expect(cubit.state.totalPhotos, 0);

      expect(entry.remainingPhotos, InventoryEntry.maxPhotos);
    });
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/inventory_item_draft.dart';

class InventoryEntry {
  InventoryEntry({
    required this.id,
    required this.item,
    List<XFile> photos = const [],
  }) : photos = List.unmodifiable(photos);

  static const int maxPhotos = 5;

  final int id;
  final InventoryItemDraft item;
  final List<XFile> photos;

  bool get canAddPhoto => photos.length < maxPhotos;

  int get remainingPhotos => maxPhotos - photos.length;
}

class InventoryState {
  InventoryState({List<InventoryEntry> entries = const []})
    : entries = List.unmodifiable(entries);

  final List<InventoryEntry> entries;

  bool get canAdd => entries.length < 30;

  int get totalQuantity =>
      entries.fold(0, (sum, entry) => sum + entry.item.qtyTotal);

  int get damagedQuantity =>
      entries.fold(0, (sum, entry) => sum + entry.item.qtyDamaged);

  int get totalPhotos =>
      entries.fold(0, (sum, entry) => sum + entry.photos.length);
}

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryState()) {
    addItem();
  }

  int _nextId = 0;

  void addItem() {
    if (isClosed || !state.canAdd) return;

    emit(
      InventoryState(
        entries: [
          ...state.entries,
          InventoryEntry(id: _nextId++, item: const InventoryItemDraft()),
        ],
      ),
    );
  }

  void removeItem(int id) {
    if (isClosed) return;

    emit(
      InventoryState(
        entries: state.entries.where((entry) => entry.id != id).toList(),
      ),
    );
  }

  void updateItem(
    int id, {
    String? categoryKey,
    String? categoryName,
    String? itemKey,
    String? title,
    int? qtyTotal,
    int? qtyDamaged,
    String? notes,
  }) {
    if (isClosed) return;

    emit(
      InventoryState(
        entries: state.entries.map((entry) {
          if (entry.id != id) return entry;

          return InventoryEntry(
            id: entry.id,
            photos: entry.photos,
            item: entry.item.copyWith(
              categoryKey: categoryKey,
              categoryName: categoryName,
              itemKey: itemKey,
              title: title,
              qtyTotal: qtyTotal,
              qtyDamaged: qtyDamaged,
              notes: notes,
            ),
          );
        }).toList(),
      ),
    );
  }

  void selectCategory(
    int id, {
    required String categoryKey,
    required String categoryName,
  }) {
    updateItem(
      id,
      categoryKey: categoryKey,
      categoryName: categoryName,
      itemKey: '',
      title: '',
    );
  }

  void selectServiceItem(
    int id, {
    required String itemKey,
    required String itemName,
  }) {
    updateItem(id, itemKey: itemKey, title: itemKey == 'other' ? '' : itemName);
  }

  int addPhotos(int id, List<XFile> photos) {
    if (isClosed || photos.isEmpty) return 0;

    int addedCount = 0;

    final updatedEntries = state.entries.map((entry) {
      if (entry.id != id || !entry.canAddPhoto) {
        return entry;
      }

      final updatedPhotos = [...entry.photos];

      final existingPaths = updatedPhotos.map((photo) => photo.path).toSet();

      for (final photo in photos) {
        if (updatedPhotos.length >= InventoryEntry.maxPhotos) {
          break;
        }

        if (!existingPaths.add(photo.path)) {
          continue;
        }

        updatedPhotos.add(photo);
        addedCount++;
      }

      return InventoryEntry(
        id: entry.id,
        item: entry.item,
        photos: updatedPhotos,
      );
    }).toList();

    if (addedCount > 0) {
      emit(InventoryState(entries: updatedEntries));
    }

    return addedCount;
  }

  void removePhoto(int id, String photoPath) {
    if (isClosed) return;

    emit(
      InventoryState(
        entries: state.entries.map((entry) {
          if (entry.id != id) return entry;

          return InventoryEntry(
            id: entry.id,
            item: entry.item,
            photos: entry.photos
                .where((photo) => photo.path != photoPath)
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  void clearPhotos(int id) {
    if (isClosed) return;

    emit(
      InventoryState(
        entries: state.entries.map((entry) {
          if (entry.id != id) return entry;

          return InventoryEntry(id: entry.id, item: entry.item);
        }).toList(),
      ),
    );
  }

  void reset() {
    if (isClosed) return;

    emit(InventoryState());
    addItem();
  }
}

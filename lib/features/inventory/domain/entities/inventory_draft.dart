import 'inventory_item_draft.dart';

class InventoryDraft {
  InventoryDraft({
    required this.mosqueId,
    required this.supervisorName,
    required this.supervisorPhone,
    required this.supervisorRole,
    required List<InventoryItemDraft> items,
    this.generalNotes = '',
  }) : items = List.unmodifiable(items);

  final int mosqueId;
  final String supervisorName;
  final String supervisorPhone;
  final String supervisorRole;
  final List<InventoryItemDraft> items;
  final String generalNotes;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.qtyTotal);

  int get damagedQuantity =>
      items.fold(0, (sum, item) => sum + item.qtyDamaged);

  int get healthyQuantity => totalQuantity - damagedQuantity;

  String? validate() {
    if (mosqueId <= 0) {
      return 'يرجى اختيار المسجد.';
    }

    if (supervisorName.trim().isEmpty) {
      return 'يرجى إدخال اسم المشرف.';
    }

    if (!RegExp(r'^05\d{8}$').hasMatch(supervisorPhone.trim())) {
      return 'يرجى إدخال رقم جوال سعودي صحيح.';
    }

    if (supervisorRole.trim().isEmpty) {
      return 'يرجى إدخال صفة المشرف.';
    }

    if (items.isEmpty || items.length > 30) {
      return 'يجب إضافة عنصر واحد إلى 30 عنصرًا.';
    }

    for (var i = 0; i < items.length; i++) {
      final error = items[i].validate();

      if (error != null) {
        return 'العنصر ${i + 1}: $error';
      }
    }

    return null;
  }
}

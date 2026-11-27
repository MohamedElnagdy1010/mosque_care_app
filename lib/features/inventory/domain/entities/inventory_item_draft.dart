class InventoryItemDraft {
  const InventoryItemDraft({
    this.categoryKey = '',
    this.categoryName = '',
    this.itemKey = '',
    this.title = '',
    this.qtyTotal = 1,
    this.qtyDamaged = 0,
    this.notes = '',
  });

  final String categoryKey;
  final String categoryName;
  final String itemKey;
  final String title;
  final int qtyTotal;
  final int qtyDamaged;
  final String notes;

  bool get isOther => itemKey == 'other';

  int get qtyHealthy => qtyTotal - qtyDamaged;

  InventoryItemDraft copyWith({
    String? categoryKey,
    String? categoryName,
    String? itemKey,
    String? title,
    int? qtyTotal,
    int? qtyDamaged,
    String? notes,
  }) {
    return InventoryItemDraft(
      categoryKey: categoryKey ?? this.categoryKey,
      categoryName: categoryName ?? this.categoryName,
      itemKey: itemKey ?? this.itemKey,
      title: title ?? this.title,
      qtyTotal: qtyTotal ?? this.qtyTotal,
      qtyDamaged: qtyDamaged ?? this.qtyDamaged,
      notes: notes ?? this.notes,
    );
  }

  String? validate() {
    if (categoryKey.trim().isEmpty || categoryName.trim().isEmpty) {
      return 'يرجى اختيار الخدمة الرئيسية.';
    }

    if (itemKey.trim().isEmpty) {
      return 'يرجى اختيار الخدمة الفرعية.';
    }

    if (title.trim().isEmpty) {
      return 'يرجى تحديد اسم العنصر.';
    }

    if (qtyTotal < 1) {
      return 'يجب أن يكون العدد الإجمالي أكبر من صفر.';
    }

    if (qtyDamaged < 0) {
      return 'العدد التالف غير صالح.';
    }

    if (qtyDamaged > qtyTotal) {
      return 'العدد التالف لا يمكن أن يتجاوز الإجمالي.';
    }

    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../requests/data/models/service_catalog_model.dart';
import '../cubit/inventory_cubit.dart';
import 'inventory_category_selector.dart';
import 'inventory_photo_picker.dart';

class InventoryItemCard extends StatelessWidget {
  const InventoryItemCard({
    super.key,
    required this.entry,
    required this.index,
    required this.categories,
  });

  final InventoryEntry entry;
  final int index;
  final List<ServiceCatalogCategory> categories;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFF9F0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _gold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryCubit>();
    final item = entry.item;

    final validQuantity =
        item.qtyTotal >= 1 &&
        item.qtyDamaged >= 0 &&
        item.qtyDamaged <= item.qtyTotal;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الموجودات — عنصر $index',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'حذف العنصر',
                onPressed: () => cubit.removeItem(entry.id),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InventoryCategorySelector(entry: entry, categories: categories),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: item.qtyTotal.toString(),
                  keyboardType: TextInputType.number,
                  decoration: _decoration('الإجمالي'),
                  onChanged: (value) => cubit.updateItem(
                    entry.id,
                    qtyTotal: int.tryParse(value) ?? -1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: item.qtyDamaged.toString(),
                  keyboardType: TextInputType.number,
                  decoration: _decoration('التالف'),
                  onChanged: (value) => cubit.updateItem(
                    entry.id,
                    qtyDamaged: int.tryParse(value) ?? -1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: validQuantity
                  ? const Color(0xFFEAF5ED)
                  : const Color(0xFFFDECEC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              validQuantity
                  ? 'العدد السليم: ${item.qtyHealthy}'
                  : 'يرجى التأكد من صحة الأعداد',
              style: TextStyle(
                color: validQuantity ? const Color(0xFF27864A) : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: item.notes,
            maxLines: 3,
            decoration: _decoration('ملاحظات'),
            onChanged: (value) => cubit.updateItem(entry.id, notes: value),
          ),
          const SizedBox(height: 14),
          InventoryPhotoPicker(key: ValueKey(entry.id), entry: entry),
        ],
      ),
    );
  }
}

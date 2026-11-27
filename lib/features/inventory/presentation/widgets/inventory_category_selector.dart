import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../requests/data/models/service_catalog_model.dart';
import '../cubit/inventory_cubit.dart';

class InventoryCategorySelector extends StatelessWidget {
  const InventoryCategorySelector({
    super.key,
    required this.entry,
    required this.categories,
  });

  final InventoryEntry entry;
  final List<ServiceCatalogCategory> categories;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  ServiceCatalogCategory? get selectedCategory {
    for (final category in categories) {
      if (category.key == entry.item.categoryKey) {
        return category;
      }
    }

    return null;
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _brown, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFFFF9F0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
    final category = selectedCategory;
    final items = category?.items ?? const <ServiceCatalogItem>[];

    final selectedItemKey = items.any((item) => item.key == entry.item.itemKey)
        ? entry.item.itemKey
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InputDecorator(
                decoration: _decoration('الخدمة الرئيسية'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: category?.key,
                    isExpanded: true,
                    isDense: true,
                    hint: const Text(
                      'اختر الخدمة',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                    iconEnabledColor: _gold,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.key,
                        child: Text(
                          category.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: _brown),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      final selected = categories.firstWhere(
                        (category) => category.key == value,
                      );

                      cubit.selectCategory(
                        entry.id,
                        categoryKey: selected.key,
                        categoryName: selected.name,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InputDecorator(
                decoration: _decoration('الخدمة الفرعية'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedItemKey,
                    isExpanded: true,
                    isDense: true,
                    iconEnabledColor: _gold,
                    hint: const Text(
                      'اختر العنصر',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item.key,
                        child: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: _brown),
                        ),
                      );
                    }).toList(),
                    onChanged: items.isEmpty
                        ? null
                        : (value) {
                            if (value == null) return;

                            final selected = items.firstWhere(
                              (item) => item.key == value,
                            );

                            cubit.selectServiceItem(
                              entry.id,
                              itemKey: selected.key,
                              itemName: selected.name,
                            );
                          },
                  ),
                ),
              ),
            ),
          ],
        ),
        if (entry.item.isOther) ...[
          const SizedBox(height: 14),
          TextFormField(
            key: ValueKey('${entry.id}-${entry.item.categoryKey}-other'),
            initialValue: entry.item.title,
            decoration: _decoration('حدد اسم العنصر'),
            onChanged: (value) => cubit.updateItem(entry.id, title: value),
          ),
        ],
      ],
    );
  }
}

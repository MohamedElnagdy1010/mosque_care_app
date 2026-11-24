import 'package:flutter/material.dart';

import '../../data/models/service_catalog_model.dart';
import '../../domain/entities/request_draft.dart';
import 'request_need_details_card.dart';

import 'package:image_picker/image_picker.dart';

class RequestSelectedNeedsSection extends StatelessWidget {
  const RequestSelectedNeedsSection({
    super.key,
    required this.categories,
    required this.selectedNeeds,
    required this.onNeedChanged,
    required this.needPhotos,
    required this.onPhotoChanged,
  });

  final List<ServiceCatalogCategory> categories;
  final Map<String, RequestNeedDraft> selectedNeeds;
  final ValueChanged<RequestNeedDraft> onNeedChanged;

  final Map<String, XFile> needPhotos;

  final void Function(String selectionKey, XFile? photo) onPhotoChanged;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  @override
  Widget build(BuildContext context) {
    if (selectedNeeds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...categories.map((category) {
          final needs = selectedNeeds.values
              .where((need) => need.catalogCategory == category.key)
              .toList();

          if (needs.isEmpty) {
            return const SizedBox.shrink();
          }

          return Card(
            key: ValueKey(category.key),
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE8D9C3)),
            ),

            child: ExpansionTile(
              key: ValueKey('selected_needs_${category.key}'),
              maintainState: true,

              iconColor: _gold,
              collapsedIconColor: _brown,
              title: Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _brown,
                ),
              ),
              subtitle: Text('${needs.length} احتياجات مختارة'),
              childrenPadding: const EdgeInsets.all(12),
              children: needs.map((need) {
                final matchingItems = category.items.where(
                  (item) => item.key == need.itemKey,
                );

                final title = matchingItems.isNotEmpty
                    ? matchingItems.first.name
                    : need.itemKey;

                return RequestNeedDetailsCard(
                  key: ValueKey(need.selectionKey),
                  title: title,
                  need: need,
                  onChanged: onNeedChanged,
                  photo: needPhotos[need.selectionKey],
                  onPhotoChanged: (photo) {
                    onPhotoChanged(need.selectionKey, photo);
                  },
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}

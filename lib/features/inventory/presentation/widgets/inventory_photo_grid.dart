import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InventoryPhotoGrid extends StatelessWidget {
  const InventoryPhotoGrid({super.key, required this.photos, this.onRemove});

  final List<XFile> photos;
  final ValueChanged<String>? onRemove;

  void _previewPhoto(BuildContext context, XFile photo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('معاينة الصورة'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image.file(
                File(photo.path),
                fit: BoxFit.contain,
                errorBuilder: (_, error, stackTrace) {
                  return const Text(
                    'تعذر عرض الصورة',
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];

        return Stack(
          key: ValueKey(photo.path),
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => _previewPhoto(context, photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(photo.path),
                  fit: BoxFit.cover,
                  cacheWidth: 400,
                  errorBuilder: (_, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0xFFF3EBDD),
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (onRemove != null)
              PositionedDirectional(
                top: 4,
                end: 4,
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'حذف الصورة',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    iconSize: 20,
                    color: Colors.white,
                    onPressed: () => onRemove!(photo.path),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

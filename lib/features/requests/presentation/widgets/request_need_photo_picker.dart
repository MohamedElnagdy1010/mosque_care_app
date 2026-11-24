import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RequestNeedPhotoPicker extends StatelessWidget {
  const RequestNeedPhotoPicker({
    super.key,
    required this.photo,
    required this.onChanged,
  });

  final XFile? photo;
  final ValueChanged<XFile?> onChanged;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);
  static const _maxBytes = 5 * 1024 * 1024;

  Future<void> _selectPhoto(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر مصدر الصورة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('التقاط صورة بالكاميرا'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('اختيار من المعرض'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null || !context.mounted) return;

    try {
      final selected = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (selected == null || !context.mounted) return;

      final extension = selected.path.split('.').last.toLowerCase();

      if (!{'jpg', 'jpeg', 'png', 'webp'}.contains(extension)) {
        _showError(context, 'صيغة الصورة غير مدعومة.');
        return;
      }

      final size = await selected.length();

      if (!context.mounted) return;

      if (size > _maxBytes) {
        _showError(context, 'يجب ألا يتجاوز حجم الصورة 5MB.');
        return;
      }

      onChanged(selected);
    } catch (error, stackTrace) {
      debugPrint('IMAGE_PICKER_ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        _showError(context, 'تعذر اختيار الصورة، راجع Debug Console.');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة المشكلة (اختياري)',
          style: TextStyle(color: _brown, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        if (photo != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(photo!.path),
              width: double.infinity,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectPhoto(context),
                icon: Icon(
                  photo == null
                      ? Icons.add_a_photo_outlined
                      : Icons.edit_outlined,
                  color: _gold,
                ),
                label: Text(photo == null ? 'إضافة صورة' : 'تغيير الصورة'),
              ),
            ),
            if (photo != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'حذف الصورة',
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

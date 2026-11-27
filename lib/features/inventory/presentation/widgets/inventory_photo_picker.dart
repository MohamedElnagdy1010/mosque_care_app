import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/inventory_cubit.dart';
import 'inventory_photo_grid.dart';

class InventoryPhotoPicker extends StatefulWidget {
  const InventoryPhotoPicker({super.key, required this.entry});

  final InventoryEntry entry;

  @override
  State<InventoryPhotoPicker> createState() => _InventoryPhotoPickerState();
}

class _InventoryPhotoPickerState extends State<InventoryPhotoPicker> {
  final ImagePicker _picker = ImagePicker();

  bool _isPicking = false;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  static const _maxFileSize = 5 * 1024 * 1024;

  static const _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _isValidPhoto(XFile photo) async {
    try {
      final extension = photo.name.split('.').last.toLowerCase();

      if (!_allowedExtensions.contains(extension)) {
        return false;
      }

      final size = await photo.length();

      return size > 0 && size <= _maxFileSize;
    } catch (_) {
      return false;
    }
  }

  Future<void> _pickPhotos({required bool fromCamera}) async {
    if (_isPicking || !widget.entry.canAddPhoto) {
      return;
    }

    final cubit = context.read<InventoryCubit>();
    final entryId = widget.entry.id;

    setState(() => _isPicking = true);

    try {
      final List<XFile> selectedPhotos;

      if (fromCamera) {
        final photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1600,
        );

        selectedPhotos = photo == null ? [] : [photo];
      } else {
        selectedPhotos = await _picker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1600,
        );
      }

      if (!mounted || cubit.isClosed || selectedPhotos.isEmpty) {
        return;
      }

      final validPhotos = <XFile>[];
      int invalidCount = 0;

      for (final photo in selectedPhotos) {
        if (await _isValidPhoto(photo)) {
          validPhotos.add(photo);
        } else {
          invalidCount++;
        }
      }

      if (!mounted || cubit.isClosed) return;

      final addedCount = cubit.addPhotos(entryId, validPhotos);

      final skippedCount = validPhotos.length - addedCount;

      final messages = <String>[];

      if (addedCount > 0) {
        messages.add('تمت إضافة $addedCount صورة.');
      }

      if (invalidCount > 0) {
        messages.add(
          'تم استبعاد $invalidCount صورة '
          'بسبب النوع أو الحجم غير المدعوم.',
        );
      }

      if (skippedCount > 0) {
        messages.add(
          'لم تتم إضافة $skippedCount صورة '
          'بسبب التكرار أو الحد الأقصى.',
        );
      }

      if (messages.isNotEmpty) {
        _showMessage(messages.join('\n'));
      }
    } catch (_) {
      _showMessage('تعذر اختيار الصور.');
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final cubit = context.read<InventoryCubit>();

    final canPick = entry.canAddPhoto && !_isPicking;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library_outlined, color: _gold, size: 21),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'صور التوثيق',
                style: TextStyle(
                  color: _brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '${entry.photos.length}'
              ' / ${InventoryEntry.maxPhotos}',
              style: const TextStyle(
                color: _brown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (entry.photos.isNotEmpty) ...[
          InventoryPhotoGrid(
            photos: entry.photos,
            onRemove: _isPicking
                ? null
                : (path) => cubit.removePhoto(entry.id, path),
          ),
          const SizedBox(height: 12),
        ],
        if (_isPicking) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canPick ? () => _pickPhotos(fromCamera: true) : null,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('الكاميرا'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canPick
                    ? () => _pickPhotos(fromCamera: false)
                    : null,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('المعرض'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          entry.canAddPhoto
              ? 'يمكن إضافة ${entry.remainingPhotos} '
                    'صور إضافية، بحد أقصى 5 MB للصورة.'
              : 'تم الوصول إلى الحد الأقصى للصور.',
          style: const TextStyle(color: Color(0xFF8A7868), fontSize: 12),
        ),
      ],
    );
  }
}

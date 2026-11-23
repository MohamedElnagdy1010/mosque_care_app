import 'package:flutter/material.dart';

class MosqueCard extends StatelessWidget {
  const MosqueCard({
    super.key,
    required this.name,
    required this.neighborhood,
    required this.onTap,
    this.imageUrl,
    this.serviceStatus,
    this.openNeedsCount,
    this.mosqueType,
  });

  final String name;
  final String neighborhood;
  final VoidCallback onTap;

  final String? imageUrl;
  final String? serviceStatus;
  final int? openNeedsCount;
  final String? mosqueType;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);
  static const _muted = Color(0xFF9B8B7A);

  String get _statusLabel {
    switch (serviceStatus) {
      case 'none':
        return 'الحالة غير محددة';
      case 'under_review':
        return 'قيد المراجعة';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتملة';
      default:
        return 'الحالة غير متاحة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final validImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8D9C3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 90,
                  height: 100,
                  child: validImage
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _brown,
                      ),
                    ),
                    if (mosqueType != null && mosqueType!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        mosqueType!,
                        style: const TextStyle(fontSize: 11, color: _muted),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: _muted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            neighborhood,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: _muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _infoChip(_statusLabel),
                        if (openNeedsCount != null)
                          _infoChip('$openNeedsCount احتياجات مفتوحة'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض تفاصيل المسجد',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _brown,
                          ),
                        ),
                        SizedBox(width: 3),
                        Icon(Icons.arrow_back_ios_new, size: 11, color: _gold),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFFFF4E2),
      alignment: Alignment.center,
      child: const Icon(
        Icons.mosque_outlined,
        size: 36,
        color: Color(0xFF8A5A2B),
      ),
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _brown,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class HomeNeedCard extends StatelessWidget {
  const HomeNeedCard({
    super.key,
    required this.title,
    required this.image,
    this.progress,
    this.onTap,

    this.openBuilder,
  });

  final String title;
  final String image;
  final double? progress;
  final VoidCallback? onTap;

  final WidgetBuilder? openBuilder;

  static const darkBrown = Color(0xFF4A2A16);
  static const gold = Color(0xFFD6A343);

  Widget _buildOpenContainer() {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 650),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Color(0xFFD6A343),
      openColor: const Color.fromARGB(255, 155, 106, 16),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      openBuilder: (context, _) => openBuilder!(context),

      closedBuilder: (context, openContainer) {
        return Material(
          color: Colors.white,
          child: InkWell(onTap: openContainer, child: _buildCardContent()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (openBuilder != null) {
      return _buildOpenContainer();
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: _buildCardContent()),
    );
  }

  IconData _getFallbackIcon() {
    if (title.contains('سباكة')) return Icons.plumbing;
    if (title.contains('صوتيات')) return Icons.volume_up_outlined;
    if (title.contains('أبواب')) return Icons.door_front_door_outlined;
    if (title.contains('ترميم')) return Icons.handyman_outlined;
    if (title.contains('نظافة')) return Icons.cleaning_services_outlined;
    if (title.contains('مرافق')) return Icons.location_city_outlined;

    return Icons.mosque_outlined;
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0xFFF3E5D3),
      alignment: Alignment.center,
      child: Icon(_getFallbackIcon(), size: 42, color: darkBrown),
    );
  }

  Widget _buildCardContent() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: gold.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: image.isNotEmpty
                  ? Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackIcon();
                      },
                    )
                  : _buildFallbackIcon(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: darkBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                if (progress != null) ...[
                  LinearProgressIndicator(
                    value: progress!.clamp(0.0, 1.0),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: const Color(0xFFEDE5D8),
                    color: gold,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${(progress! * 100).round()}%',
                    style: const TextStyle(fontSize: 9, color: darkBrown),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

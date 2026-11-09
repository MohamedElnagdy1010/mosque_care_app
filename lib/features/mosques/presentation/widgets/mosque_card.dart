import 'package:flutter/material.dart';

class MosqueCard extends StatelessWidget {
  const MosqueCard({
    super.key,
    required this.name,
    required this.neighborhood,
    required this.onTap,
  });

  final String name;
  final String neighborhood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8D9C3)),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mosque_outlined,
                  color: Color(0xFF8A5A2B),
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2A16),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Color(0xFF9B8B7A),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            neighborhood,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9B8B7A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'عرض تفاصيل المسجد',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A5A2B)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: Color(0xFF8A5A2B)),
            ],
          ),
        ),
      ),
    );
  }
}

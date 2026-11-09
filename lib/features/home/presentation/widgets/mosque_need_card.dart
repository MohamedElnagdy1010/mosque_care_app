import 'package:flutter/material.dart';

import '../../domain/entities/mosque_need.dart';

class MosqueNeedCard extends StatelessWidget {
  const MosqueNeedCard({
    super.key,
    required this.mosqueName,
    required this.needs,
    required this.itemNames,
    this.onTap,
  });

  final String mosqueName;
  final List<MosqueNeed> needs;
  final Map<String, String> itemNames;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  const Icon(Icons.mosque_outlined, color: Color(0xFF8A5A2B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mosqueName,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2A16),
                      ),
                    ),
                  ),
                  Text(
                    '${needs.length} أعطال',
                    style: const TextStyle(
                      color: Color(0xFF8A5A2B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              for (final need in needs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      const Icon(
                        Icons.build_outlined,
                        size: 16,
                        color: Color(0xFF8A5A2B),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          itemNames[need.itemId] ?? need.itemId,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Text(
                        'الكمية: ${need.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A5A2B),
                        ),
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
}

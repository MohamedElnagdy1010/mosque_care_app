import 'package:flutter/material.dart';

import '../models/mosque_request_item.dart';

class MosqueRecentRequestsCard extends StatelessWidget {
  const MosqueRecentRequestsCard({
    super.key,
    required this.requests,
    this.onViewAll,
  });

  final List<MosqueRequestItem> requests;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final recentRequests = [...requests]
      ..sort((a, b) => b.date.compareTo(a.date));

    final visibleRequests = recentRequests.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.assignment_outlined, color: Color(0xFF8A5A2B)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'أحدث الطلبات',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2A16),
                  ),
                ),
              ),
              if (onViewAll != null && requests.length > 3)
                TextButton(onPressed: onViewAll, child: const Text('عرض الكل')),
            ],
          ),
          const Divider(height: 28),
          if (visibleRequests.isEmpty)
            const Text(
              'لا توجد طلبات مسجلة لهذا المسجد',
              style: TextStyle(fontSize: 14, color: Color(0xFF9B8B7A)),
            )
          else
            ...visibleRequests.map((request) {
              final date = request.date;
              final formattedDate = '${date.day}/${date.month}/${date.year}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A2A16),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'المصدر: ${request.source}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9B8B7A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9B8B7A),
                            ),
                          ),
                        ),
                        Text(
                          request.status,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A5A2B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

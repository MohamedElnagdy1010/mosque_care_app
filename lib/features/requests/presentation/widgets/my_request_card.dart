import 'package:flutter/material.dart';

import '../../domain/entities/request_summary.dart';
import 'request_status_badge.dart';

class MyRequestCard extends StatelessWidget {
  const MyRequestCard({super.key, required this.request, required this.onTap});

  final RequestSummary request;
  final VoidCallback onTap;

  static const darkBrown = Color(0xFF4A2A16);

  String get formattedDate {
    final date = request.createdAt.toLocal();

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE5D7B9)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'طلب رقم #${request.id}',
                      style: const TextStyle(
                        color: darkBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RequestStatusBadge(status: request.status),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                request.title,
                style: const TextStyle(
                  color: darkBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: darkBrown,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  const Text('التفاصيل', style: TextStyle(color: darkBrown)),
                  const Icon(Icons.chevron_left, color: darkBrown),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

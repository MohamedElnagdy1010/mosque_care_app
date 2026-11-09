import 'package:flutter/material.dart';

class ActiveNeedsSummary extends StatefulWidget {
  const ActiveNeedsSummary({super.key, required this.itemCounts});

  final Map<String, int> itemCounts;

  @override
  State<ActiveNeedsSummary> createState() => _ActiveNeedsSummaryState();
}

class _ActiveNeedsSummaryState extends State<ActiveNeedsSummary> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.summarize_outlined,
                color: Color(0xFF8A5A2B),
              ),
              title: const Text(
                'ملخص الأعطال النشطة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2A16),
                ),
              ),
              trailing: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            if (_isExpanded)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: widget.itemCounts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('لا توجد أعطال نشطة حاليًا'),
                      )
                    : ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        children: [
                          for (final entry in widget.itemCounts.entries)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value} مسجد',
                                    style: const TextStyle(
                                      color: Color(0xFF8A5A2B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

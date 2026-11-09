import 'package:flutter/material.dart';

class HomeNewsCard extends StatelessWidget {
  const HomeNewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    this.onTap,
  });

  final String title;
  final String description;
  final String image;
  final String date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF4A2A16);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8D5B8)),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8C735C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: brown,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          date,
                          style: const TextStyle(fontSize: 10, color: brown),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(image, height: 110, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

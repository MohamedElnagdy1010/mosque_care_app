import 'package:flutter/material.dart';

class MosqueSearchBar extends StatelessWidget {
  const MosqueSearchBar({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: 'ابحث باسم المسجد أو الحي...',
        hintStyle: const TextStyle(color: Color(0xFF9B8B7A), fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF4A2A16)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8D9C3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD6A343), width: 1.5),
        ),
      ),
    );
  }
}

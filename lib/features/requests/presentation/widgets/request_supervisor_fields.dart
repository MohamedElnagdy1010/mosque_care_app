import 'package:flutter/material.dart';

class RequestSupervisorFields extends StatelessWidget {
  const RequestSupervisorFields({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.roleController,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController roleController;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'بيانات مقدم الطلب',
            style: TextStyle(
              color: _brown,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: _decoration('الاسم', Icons.person_outline),
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            maxLength: 10,
            decoration: _decoration(
              'رقم الجوال',
              Icons.phone_outlined,
            ).copyWith(counterText: '', hintText: '05XXXXXXXX'),
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: roleController,
            textInputAction: TextInputAction.done,
            decoration: _decoration('الصفة', Icons.badge_outlined),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _brown),
      prefixIcon: Icon(icon, color: _gold),
      filled: true,
      fillColor: const Color(0xFFFFF9F0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _gold, width: 1.5),
      ),
    );
  }
}

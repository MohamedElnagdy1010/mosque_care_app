
import 'package:flutter/material.dart';

class RoleActionItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const RoleActionItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

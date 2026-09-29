import 'package:flutter/material.dart';

import '../../domain/auth_models.dart';

class RoleSelector extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;
  final Map<UserRole, String> labels;

  const RoleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.labels,
  });

  IconData _icon(UserRole role) => switch (role) {
        UserRole.student => Icons.school_outlined,
        UserRole.parent => Icons.family_restroom_outlined,
        UserRole.teacher => Icons.co_present_outlined,
        UserRole.school => Icons.apartment_outlined,
        UserRole.admin => Icons.admin_panel_settings_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: UserRole.values.map((role) {
        final active = role == selected;
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onChanged(role),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFEEF0FF) : const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active ? const Color(0xFF5B55E8) : const Color(0xFFE5E8F1),
                width: active ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon(role), size: 17, color: active ? const Color(0xFF5146D8) : const Color(0xFF667085)),
                const SizedBox(width: 6),
                Text(
                  labels[role] ?? role.key,
                  style: TextStyle(
                    color: active ? const Color(0xFF413AB8) : const Color(0xFF667085),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

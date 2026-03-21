import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _items = [
    (label: 'LEARN', icon: Icons.school),
    (label: 'REVIEW', icon: Icons.list_alt),
    (label: 'LIBRARY', icon: Icons.library_books),
    (label: 'PROFILE', icon: Icons.person_outline),
  ];

  Widget _buildIcon(IconData icon, bool selected) {
    if (!selected) {
      return Icon(icon, color: AppColors.navIconUnselected);
    }
    return ShaderMask(
      shaderCallback: (rect) =>
          AppColors.accentLinearGradient.createShader(rect),
      blendMode: BlendMode.srcIn,
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.navBarSurface,
          borderRadius: const BorderRadius.all(Radius.circular(28)),
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final selected = index == selectedIndex;

            final color =
                selected ? AppColors.primary : AppColors.navLabelUnselected;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => onSelected(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIcon(item.icon, selected),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}


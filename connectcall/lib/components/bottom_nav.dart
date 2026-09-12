import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'animated_gradient_bg.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AppBottomNav — matches BottomNavWidget + NavItemWidget from FlutterFlow
//  Fixed bottom navigation bar with icon + label tabs.
// ─────────────────────────────────────────────────────────────────────────────

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  static const _tabs = [
    _NavTab(icon: Icons.home_rounded, label: 'Home'),
    _NavTab(icon: Icons.people_rounded, label: 'Contacts'),
    _NavTab(icon: Icons.history_rounded, label: 'History'),
    _NavTab(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (i) {
              final isSelected = i == selectedIndex;
              final tab = _tabs[i];
              return _NavItem(
                icon: tab.icon,
                label: tab.label,
                isSelected: isSelected,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final String label;
  const _NavTab({required this.icon, required this.label});
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? AppColors.primary : AppColors.secondaryText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary20 : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

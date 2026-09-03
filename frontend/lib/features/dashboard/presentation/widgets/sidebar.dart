import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/router/route_names.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;

  const Sidebar({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(
          right: BorderSide(
            color: AppColors.border,
            width: 2.0,
          ),
        ),
      ),
      width: isCollapsed ? 70 : 250,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: isCollapsed ? 12 : 16,
            ),
            alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.logo_dev, color: AppColors.primary, size: 32),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SiteFlow",
                          style: AppTypography.heading2.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary
                          ),
                        ),
                        Text(
                          "Construction Site Management System",
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SidebarItem(
                    leadingIcon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    title: "Dashboard",
                    isCollapsed: isCollapsed,
                    isSelected: location == RoutePaths.dashboard,
                    onTap: () => context.go(RoutePaths.dashboard),
                  ),
                  SidebarItem(
                    leadingIcon: Icons.construction_outlined,
                    activeIcon: Icons.construction,
                    title: "Sites",
                    isCollapsed: isCollapsed,
                    isSelected: location.startsWith(RoutePaths.sites),
                    onTap: () => context.go(RoutePaths.sites),
                  ),
                  SidebarItem(
                    leadingIcon: Icons.task_outlined,
                    activeIcon: Icons.task,
                    title: "Tasks",
                    isCollapsed: isCollapsed,
                    isSelected: location.startsWith(RoutePaths.tasks),
                    onTap: () => context.go(RoutePaths.tasks),
                  ),
                  SidebarItem(
                    leadingIcon: Icons.description_outlined,
                    activeIcon: Icons.description,
                    title: "Reports",
                    isCollapsed: isCollapsed,
                    isSelected: location.startsWith(RoutePaths.reports),
                    onTap: () => context.go(RoutePaths.reports),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData leadingIcon;
  final IconData? activeIcon;
  final String title;
  final bool isCollapsed;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.leadingIcon,
    this.activeIcon,
    required this.title,
    required this.isCollapsed,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8 : 12,
        vertical: 4,
      ),
      child: Tooltip(
        message: isCollapsed ? title : '',
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: onTap,
            minLeadingWidth: isCollapsed ? 0 : 24,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            leading: Icon(
              isSelected ? (activeIcon ?? leadingIcon) : leadingIcon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            title: isCollapsed
                ? null
                : Text(
                    title,
                    style: AppTypography.bodyPrimary.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

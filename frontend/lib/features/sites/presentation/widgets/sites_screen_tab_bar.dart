import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class SitesScreenTabBar extends StatefulWidget {
  const SitesScreenTabBar({super.key});

  @override
  State<SitesScreenTabBar> createState() => _SitesScreenTabBarState();
}

class _SitesScreenTabBarState extends State<SitesScreenTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.zero,
      indicatorColor: AppColors.primary,
      dividerColor: AppColors.border,
      dividerHeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      labelStyle: TextStyle(
        fontFamily: 'Manrope',
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Manrope',
        color: AppColors.textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      isScrollable: true,
      tabs: [
        Tab(text: "All"),
        Tab(text: "Active"),
        Tab(text: "On Hold"),
        Tab(text: "Completed"),
        Tab(text: "Archived"),
      ],
    );
  }
}

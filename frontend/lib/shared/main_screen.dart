import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/dashboard/presentation/widgets/responsive.dart';
import 'package:frontend/features/dashboard/presentation/widgets/sidebar.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          title: const Text("SiteFlow"),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        drawer: const Drawer(
          child: Sidebar(isCollapsed: false),
        ),
        body: SafeArea(child: child),
      ),

      tablet: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              const Sidebar(isCollapsed: true),
              Expanded(child: child),
            ],
          ),
        ),
      ),

      desktop: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              const Sidebar(isCollapsed: false),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
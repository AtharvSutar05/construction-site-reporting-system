import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_spacing.dart';

class SiteMembersScreen extends StatelessWidget {
  const SiteMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Column(children: [Text("Site Members Screen")]),
        ),
      ),
    );
  }
}

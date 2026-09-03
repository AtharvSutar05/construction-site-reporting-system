import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/enums/site_status.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_state.dart';
import 'package:frontend/features/sites/presentation/widgets/site_status_widget.dart';
import 'package:intl/intl.dart';

class SiteInfoCard extends StatelessWidget {
  const SiteInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteDetailBloc, SiteDetailState>(
      builder: (context, state) {
        if (state is SiteDetailLoading) {
          return Container(
            height: 250,
            decoration: BoxDecoration(
              color: AppColors.loading.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.mdValue),
            ),
          );
        }
        if (state is SiteDetailLoaded) {
          final site = state.site;
          final hasCoordinates =
              site.latitude != null && site.longitude != null;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            padding: EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  code: site.code,
                  name: site.name,
                  status: site.status,
                ),
                SizedBox(height: AppSpacing.s),
                if (site.description != null &&
                    site.description!.trim().isNotEmpty) ...[
                  SizedBox(height: AppSpacing.m),
                  Text(
                    site.description!,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyPrimary,
                  ),
                ],
                SizedBox(height: AppSpacing.m),
                _buildInfoRow(
                  icon: Icons.location_city_outlined,
                  text: site.address,
                ),
                SizedBox(height: AppSpacing.xs),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  text: "${site.city}, ${site.state}, ${site.country}",
                ),
                if (hasCoordinates) ...[
                  SizedBox(height: AppSpacing.xs),
                  _buildInfoRow(
                    icon: Icons.my_location_outlined,
                    text:
                        "${site.latitude!.toStringAsFixed(5)}, ${site.longitude!.toStringAsFixed(5)}",
                  ),
                ],
                SizedBox(height: AppSpacing.m),
                Divider(color: AppColors.border, thickness: 1),
                SizedBox(height: AppSpacing.s),
                _buildMetaFooter(createdBy: site.createdBy, createdAt: site.createdAt, updatedAt: site.createdAt),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader({
    required String code,
    required String name,
    required SiteStatus status,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code, style: AppTypography.heading3),
                Text(
                  name,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.heading2,
                ),
              ],
            ),
          ),
          Positioned(right: 0, top: 0, child: SiteStatusWidget(status: status)),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(text, style: AppTypography.bodyPrimary)),
      ],
    );
  }

  Widget _buildMetaFooter({
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder.symmetric(
        outside: BorderSide.none, // Removes outer lines
        inside: BorderSide.none, // Keeps inner grid lines
      ),
      children: [
        TableRow(
          children: [
            Text(
              "Created by",
              style: AppTypography.badgeLabel.copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              createdBy,
              style: AppTypography.badgeLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              "Created at",
              style: AppTypography.badgeLabel.copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              dateFormat.format(createdAt),
              style: AppTypography.badgeLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              "Updated at",
              style: AppTypography.badgeLabel.copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              dateFormat.format(updatedAt),
              style: AppTypography.badgeLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

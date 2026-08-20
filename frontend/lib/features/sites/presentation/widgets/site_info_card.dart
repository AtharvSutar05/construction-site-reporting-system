import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/sites/data/models/site_detail_model.dart';
import 'package:frontend/features/sites/presentation/widgets/site_status_widget.dart';
import 'package:intl/intl.dart';

class SiteInfoCard extends StatelessWidget {
  final SiteDetailModel site;

  const SiteInfoCard({super.key, required this.site});

  bool get _hasCoordinates => site.latitude != null && site.longitude != null;

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
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
          _buildInfoRow(icon: Icons.location_city_outlined, text: site.address),
          SizedBox(height: AppSpacing.xs),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            text: "${site.city}, ${site.state}, ${site.country}",
          ),
          if (_hasCoordinates) ...[
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
          _buildMetaFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(site.code, style: AppTypography.heading3),
              Text(
                site.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.heading2,
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.s),
        SiteStatusWidget(status: site.status),
      ],
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

  Widget _buildMetaFooter() {
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
            const SizedBox(width: AppSpacing.xs,),
            Text(
              site.createdBy,
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
            const SizedBox(width: AppSpacing.xs,),
            Text(
              dateFormat.format(site.createdAt),
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
            const SizedBox(width: AppSpacing.xs,),
            Text(
              dateFormat.format(site.updatedAt),
              style: AppTypography.badgeLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Managed by ${site.createdBy}",
          style: AppTypography.badgeLabel.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          "Created ${dateFormat.format(site.createdAt)}",
          style: AppTypography.badgeLabel.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.xxs),
        Text(
          "Last updated ${dateFormat.format(site.updatedAt)}",
          style: AppTypography.badgeLabel.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

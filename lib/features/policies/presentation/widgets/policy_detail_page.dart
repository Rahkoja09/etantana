import 'package:e_tantana/features/policies/presentation/models/policy_content.dart';
import 'package:e_tantana/features/policies/presentation/widgets/policy_section_tile.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PolicyDetailPage extends StatelessWidget {
  final PolicyType policyType;

  const PolicyDetailPage({Key? key, required this.policyType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = policyType.sections;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        onBack: () => Navigator.pop(context),
        title: policyType.label,
      ),
      body: Column(
        children: [
          // Header
          _buildHeader(context),

          // Liste des sections
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: sections.length,
              itemBuilder:
                  (context, index) => PolicySectionTile(
                    section: sections[index],
                    index: index,
                    initiallyExpanded: index == 0,
                  ),
            ),
          ),

          // Footer
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: 8.w),
          Text(
            "Dernière mise à jour : ${PoliciesContent.lastUpdated}",
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.mail_outline_rounded,
            size: 14.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: 8.w),
          Text(
            "Questions ? ",
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          Text(
            PoliciesContent.contactEmail,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

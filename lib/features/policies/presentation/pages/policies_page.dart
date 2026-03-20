import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/policies/presentation/models/policy_content.dart';
import 'package:e_tantana/features/policies/presentation/widgets/policy_detail_page.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({Key? key}) : super(key: key);

  static const List<_PolicyCard> _cards = [
    _PolicyCard(
      type: PolicyType.terms,
      icon: HugeIcons.strokeRoundedFileEdit,
      description: "Règles d'utilisation de la plateforme",
    ),
    _PolicyCard(
      type: PolicyType.privacy,
      icon: HugeIcons.strokeRoundedShieldKey,
      description: "Comment nous gérons vos données",
    ),
    _PolicyCard(
      type: PolicyType.seller,
      icon: HugeIcons.strokeRoundedStore01,
      description: "Conditions pour les vendeurs",
    ),
    _PolicyCard(
      type: PolicyType.delivery,
      icon: HugeIcons.strokeRoundedDeliveryBox01,
      description: "Conditions pour les livreurs",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        onBack: () => Navigator.pop(context),
        title: "Politiques & conditions",
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          // Intro
          Text(
            "Transparence et confiance",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Consultez nos politiques pour comprendre comment ${PoliciesContent.appName} fonctionne et protège vos droits.",
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 28.h),

          // Cards
          ..._cards.map((card) => _buildPolicyCard(context, card)).toList(),

          SizedBox(height: 16.h),

          // Contact
          _buildContactBanner(context),
        ],
      ),
    );
  }

  Widget _buildPolicyCard(BuildContext context, _PolicyCard card) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PolicyDetailPage(policyType: card.type),
            ),
          ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
        ),
        child: Row(
          children: [
            // Icone
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: HugeIcon(
                  icon: card.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.type.label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    card.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(StylesConstants.borderRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.help_outline_rounded,
            size: 16.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                children: [
                  const TextSpan(text: "Des questions ? Contactez-nous à "),
                  TextSpan(
                    text: PoliciesContent.contactEmail,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
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

class _PolicyCard {
  final PolicyType type;
  final IconData icon;
  final String description;

  const _PolicyCard({
    required this.type,
    required this.icon,
    required this.description,
  });
}

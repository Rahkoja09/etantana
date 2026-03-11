import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/user/presentation/widgets/user_plan_mini_card.dart';
import 'package:e_tantana/shared/widget/mediaView/image_viewer.dart';
import 'package:e_tantana/shared/widget/text/vertical_custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilHeaderPreview extends StatefulWidget {
  final String imageFileOrLink;
  final String userName;
  final String email;
  final String userPlan;
  final int shopNumber;
  final String jobTitle;
  const ProfilHeaderPreview({
    super.key,
    required this.imageFileOrLink,
    required this.jobTitle,
    required this.shopNumber,
    required this.email,
    required this.userName,
    required this.userPlan,
  });

  @override
  State<ProfilHeaderPreview> createState() => _ProfilHeaderPreviewState();
}

class _ProfilHeaderPreviewState extends State<ProfilHeaderPreview> {
  @override
  Widget build(BuildContext context) {
    final profilVeiwerHeight = 80.h;
    return Container(
      constraints: BoxConstraints(maxHeight: 90),
      height: profilVeiwerHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: profilVeiwerHeight,
            width: profilVeiwerHeight,
            child: ImageViewer(
              imageFileOrLink: widget.imageFileOrLink,
              borderRadius: 80,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    widget.userName.split(' ')[0],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyles.titleSmall(
                      context: context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  UserPlanMiniCard(userPlan: widget.userPlan),
                ],
              ),
              Text(
                '${widget.email}',
                style: TextStyles.bodyMedium(
                  context: context,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.shopNumber} ',
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'boutique(s)',
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  VerticalCustomDivider(
                    width: 1,
                    color: Colors.grey,
                    height: 15,
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        '@',
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${widget.jobTitle.toLowerCase()}',
                        style: TextStyles.bodyMedium(
                          context: context,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

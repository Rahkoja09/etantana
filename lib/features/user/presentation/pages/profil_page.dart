import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/features/user/presentation/widgets/profil_header_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: Padding(
        padding: EdgeInsets.all(StylesConstants.spacerContent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mon Compte",
                  style: TextStyles.titleSmall(
                    fontSize: 18,
                    context: context,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                InkWell(
                  onTap: () {},
                  child: Icon(
                    HugeIcons.strokeRoundedQrCode,
                    size: 25,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ProfilHeaderPreview(
              imageFileOrLink: AppConst.defaultImage,
              jobTitle: "vendeur",
              shopNumber: 1,
              userId: "197289873892",
              userName: "nevaBeu",
              userPlan: "free",
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:e_tantana/config/theme/text_styles.dart';
import 'package:e_tantana/core/utils/tools/isUrl.dart';
import 'package:e_tantana/core/utils/tools/name_more_short.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextAppBar extends StatefulWidget {
  final String title;
  final String userName;
  final String imageLink;
  final int nameMaxLength;
  const TextAppBar({
    super.key,
    this.title = "Title",
    this.userName = "Content Of Title",
    this.imageLink = "assets/medias/images/defaultImage.png",
    this.nameMaxLength = 15,
  });

  @override
  State<TextAppBar> createState() => _TextAppBarState();
}

class _TextAppBarState extends State<TextAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: [
          Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 2,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image:
                    isUrl(widget.imageLink)
                        ? NetworkImage(widget.imageLink)
                        : AssetImage(widget.imageLink),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,

                style: TextStyles.bodyText(
                  context: context,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                NameMoreShort().shortenName(
                  widget.userName,
                  widget.nameMaxLength,
                ),
                style: TextStyles.bodyMedium(
                  context: context,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:e_tantana/features/policies/presentation/models/policy_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PolicySectionTile extends StatefulWidget {
  final PolicySection section;
  final int index;
  final bool initiallyExpanded;

  const PolicySectionTile({
    Key? key,
    required this.section,
    required this.index,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<PolicySectionTile> createState() => _PolicySectionTileState();
}

class _PolicySectionTileState extends State<PolicySectionTile>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _iconTurn;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: _expanded ? 1.0 : 0.0,
    );
    _iconTurn = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                // Numéro
                Container(
                  width: 26.r,
                  height: 26.r,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.index + 1}",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Titre
                Expanded(
                  child: Text(
                    widget.section.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),

                // Icone
                RotationTransition(
                  turns: _iconTurn,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Contenu expandable
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.only(left: 38.w, right: 8.w, bottom: 14.h),
            child: Text(
              widget.section.content,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.6,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),

        // Divider
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ],
    );
  }
}

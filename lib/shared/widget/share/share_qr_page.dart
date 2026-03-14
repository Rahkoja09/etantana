import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';

class ShareQrAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ShareQrAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class ShareQrPage extends StatefulWidget {
  final String qrData;
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final String? badgeLabel;
  final Color? accentColor;
  final List<ShareQrAction>? actions;
  final String? hint;

  const ShareQrPage({
    super.key,
    required this.qrData,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    this.badgeLabel,
    this.accentColor,
    this.actions,
    this.hint,
  });

  @override
  State<ShareQrPage> createState() => _ShareQrPageState();
}

class _ShareQrPageState extends State<ShareQrPage> {
  late QrImage _qrImage;

  @override
  void initState() {
    super.initState();
    _buildQr();
  }

  @override
  void didUpdateWidget(covariant ShareQrPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qrData != widget.qrData) _buildQr();
  }

  void _buildQr() {
    final qrCode = QrCode.fromData(
      data: widget.qrData,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    _qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: onSurface,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Partager",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12.h),

              Text(
                "Scannez ce code pour accéder",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: onSurface.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: onSurface,
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: 32.h),

              _QrCard(
                qrImage: _qrImage,
                accent: accent,
                isDark: isDark,
                avatarUrl: widget.avatarUrl,
                badgeLabel: widget.badgeLabel,
                onSurface: onSurface,
              ),

              SizedBox(height: 16.h),

              Text(
                widget.hint ?? "Ouvrez l'app E-Tantana et scannez ce code",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: onSurface.withValues(alpha: 0.35),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32.h),

              _DataChip(
                data: widget.qrData,
                accent: accent,
                isDark: isDark,
                onSurface: onSurface,
              ),

              SizedBox(height: 32.h),

              if (widget.actions != null && widget.actions!.isNotEmpty)
                _ActionsRow(actions: widget.actions!, accent: accent),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  final QrImage qrImage;
  final Color accent;
  final bool isDark;
  final String? avatarUrl;
  final String? badgeLabel;
  final Color onSurface;

  const _QrCard({
    required this.qrImage,
    required this.accent,
    required this.isDark,
    required this.onSurface,
    this.avatarUrl,
    this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final qrSize = 220.r;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow:
            isDark
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
      ),
      child: Column(
        children: [
          // Badge label
          if (badgeLabel != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badgeLabel!,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: accent,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // QR Code
          SizedBox(
            width: qrSize,
            height: qrSize,
            child: PrettyQrView(
              qrImage: qrImage,
              decoration: PrettyQrDecoration(
                shape: PrettyQrSmoothSymbol(color: accent),
                quietZone: PrettyQrQuietZone.standart,
                background: Colors.transparent,
              ),
            ),
          ),

          // Coin décoratifs accent
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20.w,
                height: 2.h,
                color: accent.withValues(alpha: 0.3),
              ),
              SizedBox(width: 6.w),
              Container(
                width: 6.w,
                height: 2.h,
                color: accent.withValues(alpha: 0.15),
              ),
              SizedBox(width: 6.w),
              Container(
                width: 6.w,
                height: 2.h,
                color: accent.withValues(alpha: 0.15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DataChip extends StatefulWidget {
  final String data;
  final Color accent;
  final bool isDark;
  final Color onSurface;

  const _DataChip({
    required this.data,
    required this.accent,
    required this.isDark,
    required this.onSurface,
  });

  @override
  State<_DataChip> createState() => _DataChipState();
}

class _DataChipState extends State<_DataChip> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.data));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color:
              _copied
                  ? widget.accent.withValues(alpha: 0.08)
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                _copied
                    ? widget.accent.withValues(alpha: 0.3)
                    : widget.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.data,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: widget.onSurface.withValues(alpha: 0.5),
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10.w),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child:
                  _copied
                      ? Icon(
                        Icons.check_rounded,
                        key: const ValueKey('check'),
                        size: 16,
                        color: widget.accent,
                      )
                      : HugeIcon(
                        key: const ValueKey('copy'),
                        icon: HugeIcons.strokeRoundedCopy01,
                        color: widget.onSurface.withValues(alpha: 0.4),
                        size: 16,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final List<ShareQrAction> actions;
  final Color accent;

  const _ActionsRow({required this.actions, required this.accent});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          actions
              .map(
                (action) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: action.onTap,
                    child: Column(
                      children: [
                        Container(
                          width: 52.r,
                          height: 52.r,
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: onSurface.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Center(
                            child: HugeIcon(
                              icon: action.icon,
                              color: onSurface.withValues(alpha: 0.7),
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          action.label,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

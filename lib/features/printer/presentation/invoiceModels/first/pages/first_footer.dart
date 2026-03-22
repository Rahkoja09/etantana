import 'package:e_tantana/features/printer/presentation/helper/invoice_helper.dart';
import 'package:e_tantana/features/printer/presentation/states/invoice_interactions_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstFooter extends StatelessWidget {
  final InvoiceInteractionsStates invoiceData;

  final String defaultSocietyName;
  final String defaultSocietyPhone;
  final String defaultQrCodePath;
  final String defaultSocialLabel;
  final String defaultSlogan;

  const FirstFooter({
    super.key,
    required this.invoiceData,
    this.defaultSocietyName = "E-Tantana",
    this.defaultSocietyPhone = "0380516686",
    this.defaultQrCodePath = "assets/medias/logos/scan_me.png",
    this.defaultSocialLabel = "Facebook",
    this.defaultSlogan = "Manome ny tsara indrindra ho anao",
  });

  @override
  Widget build(BuildContext context) {
    const color = Colors.black;

    final shopName = invoiceData.shopName ?? defaultSocietyName;
    final shopPhone = invoiceData.shopPhone ?? defaultSocietyPhone;
    final shopSlogan = invoiceData.shopSlogan ?? defaultSlogan;
    final shopSocialLink = invoiceData.shopSocialLink ?? defaultSocialLabel;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: Colors.black, thickness: 1.5),
        ),

        Center(
          child: Column(
            children: [
              Text(
                "SCANNEZ POUR NOUS SUIVRE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontFamily: "BrunoAceSC",
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 8.h),

              SizedBox(
                height: 250,
                width: 250,
                child: InvoiceHelper.buildQr(shopSocialLink, defaultQrCodePath),
              ),

              SizedBox(height: 8.h),
              // Nom boutique ---------------
              Center(
                child: Text(
                  shopName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: "BrunoAceSC",
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // Slogan -------------
        Center(
          child: Text(
            shopSlogan,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: "Nonito",
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8.h),

        // Téléphone ----------
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              shopPhone,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "BrunoAceSC",
                letterSpacing: 2,
              ),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: Colors.black26, thickness: 0.5),
        ),

        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Généré par E-Tantana",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black26,
                  fontFamily: "BrunoAceSC",
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}

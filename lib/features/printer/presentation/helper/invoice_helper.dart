import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class InvoiceHelper {
  static Widget buildQr(String data, String defaultQrCodePath) {
    if (data.isEmpty) {
      return Image.asset(defaultQrCodePath);
    }

    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final qrImage = QrImage(qrCode);

    return PrettyQrView(
      qrImage: qrImage,
      decoration: const PrettyQrDecoration(
        shape: PrettyQrSmoothSymbol(color: Colors.black),
        quietZone: PrettyQrQuietZone.standard,
        background: Colors.white,
      ),
    );
  }
}

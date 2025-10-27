import 'dart:convert';
import 'dart:ui' as ui;

import 'package:qr_flutter/qr_flutter.dart';

class QrCodeService {
  static Future<String?> generateAndSaveQrCode(String email) async {
    try {
      print('=== Starting QR Generation ===');
      print('Email: $email');

      // Create QR painter
      final qrPainter = QrPainter(
        data: email,
        version: QrVersions.auto,
        gapless: true,
      );

      // Render to image
      final image = await qrPainter.toImage(200);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        print('ERROR: byteData is null');
        return null;
      }

      // Convert to base64
      final bytes = byteData.buffer.asUint8List();
      final base64String = base64Encode(bytes);

      print('QR Generated Successfully');
      print('Base64 length: ${base64String.length}');

      return base64String;
    } catch (e) {
      print('QR Code Error: $e');
      print('Stack trace: ${StackTrace.current}');
      return null;
    }
  }
}

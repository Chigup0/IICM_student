import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeService {
  static Future<String> generateAndSaveQrCode(String email) async {
    try {
      // Generate QR code
      final qrPainter = QrPainter(
        data: email,
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF1E73BE),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF212121),
        ),
      );

      // Create image
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/qr_${email.hashCode}.png';
      final file = File(path);

      // Convert to image
      final size = 320.0;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawColor(const Color(0xFFFFFFFF), BlendMode.src);

      qrPainter.paint(canvas, Size(size, size));
      final picture = recorder.endRecording();

      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        await file.writeAsBytes(byteData.buffer.asUint8List());
        return path;
      }

      throw Exception('Failed to generate QR code image');
    } catch (e) {
      throw Exception('Error generating QR code: $e');
    }
  }
}

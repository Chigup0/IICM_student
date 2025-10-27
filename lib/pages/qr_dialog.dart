import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../constants/colors.dart';
import '../secure_storage.dart';

class QrDialog extends StatefulWidget {
  const QrDialog({super.key});

  @override
  State<QrDialog> createState() => _QrDialogState();
}

class _QrDialogState extends State<QrDialog> {
  double _previousBrightness = 0;

  @override
  void initState() {
    super.initState();
    _increaseBrightness();
  }

  @override
  void dispose() {
    _restoreBrightness();
    super.dispose();
  }

  Future<void> _increaseBrightness() async {
    try {
      _previousBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      print('Brightness Error: $e');
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(_previousBrightness);
    } catch (e) {
      print('Restore Brightness Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<String?>(
              future: SecureStorageService.getQrCodePath(),
              builder: (context, snapshot) {
                print(
                  'QR Dialog - Snapshot data: ${snapshot.data?.substring(0, 50)}...',
                );
                print(
                  'QR Dialog - Connection state: ${snapshot.connectionState}',
                );

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: AppColors.primaryText),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  try {
                    final base64Data = snapshot.data!;
                    final imageBytes = base64Decode(base64Data);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryAccent,
                          width: 2,
                        ),
                      ),
                      child: Image.memory(
                        imageBytes,
                        height: 300,
                        width: 300,
                        fit: BoxFit.contain,
                      ),
                    );
                  } catch (e) {
                    print('Error decoding base64: $e');
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Error displaying QR: $e',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                    );
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        color: AppColors.primaryAccent,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No QR code available',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

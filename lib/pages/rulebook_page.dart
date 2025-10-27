import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../constants/colors.dart';

class RulebookScreen extends StatefulWidget {
  const RulebookScreen({super.key});

  @override
  State<RulebookScreen> createState() => _RulebookScreenState();
}

class _RulebookScreenState extends State<RulebookScreen> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rulebook'),
        backgroundColor: AppColors.primaryAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SfPdfViewer.asset(
          'assets/rulebook.pdf',
          controller: _pdfViewerController,
          enableTextSelection: true,
          canShowScrollHead: true,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            print('PDF Loaded: ${details.document.pages.count} pages');
          },
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            print('PDF Load Failed: ${details.error}');
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}

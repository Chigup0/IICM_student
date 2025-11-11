import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../constants/colors.dart';

class RulebookScreen extends StatefulWidget {
  const RulebookScreen({super.key});

  @override
  State<RulebookScreen> createState() => _RulebookScreenState();
}

class _RulebookScreenState extends State<RulebookScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  final TextEditingController _searchController = TextEditingController();

  PdfTextSearchResult? _searchResult;
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResult = null);
      return;
    }

    setState(() => _isSearching = true);
    final result = await _pdfController.searchText(query);
    result.addListener(() => setState(() {}));
    setState(() {
      _searchResult = result;
      _isSearching = false;
    });
  }

  void _gotoNextMatch() => _searchResult?.nextInstance();
  void _gotoPreviousMatch() => _searchResult?.previousInstance();

  void _gotoPageDialog(BuildContext context) async {
    final controller = TextEditingController();
    final total = _pdfController.pageCount ?? 1;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Go to Page', style: TextStyle(color: AppColors.primaryText)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: AppColors.primaryText),
          decoration: InputDecoration(
            hintText: 'Enter page (1–$total)',
            hintStyle: TextStyle(color: AppColors.secondaryText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= total) {
                _pdfController.jumpToPage(page);
              }
              Navigator.pop(context);
            },
            child: Text('Go', style: TextStyle(color: AppColors.primaryAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _searchResult?.hasResult ?? false;
    final current = hasResults ? _searchResult!.currentInstanceIndex + 1 : 0;
    final total = hasResults ? _searchResult!.totalInstanceCount : 0;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBackground.withOpacity(0.9),
                    AppColors.secondaryBackground.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 35, bottom: 10),
              child: Row(
                children: [
                  /// back button
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryAccent),
                    onPressed: () => Navigator.pop(context),
                  ),

                  /// search bar + up/down controls
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.primaryAccent.withOpacity(0.3),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          /// 🔍 Search field (takes most width)
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(color: AppColors.primaryText),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search in rulebook...',
                                hintStyle:
                                    TextStyle(color: AppColors.secondaryText),
                                isDense: true,
                                contentPadding: EdgeInsets.only(bottom: 2),
                              ),
                              onSubmitted: (v) => _performSearch(v.trim()),
                            ),
                          ),

                          /// search icon (compact)
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.search_rounded,
                                color: AppColors.primaryAccent, size: 22),
                            onPressed: () =>
                                _performSearch(_searchController.text.trim()),
                          ),
                          const SizedBox(width: 4),

                          /// always visible up/down arrows + counter
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.keyboard_arrow_up_rounded,
                                    color: AppColors.secondaryAccent, size: 22),
                                onPressed: _gotoPreviousMatch,
                                tooltip: "Previous",
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Text(
                                  total == 0 ? "-" : "$current/$total",
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.secondaryAccent, size: 22),
                                onPressed: _gotoNextMatch,
                                tooltip: "Next",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// go-to-page icon
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.library_books_rounded,
                        color: AppColors.secondaryAccent),
                    onPressed: () => _gotoPageDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      /// PDF content
      body: Stack(
        children: [
          SfPdfViewer.asset(
            'assets/rulebook.pdf',
            controller: _pdfController,
            canShowPaginationDialog: false,
            canShowScrollHead: false,
            canShowScrollStatus: false,
            currentSearchTextHighlightColor:
                AppColors.secondaryAccent.withOpacity(0.5),
            otherSearchTextHighlightColor:
                AppColors.secondaryAccent.withOpacity(0.25),
          ),
          if (_isSearching)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}


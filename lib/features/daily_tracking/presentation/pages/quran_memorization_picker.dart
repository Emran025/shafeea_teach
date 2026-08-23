import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../config/di/injection.dart';
import '../../../../shared/themes/app_theme.dart';
import '../../data/datasources/quran_local_data_source.dart';

// ---------------------------------------------------------------------------
// Value objects
// ---------------------------------------------------------------------------

/// Represents a single Juz' (part) of the Quran, used only to draw the
/// 30 chapter-marker zebra divisions on the scrubber strip.
class QuranJuz {
  final int index;
  final int fromPage;
  final int toPage;

  const QuranJuz({
    required this.index,
    required this.fromPage,
    required this.toPage,
  });
}

/// Represents a single Mushaf page, carrying the surah / ayah context for
/// both its first and last ayah.  This is returned through [onConfirm].
class QuranPage {
  final int page;
  final String fromSurah;
  final int fromAyah;
  final String toSurah;
  final int toAyah;

  const QuranPage({
    required this.page,
    required this.fromSurah,
    required this.fromAyah,
    required this.toSurah,
    required this.toAyah,
  });
}

// ---------------------------------------------------------------------------
// Loaded data container
// ---------------------------------------------------------------------------

/// Holds all data that the picker needs, loaded once from the database.
class _QuranPickerData {
  final List<QuranJuz> juzList;

  /// Page-number → [QuranPage]. Keys are 1..totalPages.
  final Map<int, QuranPage> pageMap;

  const _QuranPickerData({required this.juzList, required this.pageMap});

  int get totalPages => pageMap.length;

  /// Returns the [QuranPage] for [page], clamped to the valid range.
  QuranPage pageInfo(int page) {
    final int clamped = page.clamp(1, totalPages);
    return pageMap[clamped]!;
  }

  /// Returns the Juz' index (1..30) that [page] belongs to.
  int juzForPage(int page) {
    for (final j in juzList) {
      if (page >= j.fromPage && page <= j.toPage) return j.index;
    }
    return juzList.last.index;
  }
}

// ---------------------------------------------------------------------------
// Data-loading helper  (queries the Quran SQLite database)
// ---------------------------------------------------------------------------

/// Builds a [_QuranPickerData] from the [Tracking_Unit] and [Sora] tables.
///
/// * unit_id = 1 → 30 Juz' rows → [QuranJuz] list for the strip dividers.
/// * unit_id = 5 → 604 page rows → [QuranPage] map for surah/ayah lookups.
Future<_QuranPickerData> _loadPickerData(QuranLocalDataSource ds) async {
  // Run both queries concurrently.
  final results = await Future.wait([
    ds.getTrackingUnitsByType(1), // juz
    ds.getTrackingUnitsByType(5), // page
  ]);

  final juzRows = results[0];
  final pageRows = results[1];

  // Build juz list — index is the sequential order in the result (1-based).
  final juzList = <QuranJuz>[];
  for (int i = 0; i < juzRows.length; i++) {
    final row = juzRows[i];
    juzList.add(
      QuranJuz(index: i + 1, fromPage: row.fromPage, toPage: row.toPage),
    );
  }

  // Build page map — keyed by the page number carried in [toSurahName].
  final pageMap = <int, QuranPage>{};
  for (final row in pageRows) {
    pageMap[row.fromPage] = QuranPage(
      page: row.fromPage,
      fromSurah: row.fromSurahName,
      fromAyah: row.fromAyah,
      toSurah: row.toSurahName,
      toAyah: row.toAyah,
    );
  }

  return _QuranPickerData(juzList: juzList, pageMap: pageMap);
}

// ---------------------------------------------------------------------------
// Public entry-point
// ---------------------------------------------------------------------------

/// Shows the Quran memorisation range-picker dialog.
///
/// The dialog presents a continuous scrubber strip divided into 30 Juz'
/// segments.  The user taps to set an anchor page, then taps/drags a second
/// point; the confirmed range is passed to [onConfirm].
///
/// **Direction / sign rule (edge-locked selection):**
/// A memorization range is always anchored to one edge of the Mushaf. The
/// edge is chosen automatically from the user's first interaction and then
/// locked until Reset is pressed:
/// * fixed endpoint = page 1   ("from the beginning") → `signedPages` is **positive**.
/// * fixed endpoint = page 604 ("from the end")        → `signedPages` is **negative**.
/// The magnitude is simply `|highPage − lowPage| + 1` (a page count).
Future<void> showQuranMemorizationPickerDialog({
  required BuildContext context,
  int? initialFromPage,
  int? initialToPage,
  required void Function(
    int fromPage,
    int toPage,
    QuranPage fromInfo,
    QuranPage toInfo,
    int signedPages,
  )
  onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (_) => _QuranPickerDialog(
      initialFromPage: initialFromPage,
      initialToPage: initialToPage,
      onConfirm: onConfirm,
    ),
  );
}

// ---------------------------------------------------------------------------
// Dialog widget
// ---------------------------------------------------------------------------

class _QuranPickerDialog extends StatefulWidget {
  final int? initialFromPage;
  final int? initialToPage;
  final void Function(
    int fromPage,
    int toPage,
    QuranPage fromInfo,
    QuranPage toInfo,
    int signedPages,
  )
  onConfirm;

  const _QuranPickerDialog({
    required this.initialFromPage,
    required this.initialToPage,
    required this.onConfirm,
  });

  @override
  State<_QuranPickerDialog> createState() => _QuranPickerDialogState();
}

class _QuranPickerDialogState extends State<_QuranPickerDialog> {
  late final Future<_QuranPickerData> _dataFuture;

  /// The first point placed by the user.
  int? _anchorPage;

  /// The second point placed by the user.
  int? _secondPage;

  @override
  void initState() {
    super.initState();
    _anchorPage = widget.initialFromPage;
    _secondPage = widget.initialToPage;
    _dataFuture = _loadPickerData(sl<QuranLocalDataSource>());
  }

  // Edge-locked selection: the first interaction decides which edge of the
  // Mushaf is fixed (page 1 or the last page, e.g. 604) based on which edge
  // the tap is nearer to. `_anchorPage` now always holds that fixed edge and
  // never changes again until Reset; only `_secondPage` (the movable thumb)
  // is updated by subsequent taps.
  void _placePoint(int page, int totalPages) {
    setState(() {
      if (_anchorPage == null) {
        final int midpoint = (1 + totalPages) ~/ 2;
        _anchorPage = page <= midpoint ? 1 : totalPages;
        _secondPage = page;
      } else {
        _secondPage = page;
      }
    });
  }

  // The fixed endpoint must never move once a direction has been locked, so
  // dragging the anchor thumb is now a no-op.
  void _dragAnchorTo(int page) {}
  void _dragSecondTo(int page) => setState(() => _secondPage = page);

  void _resetSelection() => setState(() {
    _anchorPage = null;
    _secondPage = null;
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_QuranPickerData>(
      future: _dataFuture,
      builder: (ctx, snap) {
        if (snap.hasError) {
          return _errorShell(ctx, snap.error.toString());
        }
        if (!snap.hasData) {
          return _loadingShell(ctx);
        }
        return _pickerContent(ctx, snap.data!);
      },
    );
  }

  // -------------------------------------------------------------------------
  // Loading / error shells (same outer decoration as the main dialog)
  // -------------------------------------------------------------------------

  Widget _dialogShell({required Widget child}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.lightCream.withOpacity(0.1),
        insetPadding: const EdgeInsets.all(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxHeight: 560),
            decoration: BoxDecoration(
              color: AppColors.lightCream.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightCream26),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _loadingShell(BuildContext ctx) {
    return _dialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          CircularProgressIndicator(color: AppColors.lightCream),
          const SizedBox(height: 16),
          Text(
            'جارٍ تحميل بيانات المصحف…',
            style: TextStyle(color: AppColors.lightCream.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _errorShell(BuildContext ctx, String message) {
    return _dialogShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
          const SizedBox(height: 12),
          Text(
            'تعذّر تحميل بيانات المصحف',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.lightCream,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.lightCream.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.lightCream26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Main picker content
  // -------------------------------------------------------------------------

  Widget _pickerContent(BuildContext ctx, _QuranPickerData data) {
    // Derived selection values — recomputed each build from current state.
    final int? lowPage = (_anchorPage != null && _secondPage != null)
        ? (_anchorPage! <= _secondPage! ? _anchorPage : _secondPage)
        : null;
    final int? highPage = (_anchorPage != null && _secondPage != null)
        ? (_anchorPage! <= _secondPage! ? _secondPage : _anchorPage)
        : null;

    int? signedPages;
    if (_anchorPage != null && _secondPage != null) {
      // Sign now depends only on which edge is fixed: page 1 fixed → positive,
      // last page (e.g. 604) fixed → negative — not on tap order.
      final bool startFixed = _anchorPage == 1;
      final int magnitude = highPage! - lowPage! + 1;
      signedPages = startFixed ? magnitude : -magnitude;
    }

    final QuranPage? fromInfo = lowPage != null ? data.pageInfo(lowPage) : null;
    final QuranPage? toInfo = highPage != null ? data.pageInfo(highPage) : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.lightCream.withOpacity(0.1),
        insetPadding: const EdgeInsets.all(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 560),
            decoration: BoxDecoration(
              color: AppColors.lightCream.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightCream26),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Header row ---
                Row(
                  children: [
                    IconButton(
                      onPressed: _anchorPage != null ? _resetSelection : null,
                      icon: const Icon(Icons.refresh),
                      color: AppColors.lightCream,
                      tooltip: 'إعادة التحديد',
                    ),
                    const Expanded(
                      child: Text(
                        'اختر نطاق الحفظ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightCream,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'اضغط لتحديد نقطة البداية، ثم نقطة النهاية — يمكنك السحب لضبط أي صفحة بدقة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightCream.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 18),

                // --- Scrubber strip ---
                SizedBox(
                  height: 64,
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      final double w = constraints.maxWidth;
                      final int total = data.totalPages;

                      double xForPage(int page) => (page - 1) / total * w;

                      int pageForLocalDx(double dx) {
                        final double fraction = (1 - (dx / w)).clamp(0.0, 1.0);
                        // dx is measured from the LEFT edge of the strip
                        // (page 1 is on the RIGHT because of surrounding RTL).
                        return (fraction * (total - 1)).round() + 1;
                      }

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) {
                          _placePoint(
                            pageForLocalDx(details.localPosition.dx),
                            total,
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Base track + 30 Juz' zebra segments + dividers.
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  children: [
                                    Container(
                                      color: AppColors.lightCream.withOpacity(
                                        0.08,
                                      ),
                                    ),
                                    for (final j in data.juzList)
                                      Positioned(
                                        right: xForPage(j.fromPage),
                                        width:
                                            (xForPage(j.toPage) -
                                                xForPage(j.fromPage)) +
                                            (w / total),
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                          color: j.index.isOdd
                                              ? AppColors.lightCream
                                                    .withOpacity(0.03)
                                              : Colors.transparent,
                                          alignment: Alignment.bottomCenter,
                                          padding: const EdgeInsets.only(
                                            bottom: 3,
                                          ),
                                          child:
                                              (xForPage(j.toPage) -
                                                      xForPage(j.fromPage)) >
                                                  16
                                              ? Text(
                                                  '${j.index}',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: AppColors.lightCream
                                                        .withOpacity(0.35),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                    // Divider lines at Juz' boundaries.
                                    for (final j in data.juzList.skip(1))
                                      Positioned(
                                        right: xForPage(j.fromPage),
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 1,
                                          color: AppColors.lightCream26,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // Selection highlight.
                            if (lowPage != null && highPage != null)
                              Positioned(
                                right: xForPage(lowPage),
                                width:
                                    (xForPage(highPage + 1) - xForPage(lowPage))
                                        .clamp(2.0, w),
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.45),
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: AppColors.accent,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Draggable thumb — anchor point.
                            if (_anchorPage != null)
                              _StripThumb(
                                x: xForPage(_anchorPage!),
                                totalWidth: w,
                                color: Colors.white,
                                onDragToLeftDx: (dx) =>
                                    _dragAnchorTo(pageForLocalDx(dx)),
                              ),

                            // Draggable thumb — second point.
                            if (_secondPage != null)
                              _StripThumb(
                                x: xForPage(_secondPage!),
                                totalWidth: w,
                                color: AppColors.accent,
                                onDragToLeftDx: (dx) =>
                                    _dragSecondTo(pageForLocalDx(dx)),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // --- Live summary of the selected range ---
                if (fromInfo != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.lightCream.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightCream26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SummaryLine(
                          label: 'من',
                          surah: fromInfo.fromSurah,
                          page: lowPage!,
                          ayah: fromInfo.fromAyah,
                          juz: data.juzForPage(lowPage),
                        ),
                        if (toInfo != null) ...[
                          const SizedBox(height: 6),
                          _SummaryLine(
                            label: 'إلى',
                            surah: toInfo.toSurah,
                            page: highPage!,
                            ayah: toInfo.toAyah,
                            juz: data.juzForPage(highPage),
                          ),
                        ],
                        if (signedPages != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                'عدد الصفحات: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightCream,
                                ),
                              ),
                              Text(
                                signedPages > 0
                                    ? '+$signedPages'
                                    : '$signedPages',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: signedPages >= 0
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  Text(
                    'لم يتم تحديد أي نطاق بعد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.lightCream.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),

                const SizedBox(height: 16),

                // --- Action buttons ---
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.lightCream26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            (fromInfo != null &&
                                toInfo != null &&
                                signedPages != null)
                            ? () {
                                widget.onConfirm(
                                  lowPage!,
                                  highPage!,
                                  fromInfo,
                                  toInfo,
                                  signedPages!,
                                );
                                Navigator.of(ctx).pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('تأكيد'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StripThumb — draggable circular handle on the scrubber strip
// ---------------------------------------------------------------------------

/// A small draggable circular handle positioned on the strip.
///
/// [x] is measured from the **right** edge (matching the RTL page-1-on-the-right
/// layout).  [onDragToLeftDx] reports the new finger position as a
/// **left**-measured dx (0 = left edge of the strip), ready to pass straight
/// into `pageForLocalDx`.
class _StripThumb extends StatelessWidget {
  final double x;
  final double totalWidth;
  final Color color;
  final ValueChanged<double> onDragToLeftDx;

  const _StripThumb({
    required this.x,
    required this.totalWidth,
    required this.color,
    required this.onDragToLeftDx,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 22;
    return Positioned(
      right: (x - size / 2).clamp(-size / 2, totalWidth - size / 2),
      top: 0,
      bottom: 0,
      child: Builder(
        builder: (thumbContext) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            final RenderBox? stripBox = thumbContext
                .findAncestorRenderObjectOfType<RenderStack>();
            if (stripBox == null) return;
            final Offset local = stripBox.globalToLocal(details.globalPosition);
            onDragToLeftDx(local.dx);
          },
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.black26, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SummaryLine — one row in the selection summary panel
// ---------------------------------------------------------------------------

class _SummaryLine extends StatelessWidget {
  final String label;
  final String surah;
  final int page;
  final int ayah;
  final int juz;

  const _SummaryLine({
    required this.label,
    required this.surah,
    required this.page,
    required this.ayah,
    required this.juz,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.lightCream,
          ),
        ),
        Expanded(
          child: Text(
            '$surah  •  آية $ayah  •  صفحة $page  •  الجزء $juz',
            style: TextStyle(color: AppColors.lightCream.withOpacity(0.85)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/* --------------------------------------------------------------------------
 * USAGE EXAMPLE
 * --------------------------------------------------------------------------
 * int? selectedFromPage;
 * int? selectedToPage;
 * int? selectedSignedPages;
 *
 * ElevatedButton(
 *   onPressed: () => showQuranMemorizationPickerDialog(
 *     context: context,
 *     initialFromPage: selectedFromPage,
 *     initialToPage: selectedToPage,
 *     onConfirm: (toSurahName, toPage, fromInfo, toInfo, signedPages) {
 *       setState(() {
 *         selectedFromPage  = toSurahName;
 *         selectedToPage    = toPage;
 *         selectedSignedPages = signedPages; // e.g. +150 or -150
 *       });
 *     },
 *   ),
 *   child: const Text('اختيار نطاق الحفظ'),
 * )
 */

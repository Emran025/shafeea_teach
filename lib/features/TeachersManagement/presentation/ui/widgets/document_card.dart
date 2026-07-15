import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/document_entity.dart';

/// A card widget that displays document metadata and provides
/// "View" (open in browser) and "Download" (save to local storage) actions.
class DocumentCard extends StatefulWidget {
  final DocumentEntity document;

  const DocumentCard({super.key, required this.document});

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _isDownloading = false;
  double _downloadProgress = 0;

  /// Opens the file URL in the system browser.
  Future<void> _openInBrowser() async {
    final url = widget.document.fileUrl;
    if (url == null) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذّر فتح الرابط', style: GoogleFonts.cairo()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Downloads the file via Dio and saves it to the device Downloads folder.
  Future<void> _downloadFile() async {
    final url = widget.document.fileUrl;
    if (url == null) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = url.split('/').last;
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم الحفظ في: $savePath', style: GoogleFonts.cairo()),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل التحميل: ${e.toString()}',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: doc.hasFile
              ? AppColors.accent.withOpacity(0.4)
              : AppColors.lightCream38,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: doc.hasFile
                        ? AppColors.accent.withOpacity(0.15)
                        : AppColors.lightCream38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _iconForType(doc.certificateType),
                    size: 22,
                    color: doc.hasFile
                        ? AppColors.accent
                        : AppColors.lightCream70,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.name,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightCream,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _TypeBadge(
                        label: doc.certificateTypeOther?.isNotEmpty == true
                            ? doc.certificateTypeOther!
                            : doc.certificateType,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Metadata rows ──────────────────────────────────────────────
          if (doc.riwayah != null) ...[
            _MetaRow(
              icon: Icons.menu_book_rounded,
              label: 'الرواية',
              value: doc.riwayah!,
            ),
          ],
          if (doc.issuingPlace != null) ...[
            _MetaRow(
              icon: Icons.location_on_outlined,
              label: 'جهة الإصدار',
              value: doc.issuingPlace!,
            ),
          ],
          if (doc.issuingDate != null) ...[
            _MetaRow(
              icon: Icons.calendar_today_outlined,
              label: 'تاريخ الإصدار',
              value: doc.issuingDate!,
            ),
          ],

          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1),

          // ── Actions ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: doc.hasFile ? _buildActions() : _buildNoFileState(),
          ),

          // Download progress indicator
          if (_isDownloading) ...[
            LinearProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
              color: AppColors.accent,
              backgroundColor: AppColors.accent.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // View button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _openInBrowser,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              side: BorderSide(color: AppColors.accent.withOpacity(0.7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: AppColors.accent,
            ),
            label: Text(
              'عرض',
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Download button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isDownloading ? null : _downloadFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.accent.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              _isDownloading
                  ? Icons.hourglass_top_rounded
                  : Icons.download_rounded,
              size: 16,
              color: AppColors.lightCream,
            ),
            label: Text(
              _isDownloading ? 'جارٍ التحميل…' : 'تحميل',
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.lightCream,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoFileState() {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: AppColors.lightCream70,
        ),
        const SizedBox(width: 8),
        Text(
          'لا يوجد ملف مرفق',
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: AppColors.lightCream70,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  IconData _iconForType(String type) {
    if (type.contains('إجازة')) return Icons.verified_rounded;
    if (type.contains('حفظ')) return Icons.auto_stories_rounded;
    if (type.contains('سيرة')) return Icons.badge_rounded;
    return Icons.description_rounded;
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final String label;
  const _TypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 11,
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.lightCream70),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: AppColors.lightCream70,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppColors.lightCream,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

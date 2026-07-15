import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';

import '../../../domain/entities/document_entity.dart';
import 'document_card.dart';

/// A section widget that renders a teacher's uploaded documents.
///
/// Shows a header, then either a list of [DocumentCard]s or an empty-state
/// placeholder if [documents] is empty.
class DocumentsSection extends StatelessWidget {
  final List<DocumentEntity> documents;

  const DocumentsSection({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────────────────
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.folder_copy_rounded,
                size: 18,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'المستندات والوثائق',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.lightCream,
              ),
            ),
            const SizedBox(width: 8),
            if (documents.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${documents.length}',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightCream,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        // ── Content ────────────────────────────────────────────────────
        if (documents.isEmpty)
          _EmptyDocuments()
        else
          ...documents.map((doc) => DocumentCard(document: doc)),
      ],
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightCream38),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 36,
            color: AppColors.lightCream38,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد وثائق مرفوعة',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.lightCream70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

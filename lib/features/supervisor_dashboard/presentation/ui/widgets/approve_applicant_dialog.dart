import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApproveApplicantDialog extends StatefulWidget {
  final int applicantId;
  final VoidCallback onConfirm;

  ApproveApplicantDialog({
    super.key,
    required this.applicantId,
    required this.onConfirm,
  });

  @override
  State<ApproveApplicantDialog> createState() => _ApproveApplicantDialogState();
}

class _ApproveApplicantDialogState extends State<ApproveApplicantDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10nStrings.AppStrings.confirmAcceptance,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(L10nStrings.AppStrings.confirmAcceptApplicantQuestion),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text('إلغاء'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isLoading = true;
                            });
                            widget.onConfirm();
                          },
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(L10nStrings.AppStrings.accept),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

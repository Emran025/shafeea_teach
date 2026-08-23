import 'package:shafeea_teach/core/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApproveApplicantDialog extends StatefulWidget {
  final int applicantId;
  final VoidCallback onConfirm;

  const ApproveApplicantDialog({
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
              AppStrings.str_teach_rem_370_1573,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(AppStrings.str_teach_rem_371_22d2),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text(AppStrings.str_teach_rem_14_62a9),
                  ),
                ),
                const SizedBox(width: 12),
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
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(AppStrings.str_teach_rem_127_d99d),
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

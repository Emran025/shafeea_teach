import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ShorebirdUpdateService {
  static final ShorebirdUpdateService _instance = ShorebirdUpdateService._internal();
  factory ShorebirdUpdateService() => _instance;
  ShorebirdUpdateService._internal();

  final ShorebirdUpdater _updater = ShorebirdUpdater();
  bool _isChecking = false;

  /// Checks for updates asynchronously without blocking the UI.
  Future<void> checkForUpdates(BuildContext context) async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final status = await _updater.checkForUpdate();
      if (!context.mounted) return;

      if (status == UpdateStatus.outdated) {
        await _performUpdate(context);
      } else if (status == UpdateStatus.restartRequired) {
        _showRestartBanner(context);
      }
    } catch (e) {
      debugPrint('Shorebird check error: $e');
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _performUpdate(BuildContext context) async {
    try {
      await _updater.update();
      if (!context.mounted) return;
      _showRestartBanner(context);
    } on UpdateException catch (e) {
      debugPrint('Shorebird update failed: ${e.message}');
    }
  }

  void _showRestartBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: AppColors.accent,
        content: Text(
          'تم تنزيل تحديث جديد. يرجى إعادة التشغيل لتطبيقه.',
          style: GoogleFonts.cairo(color: AppColors.lightCream, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              'موافق',
              style: GoogleFonts.cairo(color: AppColors.lightCream),
            ),
          ),
        ],
      ),
    );
  }
}

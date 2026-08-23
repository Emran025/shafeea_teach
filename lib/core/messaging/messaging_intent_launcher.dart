import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shafeea/core/constants/countries_names.dart';

enum WhatsAppFlavor {
  standard('com.whatsapp'),
  business('com.whatsapp.w4b');

  final String packageName;

  const WhatsAppFlavor(this.packageName);

  String get displayName =>
      this == standard ? 'واتساب' : 'واتساب للأعمال';
}

/// Opens the platform SMS composer or WhatsApp with pre-filled [text] (offline intent).
abstract final class MessagingIntentLauncher {
  static const MethodChannel _channel = MethodChannel('app.shafeea.teach/whatsapp_intent');

  static Future<bool> openSmsWithBody(String text, {String? phoneNumber}) {
    final uriStr = phoneNumber != null && phoneNumber.trim().isNotEmpty
        ? 'sms:+${phoneNumber.trim()}?body=${Uri.encodeComponent(text)}'
        : 'sms:?body=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(uriStr);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<bool> isPackageInstalled(WhatsAppFlavor flavor) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'checkPackageInstalled',
        {'packageName': flavor.packageName},
      );
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<bool> shareToWhatsApp({
    required WhatsAppFlavor flavor,
    String? phoneNumber,
    String? message,
    String? fileAbsolutePath,
  }) async {
    try {
      String? cleanPhone;
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        cleanPhone = _formatPhoneNumber(phoneNumber);
      }

      await _channel.invokeMethod(
        'shareToWhatsApp',
        {
          'packageName': flavor.packageName,
          'phoneNumber': cleanPhone,
          'message': message,
          'filePath': fileAbsolutePath,
        },
      );
      return true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static String _formatPhoneNumber(String phoneNumber) {
    var formattedPhone = phoneNumber.replaceAll(RegExp(r'[\+\-\(\)\s]'), '');
    
    // Remove leading '00' for international numbers
    if (formattedPhone.startsWith('00')) {
      return formattedPhone.substring(2);
    }

    String defaultDialCode = '967'; // Default fallback (Yemen)
    try {
      final isoCode = ui.PlatformDispatcher.instance.locale.countryCode;
      if (isoCode != null) {
        final country = countries.firstWhere((c) => c.status == isoCode);
        defaultDialCode = country.countryCallingCode.replaceAll(RegExp(r'[^0-9]'), '');
      }
    } catch (_) {}

    // Handle common local formats if missing country code
    if (formattedPhone.startsWith('0')) {
      // Most countries use 0 as a trunk prefix for local numbers
      return '$defaultDialCode${formattedPhone.substring(1)}';
    } else if (formattedPhone.length >= 8 && formattedPhone.length <= 10 && !formattedPhone.startsWith(defaultDialCode)) {
      // Typical length of local numbers without the 0 prefix in Arab countries is 8 to 10 digits
      return '$defaultDialCode$formattedPhone';
    }

    return formattedPhone;
  }

  /// Opens the specified WhatsApp flavor with [text] pre-filled for [phoneNumber].
  /// Uses ACTION_VIEW with the whatsapp:// scheme so it works for both
  /// WhatsApp standard and WhatsApp Business without a file attachment.
  static Future<bool> openWhatsAppTextOnly(
    WhatsAppFlavor flavor,
    String text, {
    String? phoneNumber,
  }) async {
    try {
      String? cleanPhone;
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        cleanPhone = _formatPhoneNumber(phoneNumber);
      }

      await _channel.invokeMethod(
        'shareToWhatsApp',
        {
          'packageName': flavor.packageName,
          'phoneNumber': cleanPhone,
          'message': text,
          'filePath': null, // text-only — no file
        },
      );
      return true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Legacy fallback for platforms where intents fail or for broad web fallback
  static Future<bool> openWhatsAppWithText(String text, {String? phoneNumber}) {
    String formattedPhone = '';
    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      formattedPhone = _formatPhoneNumber(phoneNumber);
    }

    final uriStr = formattedPhone.isNotEmpty
        ? 'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(text)}'
        : 'https://wa.me/?text=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(
      uriStr,
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

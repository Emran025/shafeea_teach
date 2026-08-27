import 'package:flutter/services.dart';

enum WhatsAppFlavor {
  standard('com.whatsapp', 'واتساب'),
  business('com.whatsapp.w4b', 'واتساب للأعمال');

  final String packageName;
  final String label;
  const WhatsAppFlavor(this.packageName, this.label);
}

class WhatsAppIntentLauncher {
  static const MethodChannel _channel = MethodChannel('app.shafeea/whatsapp_intent');

  static Future<bool> isPackageInstalled(WhatsAppFlavor flavor) async {
    try {
      return await _channel.invokeMethod<bool>(
            'checkPackageInstalled',
            {'packageName': flavor.packageName},
          ) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> shareFileToWhatsApp({
    required WhatsAppFlavor flavor,
    String? phoneNumber,
    String? message,
    required String fileAbsolutePath,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'shareToWhatsApp',
        {
          'packageName': flavor.packageName,
          'phoneNumber': phoneNumber,
          'message': message,
          'filePath': fileAbsolutePath,
        },
      );
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}

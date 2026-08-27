import 'package:flutter/services.dart';

enum WhatsAppFlavor {
  standard('com.whatsapp'),
  business('com.whatsapp.w4b');
  final String packageName;
  const WhatsAppFlavor(this.packageName);
}

class WhatsAppIntentLauncher {
  static const MethodChannel _channel = MethodChannel('app.shafeea/whatsapp_intent');

  static Future<bool> shareFileToWhatsApp({
    required WhatsAppFlavor flavor,
    String? phoneNumber,
    String? message,
    String? fileAbsolutePath,
  }) async {
    try {
      await _channel.invokeMethod(
        'shareToWhatsApp',
        {
          'packageName': flavor.packageName,
          'phoneNumber': phoneNumber,
          'message': message,
          'filePath': fileAbsolutePath,
        },
      );
      return true;
    } on PlatformException catch (e) {
      print('WhatsApp share failed: ${e.message}');
      return false;
    }
  }
}

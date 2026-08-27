import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import '../utils/whatsapp_intent_launcher.dart';

class CertificateBatchScreen extends StatelessWidget {
  final String batchId;
  final List<Map<String, dynamic>> certificates = [
    {
      'id': 1,
      'recipient_name': 'أحمد محمد',
      'recipient_whatsapp': '966500000001',
      'file_path_pdf': 'https://shafeea.com/certs/uuid1.pdf'
    }
  ];

  CertificateBatchScreen({Key? key, required this.batchId}) : super(key: key);

  Future<void> _downloadAndShare(BuildContext context, String phone, String name, String url) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري تجهيز الملف...')));
    try {
      // Mock download logic
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5), onTimeout: () => http.Response('Mock PDF', 200));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/certificate_$name.pdf');
      await file.writeAsBytes(response.bodyBytes);

      final message = 'السلام عليكم $name،\nمرفق شهادتك.';
      
      // Attempt to share via WhatsApp Standard
      bool success = await WhatsAppIntentLauncher.shareFileToWhatsApp(
        flavor: WhatsAppFlavor.standard,
        phoneNumber: phone,
        message: message,
        fileAbsolutePath: file.path,
      );

      // Fallback to Business
      if (!success) {
        success = await WhatsAppIntentLauncher.shareFileToWhatsApp(
          flavor: WhatsAppFlavor.business,
          phoneNumber: phone,
          message: message,
          fileAbsolutePath: file.path,
        );
      }

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر العثور على تطبيق واتساب.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ أثناء التجهيز: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج الدفعة #$batchId', style: GoogleFonts.cairo()),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.builder(
        itemCount: certificates.length,
        itemBuilder: (context, index) {
          final cert = certificates[index];
          return ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.accent, child: Icon(Icons.picture_as_pdf, color: Colors.white)),
            title: Text(cert['recipient_name'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            subtitle: Text(cert['recipient_whatsapp'] ?? 'لا يوجد رقم'),
            trailing: cert['recipient_whatsapp'] != null
                ? IconButton(
                    icon: Icon(Icons.send, color: Colors.green),
                    onPressed: () => _downloadAndShare(context, cert['recipient_whatsapp'], cert['recipient_name'], cert['file_path_pdf']),
                  )
                : null,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';

class CertificateBatchScreen extends StatelessWidget {
  final String batchId;
  // Mock data representing the API response from /certificates/batch/{batchId}
  final List<Map<String, dynamic>> certificates = [
    {
      'id': 1,
      'recipient_name': 'أحمد محمد',
      'recipient_whatsapp': '966500000001',
      'file_path_pdf': 'https://shafeea.com/certs/uuid1.pdf'
    },
    {
      'id': 2,
      'recipient_name': 'خالد عبدالله',
      'recipient_whatsapp': '966500000002',
      'file_path_pdf': 'https://shafeea.com/certs/uuid2.pdf'
    },
  ];

  CertificateBatchScreen({Key? key, required this.batchId}) : super(key: key);

  Future<void> _sendWhatsApp(String phone, String name, String link) async {
    final message = Uri.encodeComponent('السلام عليكم $name،\nمرفق رابط شهادتك:\n$link');
    final url = Uri.parse('whatsapp://send?phone=$phone&text=$message');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Fallback to WhatsApp Web/API if app is not installed
      final webUrl = Uri.parse('https://wa.me/$phone?text=$message');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
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
            leading: CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Icon(Icons.picture_as_pdf, color: Colors.white),
            ),
            title: Text(cert['recipient_name'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            subtitle: Text(cert['recipient_whatsapp'] ?? 'لا يوجد رقم'),
            trailing: cert['recipient_whatsapp'] != null
                ? IconButton(
                    icon: Icon(Icons.send, color: Colors.green),
                    tooltip: 'إرسال عبر واتساب',
                    onPressed: () => _sendWhatsApp(
                      cert['recipient_whatsapp'],
                      cert['recipient_name'],
                      cert['file_path_pdf'],
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/whatsapp_intent_launcher.dart';

class CertificateBatchScreen extends StatefulWidget {
  final String batchId;

  const CertificateBatchScreen({
    super.key,
    required this.batchId,
  });

  @override
  State<CertificateBatchScreen> createState() => _CertificateBatchScreenState();
}

class _CertificateBatchScreenState extends State<CertificateBatchScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _batchData;
  List<dynamic> _certificates = [];

  @override
  void initState() {
    super.initState();
    _fetchBatchData();
  }

  Future<void> _fetchBatchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('https://api.shafeea.com/api/v1/certificates/batches/${widget.batchId}'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _batchData = data['data']['batch'];
          _certificates = data['data']['certificates'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في جلب البيانات: $e')),
        );
      }
    }
  }

  Future<WhatsAppFlavor?> _chooseWhatsAppFlavor() async {
    final installed = <WhatsAppFlavor>[];
    for (final flavor in WhatsAppFlavor.values) {
      if (await WhatsAppIntentLauncher.isPackageInstalled(flavor)) {
        installed.add(flavor);
      }
    }

    if (!mounted) return null;
    if (installed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم العثور على واتساب أو واتساب للأعمال.')),
      );
      return null;
    }
    if (installed.length == 1) return installed.single;

    return showModalBottomSheet<WhatsAppFlavor>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: installed
              .map(
                (flavor) => ListTile(
                  leading: const Icon(Icons.send, color: Colors.green),
                  title: Text(flavor.label),
                  onTap: () => Navigator.of(context).pop(flavor),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _downloadAndShare(Map<String, dynamic> certificate) async {
    final phone = (certificate['recipient_whatsapp'] ?? '').toString().trim();
    final fileUrl = (certificate['file_url_pdf'] ?? certificate['file_url_jpg'] ?? '')
        .toString()
        .trim();
    final name = (certificate['recipient_name'] ?? 'recipient').toString();

    if (phone.isEmpty || fileUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم واتساب أو رابط الشهادة غير متوفر.')),
      );
      return;
    }

    final flavor = await _chooseWhatsAppFlavor();
    if (flavor == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري تنزيل الشهادة وتجهيزها...')),
    );

    try {
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('Certificate download failed: ${response.statusCode}');
      }

      final extension = fileUrl.toLowerCase().contains('.jpg') ||
              fileUrl.toLowerCase().contains('.jpeg')
          ? 'jpg'
          : 'pdf';
      final safeName = name.replaceAll(RegExp(r'[^a-zA-Z0-9\u0600-\u06FF]'), '_');
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/certificate_$safeName.$extension');
      await file.writeAsBytes(response.bodyBytes, flush: true);

      final success = await WhatsAppIntentLauncher.shareFileToWhatsApp(
        flavor: flavor,
        phoneNumber: phone,
        message: 'السلام عليكم $name، مرفق شهادتك.',
        fileAbsolutePath: file.path,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'تم تجهيز الشهادة داخل ${flavor.label}; اضغط إرسال في واتساب.'
              : 'تعذر فتح ${flavor.label} لإرفاق الشهادة.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر تجهيز الشهادة: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج الدفعة #${widget.batchId}', style: GoogleFonts.cairo()),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchBatchData,
            tooltip: 'تحديث الحالة',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_batchData != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الحالة: ${_batchData!['status']}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            'الإنجاز: ${_batchData!['processed_count']} / ${_batchData!['total_count']}'),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _certificates.length,
                    itemBuilder: (context, index) {
                      final certificate = _certificates[index];
                      final name = (certificate['recipient_name'] ?? 'بدون اسم').toString();
                      final phone = (certificate['recipient_whatsapp'] ?? '').toString();
                      final status = certificate['status'] ?? 'pending';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: status == 'generated' ? Colors.green : Colors.orange,
                          child: const Icon(Icons.picture_as_pdf, color: Colors.white),
                        ),
                        title: Text(name, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                        subtitle: Text(phone.isEmpty ? 'لا يوجد رقم واتساب' : phone),
                        trailing: status == 'generated' && phone.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.send, color: Colors.green),
                                tooltip: 'إرسال ملف الشهادة عبر واتساب',
                                onPressed: () => _downloadAndShare(certificate),
                              )
                            : status == 'generated'
                                ? const Icon(Icons.check, color: Colors.green)
                                : const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

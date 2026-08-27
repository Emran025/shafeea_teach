import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'certificate_batch_screen.dart';

class CertificateStudioScreen extends StatefulWidget {
  const CertificateStudioScreen({super.key});

  @override
  State<CertificateStudioScreen> createState() => _CertificateStudioScreenState();
}

class _CertificateStudioScreenState extends State<CertificateStudioScreen> {
  File? _templateImage;
  List<Map<String, dynamic>> _boxes = [];
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _templateImage = File(picked.path);
        _boxes = [];
      });
    }
  }

  Future<void> _pickCsv() async {
    // Mocking CSV import for now
    setState(() {
      _students = [
        {'name': 'أحمد محمد', 'phone': '966500000001'},
        {'name': 'خالد عبدالله', 'phone': '966500000002'},
      ];
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم استيراد ${_students.length} طالب بنجاح (تجريبي)')),
      );
    }
  }

  void _addBox() {
    setState(() {
      _boxes.add({
        'key': 'field_${_boxes.length + 1}',
        'x': 50.0,
        'y': 50.0,
        'width': 200.0,
        'height': 40.0,
        'font_size': 24,
        'color': '#000000',
        'alignment': 'center',
      });
    });
  }

  Future<void> _submitBatch() async {
    if (_templateImage == null || _boxes.isEmpty || _students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار القالب، إضافة الحقول، واستيراد الطلاب')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bytes = await _templateImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final payload = {
        'template_name': 'دفعة شهادات',
        'background_image': 'data:image/jpeg;base64,$base64Image',
        'font_family': 'cairo',
        'boxes': _boxes,
        'students': _students.map((s) => {
          ...s,
          'recipient_name': s['name'] ?? s['اسم الطالب'] ?? 'بدون اسم',
          'recipient_whatsapp': s['phone'] ?? s['whatsapp'] ?? s['رقم الجوال'],
        }).toList(),
      };

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('https://api.shafeea.com/api/v1/certificates/batches'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final batchId = data['data']['batch_id'].toString();
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CertificateBatchScreen(batchId: batchId),
            ),
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء الإرسال: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('استوديو الشهادات', style: GoogleFonts.cairo()),
        backgroundColor: Colors.blue,
        actions: [
          if (_isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CircularProgressIndicator(color: Colors.white),
            ))
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _submitBatch,
              tooltip: 'اعتماد وتوليد',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('القالب'),
                ),
                ElevatedButton.icon(
                  onPressed: _addBox,
                  icon: const Icon(Icons.add_box),
                  label: const Text('حقل جديد'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickCsv,
                  icon: const Icon(Icons.file_upload),
                  label: Text('الطلاب (${_students.length})'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _templateImage == null
                ? const Center(child: Text('الرجاء اختيار صورة القالب للبدء'))
                : InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Center(
                      child: Stack(
                        children: [
                          Image.file(_templateImage!),
                          ..._boxes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final box = entry.value;
                            return Positioned(
                              left: box['x'],
                              top: box['y'],
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    _boxes[index]['x'] += details.delta.dx;
                                    _boxes[index]['y'] += details.delta.dy;
                                  });
                                },
                                child: Container(
                                  width: box['width'],
                                  height: box['height'],
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red, width: 2),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      box['key'],
                                      style: TextStyle(
                                        fontSize: box['font_size'].toDouble(),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';

class CertificateStudioScreen extends StatefulWidget {
  @override
  _CertificateStudioScreenState createState() => _CertificateStudioScreenState();
}

class _CertificateStudioScreenState extends State<CertificateStudioScreen> {
  File? _templateImage;
  List<Map<String, dynamic>> _fields = [];

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _templateImage = File(result.files.single.path!);
      });
    }
  }

  void _addField() {
    setState(() {
      _fields.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'حقل جديد',
        'x': 50.0,
        'y': 50.0,
        'size': 24.0,
        'color': Colors.black,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('استوديو الشهادات', style: GoogleFonts.cairo()),
        backgroundColor: AppColors.primary,
      ),
      body: Row(
        children: [
          // Sidebar Controls
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('رفع قالب الشهادة'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic to pick Excel and extract headers
                    },
                    icon: Icon(Icons.table_chart),
                    label: Text('استيراد Excel'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addField,
                    icon: Icon(Icons.add_box),
                    label: Text('إضافة حقل ديناميكي'),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        // Logic to send Payload to Laravel API
                      },
                      child: Text('توليد الدفعة', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Canvas Area
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: _templateImage == null
                    ? Text('يرجى رفع قالب الشهادة', style: GoogleFonts.cairo(fontSize: 20))
                    : Stack(
                        children: [
                          Image.file(_templateImage!),
                          ..._fields.map((field) {
                            return Positioned(
                              left: field['x'],
                              top: field['y'],
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    field['x'] += details.delta.dx;
                                    field['y'] += details.delta.dy;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue, width: 2),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    field['name'],
                                    style: TextStyle(
                                      fontSize: field['size'],
                                      color: field['color'],
                                      fontWeight: FontWeight.bold,
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

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MushafSyncService {
  final FlutterSecureStorage _storage;
  final String _baseUrl;

  MushafSyncService(this._storage, {required String baseUrl}) : _baseUrl = baseUrl;

  /// Triggered when the teacher taps a word to mark it as an error.
  /// This strictly sends the event to the backend, without altering the local Mushaf rendering logic.
  Future<void> markError(String sessionId, int surah, int ayah, int wordIndex) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    final url = Uri.parse('$_baseUrl/api/v1/calls/$sessionId/mark-error');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'surah': surah,
          'ayah': ayah,
          'word_index': wordIndex,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to mark error: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception marking error: $e');
    }
  }
}

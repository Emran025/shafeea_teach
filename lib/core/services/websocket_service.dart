import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class WebSocketService {
  final FlutterSecureStorage _storage;
  WebSocketChannel? _channel;
  final String _baseUrl;
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  WebSocketService(this._storage, {required String baseUrl}) : _baseUrl = baseUrl;

  Future<void> connect() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      debugPrint('WebSocket: No auth token found, cannot connect.');
      return;
    }

    final wsUrl = Uri.parse('$_baseUrl/app/reverb-app-key?protocol=7&client=js&version=8.4.0-rc2&flash=false');
    
    try {
      _channel = WebSocketChannel.connect(wsUrl);
      
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          _messageController.add(data);
        },
        onError: (error) {
          debugPrint('WebSocket Error: $error');
          _reconnect();
        },
        onDone: () {
          debugPrint('WebSocket Connection Closed');
          _reconnect();
        },
      );

      _subscribeToPrivateChannel(token);
      
    } catch (e) {
      debugPrint('WebSocket Connection Exception: $e');
      _reconnect();
    }
  }

  Future<void> _subscribeToPrivateChannel(String token) async {
    final channelName = 'private-user.MOCK_USER_ID'; 
    
    try {
      final authUrl = Uri.parse('$_baseUrl/broadcasting/auth');
      final response = await http.post(
        authUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'socket_id': '12345.67890',
          'channel_name': channelName,
        },
      );

      if (response.statusCode == 200) {
        final authData = jsonDecode(response.body);
        final authSignature = authData['auth'];
        
        final authMessage = {
          "event": "pusher:subscribe",
          "data": {
            "auth": authSignature,
            "channel": channelName
          }
        };
        send(authMessage);
      } else {
        debugPrint('WebSocket Auth Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('WebSocket Auth Exception: $e');
    }
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_channel == null || _channel?.closeCode != null) {
        connect();
      }
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

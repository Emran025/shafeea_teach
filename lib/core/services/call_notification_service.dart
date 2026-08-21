import 'dart:async';
import 'package:flutter/foundation.dart';
import 'websocket_service.dart';

class CallNotificationService {
  final WebSocketService _wsService;
  StreamSubscription? _subscription;
  
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNotificationReceived => _notificationController.stream;

  CallNotificationService(this._wsService);

  void listen() {
    _subscription = _wsService.messages.listen((data) {
      if (data['event'] == 'call_session_notification') {
        final payload = data['data'];
        if (payload != null) {
          _notificationController.add(payload);
          _handleNotification(payload);
        }
      }
    });
  }

  void _handleNotification(Map<String, dynamic> payload) {
    final action = payload['action'];
    final sessionId = payload['session_id'];
    
    switch (action) {
      case 'requested':
        debugPrint('Incoming call request for session: $sessionId');
        // Show incoming call dialog/overlay
        break;
      case 'accepted':
        debugPrint('Call accepted for session: $sessionId');
        // Navigate to call screen or start WebRTC stream
        break;
      case 'rejected':
        debugPrint('Call rejected for session: $sessionId');
        // Dismiss calling screen, show toast
        break;
      case 'ended':
        debugPrint('Call ended for session: $sessionId');
        // End WebRTC stream, close call screen
        break;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _notificationController.close();
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart' as pc;

class WebRtcCryptoService {
  final Function(Map<String, dynamic>) onSignalReady;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  
  final _remoteStreamController = StreamController<MediaStream>.broadcast();
  Stream<MediaStream> get remoteStream => _remoteStreamController.stream;

  pc.AsymmetricKeyPair<pc.PublicKey, pc.PrivateKey>? _rsaKeyPair;
  String? _peerPublicKey;

  WebRtcCryptoService({required this.onSignalReady});

  Future<void> initialize() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      onSignalReady({
        'type': 'candidate',
        'candidate': candidate.toMap(),
      });
    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      _remoteStreamController.add(stream);
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });
    
    _peerConnection!.addStream(_localStream!);
  }

  String getPublicKey() {
    return "MOCK_PUBLIC_KEY";
  }

  void setPeerPublicKey(String key) {
    _peerPublicKey = key;
  }

  Future<void> createOffer() async {
    if (_peerConnection == null) return;
    
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    
    onSignalReady({
      'type': 'offer',
      'sdp': offer.sdp,
      'public_key': getPublicKey(),
    });
  }

  Future<void> handleSignal(Map<String, dynamic> data) async {
    if (_peerConnection == null) return;

    if (data['type'] == 'offer') {
      if (data['public_key'] != null) setPeerPublicKey(data['public_key']);
      
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
      
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      
      onSignalReady({
        'type': 'answer',
        'sdp': answer.sdp,
        'public_key': getPublicKey(),
      });
    } else if (data['type'] == 'answer') {
      if (data['public_key'] != null) setPeerPublicKey(data['public_key']);
      
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
    } else if (data['type'] == 'candidate') {
      await _peerConnection!.addCandidate(
        RTCIceCandidate(
          data['candidate']['candidate'],
          data['candidate']['sdpMid'],
          data['candidate']['sdpMLineIndex'],
        ),
      );
    }
  }

  void dispose() {
    _localStream?.dispose();
    _peerConnection?.dispose();
    _remoteStreamController.close();
  }
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:pointycastle/pointycastle.dart';

class CryptoService {
  late pc.AsymmetricKeyPair<pc.PublicKey, pc.PrivateKey> _rsaKeyPair;
  encrypt.Key? _sessionAesKey;
  encrypt.IV? _sessionAesIv;

  CryptoService() {
    _generateRSAKeys();
  }

  /// 1. Generate RSA Key Pair (Public/Private)
  void _generateRSAKeys() {
    final secureRandom = pc.SecureRandom('Fortuna')
      ..seed(pc.KeyParameter(Uint8List.fromList(List.generate(32, (_) => Random.secure().nextInt(255)))));
    final keyGen = pc.RSAKeyGenerator()
      ..init(pc.ParametersWithRandom(
          pc.RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), secureRandom));
    _rsaKeyPair = keyGen.generateKeyPair();
  }

  String get publicKeyPem {
    // In a real app, convert pc.RSAPublicKey to PEM format string.
    // Placeholder for PEM conversion.
    return "MOCK_PEM_PUBLIC_KEY"; 
  }

  /// 2. Generate AES Session Key (Symmetric)
  void generateSessionKey() {
    _sessionAesKey = encrypt.Key.fromSecureRandom(32); // AES-256
    _sessionAesIv = encrypt.IV.fromSecureRandom(16);
  }

  /// 3. Encrypt AES Key with Target's RSA Public Key
  String encryptSessionKey(String targetPublicKeyPem) {
    if (_sessionAesKey == null) throw Exception("Session key not generated");
    // Parse targetPublicKeyPem and encrypt _sessionAesKey.bytes using RSA.
    // Placeholder logic:
    final combined = "${base64Encode(_sessionAesKey!.bytes)}:${base64Encode(_sessionAesIv!.bytes)}";
    return base64Encode(utf8.encode("RSA_ENCRYPTED_[$combined]"));
  }

  /// 4. Decrypt received AES Key using our RSA Private Key
  void decryptAndSetSessionKey(String encryptedSessionKeyPayload) {
    // Decrypt using _rsaKeyPair.privateKey
    // Placeholder logic:
    final decoded = utf8.decode(base64Decode(encryptedSessionKeyPayload));
    final parts = decoded.replaceAll("RSA_ENCRYPTED_[", "").replaceAll("]", "").split(":");
    _sessionAesKey = encrypt.Key(base64Decode(parts[0]));
    _sessionAesIv = encrypt.IV(base64Decode(parts[1]));
  }

  /// 5. Encrypt Audio Frame (Mock structure for WebRTC Insertable Streams)
  Uint8List encryptAudioFrame(Uint8List frameData) {
    if (_sessionAesKey == null || _sessionAesIv == null) return frameData;
    final encrypter = encrypt.Encrypter(encrypt.AES(_sessionAesKey!));
    final encrypted = encrypter.encryptBytes(frameData, iv: _sessionAesIv!);
    return Uint8List.fromList(encrypted.bytes);
  }

  /// 6. Decrypt Audio Frame
  Uint8List decryptAudioFrame(Uint8List encryptedFrameData) {
    if (_sessionAesKey == null || _sessionAesIv == null) return encryptedFrameData;
    final encrypter = encrypt.Encrypter(encrypt.AES(_sessionAesKey!));
    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedFrameData), iv: _sessionAesIv!);
    return Uint8List.fromList(decrypted);
  }
}

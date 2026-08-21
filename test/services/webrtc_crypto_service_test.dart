import 'package:flutter_test/flutter_test.dart';
import 'package:shafeea/core/services/webrtc_crypto_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  group('WebRtcCryptoService Tests', () {
    late WebRtcCryptoService cryptoService;

    setUp(() {
      cryptoService = WebRtcCryptoService(onSignalReady: (signal) {});
    });

    test('getPublicKey should return a string', () {
      final key = cryptoService.getPublicKey();
      expect(key, isNotNull);
      expect(key, isA<String>());
    });

    test('setPeerPublicKey should not throw', () {
      expect(() => cryptoService.setPeerPublicKey('DUMMY_KEY'), returnsNormally);
    });
  });
}

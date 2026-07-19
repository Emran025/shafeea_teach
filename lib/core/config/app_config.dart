/// AppConfig
///
/// Compile-time constants injected via `--dart-define` during the CI build.
/// In School-Locked mode, the build system embeds SCHOOL_ID, SCHOOL_CODE,
/// and APP_KEY so the application is permanently scoped to a single school.
///
/// In General Mode (default dev build), all values are empty strings and the
/// app behaves exactly as before — no school restriction, full multi-school
/// support, backward compatible.
///
/// Usage in CI (school-locked build):
///   flutter build apk --release \
///     --dart-define=SCHOOL_ID=5 \
///     --dart-define=SCHOOL_CODE=al-riyadh \
///     --dart-define=APP_KEY=abc123...
///
/// Usage in development (general mode):
///   flutter run   ← no --dart-define flags needed
final class AppConfig {
  AppConfig._(); // non-instantiable

  // ── School identity (embedded at build time) ────────────────────────────────

  /// The numeric ID of the school this APK was built for.
  /// Empty string in General Mode.
  static const String schoolId = String.fromEnvironment('SCHOOL_ID');

  /// The unique slug of the school (e.g. "al-riyadh").
  /// Empty string in General Mode.
  static const String schoolCode = String.fromEnvironment('SCHOOL_CODE');

  /// The App Key embedded in School-Locked APKs.
  /// Sent via the `X-App-Key` header on every API request.
  /// The backend resolves this key to a school context and restricts all
  /// subsequent operations to that school.
  /// Empty string in General Mode.
  static const String appKey = String.fromEnvironment('APP_KEY');

  // ── Mode detection ──────────────────────────────────────────────────────────

  /// True when this APK was built for a specific school (School-Locked Mode).
  static bool get isSchoolLocked => appKey.isNotEmpty;

  /// True in General Mode — the app can serve any school.
  static bool get isGeneralMode => !isSchoolLocked;
}

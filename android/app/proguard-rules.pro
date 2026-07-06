# android/app/proguard-rules.pro  [shafeea_teach]
# ──────────────────────────────────────────────────────────────────────────────
# POLICY: Only permanent, structurally-required rules belong here.
# Do NOT add dontwarn/keep rules to suppress annotation library warnings —
# those are symptoms of incorrect dependencies, not a proguard problem.
#
# Rules removed:
#   -dontwarn javax.annotation.**         (was compileOnly hack symptom)
#   -keep class javax.annotation.**       (was compileOnly hack symptom)
#   -dontwarn com.google.errorprone.**    (was compileOnly hack symptom)
#   -keep class com.google.errorprone.**  (was compileOnly hack symptom)
# ──────────────────────────────────────────────────────────────────────────────

# ── Flutter engine ────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keepclassmembers class io.flutter.** { *; }

# ── WorkManager (required: worker classes need accessible constructors) ───────
-keep class androidx.work.** { *; }
-keepclassmembers class * extends androidx.work.Worker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-keepclassmembers class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}

# ── SQLite / sqflite ─────────────────────────────────────────────────────────
-keep class com.tekartik.sqflite.** { *; }

# ── Dart VM / Obfuscation ─────────────────────────────────────────────────────
# --obfuscate is passed at flutter build time; R8 handles the rest.
# No additional rules needed unless runtime reflection is used.

# ── Google Play Core (Fix for R8 missing classes) ─────────────────────────────
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
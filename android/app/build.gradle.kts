// android/app/build.gradle.kts  [shafeea_teach]
// ──────────────────────────────────────────────────────────────────────────────
// Production-grade configuration.
//   • No System.getenv() signing hacks
//   • No compileOnly annotation workarounds
//   • No id("kotlin-android") — Flutter built-in Kotlin handles this
//   • Signing driven entirely by Gradle project properties (-P flags)
//     injected by the CI build script at runtime only.
// ──────────────────────────────────────────────────────────────────────────────

plugins {
    id("com.android.application")
    // kotlin-android is intentionally omitted: the Flutter Gradle plugin
    // (dev.flutter.flutter-gradle-plugin) provides built-in Kotlin support
    // since Flutter 3.x. Keeping it would cause KGP conflicts in future builds.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.shafeea.teach"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // ── Signing ────────────────────────────────────────────────────────────
    // Credentials are passed as Gradle project properties via -P flags.
    // They are set ONLY by the CI build script — never by environment variables
    // read inside this file, and never committed to version control.
    //
    // Local development builds fall back to the debug keystore automatically
    // when signing properties are absent (hasSigningConfig == false).
    val keystorePath  = findProperty("RELEASE_STORE_FILE")?.toString()
    val keystorePass  = findProperty("RELEASE_STORE_PASSWORD")?.toString()
    val keyAlias      = findProperty("RELEASE_KEY_ALIAS")?.toString()
    val keyPass       = findProperty("RELEASE_KEY_PASSWORD")?.toString()
    val hasSigningConfig = keystorePath != null

    signingConfigs {
        if (hasSigningConfig) {
            create("release") {
                storeFile     = file(keystorePath!!)
                storePassword = keystorePass
                this.keyAlias = keyAlias
                keyPassword   = keyPass
            }
        }
    }

    defaultConfig {
        applicationId = "com.shafeea.teach"
        minSdk    = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = if (hasSigningConfig) {
                signingConfigs.getByName("release")
            } else {
                // Safe fallback: debug keys for local dev builds only.
                // CI always provides signing properties, so this path is
                // never reached in production.
                signingConfigs.getByName("debug")
            }

            isMinifyEnabled   = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // Required for Java 8+ API desugaring on older Android versions.
    // This is the only legitimate dependency at this level.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Note: compileOnly(errorprone) and compileOnly(jsr305) have been removed.
    // They were workarounds for annotation resolution warnings during KGP
    // compilation and are not required with the Flutter built-in Kotlin approach.
}

flutter {
    source = "../.."
}

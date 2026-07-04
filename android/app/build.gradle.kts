plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ── Release signing: read from CI environment variables ──────────────────────
// These are set by the GitHub Actions workflow via `env:` on the build step.
// When running locally they will be null, so the build falls back to debug keys.
val releaseStoreFile    = System.getenv("RELEASE_STORE_FILE")
val releaseStorePassword = System.getenv("RELEASE_STORE_PASSWORD")
val releaseKeyAlias     = System.getenv("RELEASE_KEY_ALIAS")
val releaseKeyPassword  = System.getenv("RELEASE_KEY_PASSWORD")

android {
    namespace = "com.example.shafeea"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // ── Signing configurations ────────────────────────────────────────────────
    signingConfigs {
        create("release") {
            if (releaseStoreFile != null) {
                storeFile      = file(releaseStoreFile)
                storePassword  = releaseStorePassword
                keyAlias       = releaseKeyAlias
                keyPassword    = releaseKeyPassword
            }
        }
    }

    defaultConfig {
        applicationId = "com.example.shafeea"
        minSdk    = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use the release signing config when keystore env vars are present (CI),
            // otherwise fall back to debug keys for local development.
            signingConfig = if (releaseStoreFile != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Enable R8 code shrinking and resource shrinking for production builds.
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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    compileOnly("com.google.errorprone:error_prone_annotations:2.18.0")
    compileOnly("javax.annotation:javax.annotation-api:1.3.2")
}

flutter {
    source = "../.."
}

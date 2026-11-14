// PATCH lokal CareerPath (2026-11-14): suppress deprecation ERROR pada aksesor blok `android{}`
// (DSL lama BaseAppModuleExtension) di AGP 9.3.1. DSL lama WAJIB tetap dipakai karena plugin
// Flutter 3.32.8 masih memakai applicationVariants. Hapus baris ini hanya saat Flutter di-upgrade.
@file:Suppress("DEPRECATION")

plugins {
    id("com.android.application")
    // PATCH lokal CareerPath (2026-11-14): Google Services dinonaktifkan SEMENTARA karena
    // google-services.json belum ada (milik Orang 2/pemilik Firebase — flutterfire configure
    // butuh login akun). Aktifkan kembali setelah file tersedia dengan menghapus "// " di depan
    // baris id() di bawah. Tanpa ini aplikasi tetap jalan dengan Firebase OFF / mode lokal.
    // START: FlutterFire Configuration
    // id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_application_1"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // PATCH lokal CareerPath (2026-11-14): firebase-auth 23.x mensyaratkan minSdk >= 23,
        // sedangkan flutter.minSdkVersion (Flutter 3.32.8) = 21 → build gagal manifest merger.
        minSdk = maxOf(flutter.minSdkVersion, 23)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

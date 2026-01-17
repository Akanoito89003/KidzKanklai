plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_application_1"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
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

flutter {
    source = "../.."
}

dependencies {
    // 1. เชื่อมต่อกับไฟล์ Godot .aar (ซึ่งอาจจะเป็นแค่ Game Logic/Plugins)
    implementation(files("libs/my-game.aar")) 

    // 2. *** เพิ่ม Godot Engine Library ***
    // จำเป็นต้องมีตัวนี้เพราะ AAR ของคุณขนาดเล็ก (290KB) น่าจะไม่มีตัว Engine ติดมาด้วย
    // (ถ้าใช้ Godot Version อื่น แก้เลขเวอร์ชันตรงนี้ให้ตรงกันนะครับ เช่น 4.2.1.stable)
    implementation("org.godotengine:godot:4.3.0.stable")

    // 3. เพื่อแก้ Error Splash Screen
    implementation("androidx.core:core-splashscreen:1.0.1")
}

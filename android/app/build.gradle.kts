plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.5.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries

  // ✅ Google 로그인 필수
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.android.gms:play-services-auth")
    
    // ✅ Google Maps SDK 추가 (MapsInitializer를 사용하기 위해 필요)
    implementation("com.google.android.gms:play-services-maps:19.0.0")
    
    // ✅ Core library desugaring (flutter_local_notifications 필요)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

android {
    namespace = "com.tagodriver.ploride"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // ✅ Core library desugaring 활성화
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.tagodriver.ploride"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ✅ TRANSLATE_API_KEY를 GOOGLE_MAPS_API_KEY로 사용
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = project.findProperty("TRANSLATE_API_KEY") as String? ?: ""
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

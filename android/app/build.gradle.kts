// ===== imports (항상 파일 최상단) =====
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ===== key.properties 로더 (두 경로 모두 시도) =====
val keystoreProps = Properties().apply {
    // app 모듈 기준 ../key.properties == android/key.properties
    val p1 = file("../key.properties")
    val p2 = rootProject.file("key.properties")
    val f = when {
        p1.exists() -> p1
        p2.exists() -> p2
        else -> null
    } ?: throw GradleException(
        "Missing key.properties. Checked: ${p1.absolutePath} and ${p2.absolutePath}"
    )
    load(FileInputStream(f))
}

android {
    namespace = "com.tagodriver.ploride"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    defaultConfig {
        applicationId = "com.tagodriver.ploride" // 출시 전 고유 패키지로 교체 권장
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // KTS-safe 방식
        manifestPlaceholders += mapOf(
            "GOOGLE_MAPS_API_KEY" to (project.findProperty("TRANSLATE_API_KEY") as String? ?: "")
        )
    }

    // 🔐 release 서명키 연결
    signingConfigs {
        create("release") {
            val storeFilePath = keystoreProps.getProperty("storeFile")
                ?: throw GradleException("key.properties missing 'storeFile'")
            val storePwd = keystoreProps.getProperty("storePassword")
                ?: throw GradleException("key.properties missing 'storePassword'")
            val alias = keystoreProps.getProperty("keyAlias")
                ?: throw GradleException("key.properties missing 'keyAlias'")
            val keyPwd = keystoreProps.getProperty("keyPassword")
                ?: throw GradleException("key.properties missing 'keyPassword'")

            val f = file(storeFilePath) // 보통 ../upload-keystore.jks
            if (!f.exists()) throw GradleException("Keystore not found at: ${f.absolutePath}")

            storeFile = f
            storePassword = storePwd
            keyAlias = alias
            keyPassword = keyPwd
        }
    }

    buildTypes {
        getByName("release") {
            // ✅ 실제 release 서명 사용
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // Firebase
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.android.gms:play-services-auth")

    // Google Maps
    implementation("com.google.android.gms:play-services-maps:19.0.0")

    // Core library desugaring (e.g., for flutter_local_notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

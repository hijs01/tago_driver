package com.example.tago_driver

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.maps.MapsInitializer
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.tago/maps_api_key"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setApiKey") {
                val apiKey = call.arguments as? String
                if (apiKey != null && apiKey.isNotEmpty()) {
                    try {
                        // ✅ ApplicationInfo의 metaData에 API 키 설정
                        val appInfo: ApplicationInfo = applicationContext.packageManager
                            .getApplicationInfo(applicationContext.packageName, PackageManager.GET_META_DATA)
                        appInfo.metaData.putString("com.google.android.geo.API_KEY", apiKey)
                        
                        // ✅ MapsInitializer 초기화 (AndroidManifest.xml의 meta-data에서 읽음)
                        MapsInitializer.initialize(applicationContext)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("MAPS_INIT_ERROR", "Failed to initialize Maps: ${e.message}", null)
                    }
                } else {
                    result.error("INVALID_KEY", "API key is empty", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

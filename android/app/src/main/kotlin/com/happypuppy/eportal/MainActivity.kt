package com.happypuppy.eportal

import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "android_native_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "requestIgnoreBatteryOptimization") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                    try {
                        startActivity(intent)
                        result.success(null) // Sukses membuka pengaturan
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Failed to open battery optimization settings", e.message)
                    }
                } else {
                    result.error("UNAVAILABLE", "Battery optimization settings are not available on this version", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

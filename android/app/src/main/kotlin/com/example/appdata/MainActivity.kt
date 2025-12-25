package com.example.appdata

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // ชื่อช่องทางสื่อสาร (ต้องตรงกับฝั่ง Flutter เป๊ะๆ)
    private val CHANNEL = "com.kisugar.app/launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // สร้างตัวดักฟังคำสั่งจาก Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openUrl") {
                // ถ้าคำสั่งชื่อ openUrl ให้ทำตามนี้
                val url = call.argument<String>("url")
                if (url != null) {
                    try {
                        // สั่ง Android ให้เปิด Browser
                        val intent = Intent(Intent.ACTION_VIEW)
                        intent.data = Uri.parse(url)
                        startActivity(intent)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("ERROR", "Cannot open URL", null)
                    }
                } else {
                    result.error("INVALID_URL", "URL is null", null)
                }
            } else {
                // ถ้าเป็นคำสั่งอื่นที่ไม่ได้เตรียมไว้
                result.notImplemented()
            }
        }
    }
}
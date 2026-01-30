package com.pratikbilisim.kiosk

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.pratikbilisim.kiosk.admin.MyDeviceAdminReceiver

class MainActivity : FlutterActivity() {

    private val PRINTER_CHANNEL = "printer_channel"
    private val KIOSK_CHANNEL = "kiosk_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ Mevcut yazıcı kanalın aynen duruyor
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PRINTER_CHANNEL)
            .setMethodCallHandler(PrinterHandler(this))

        // ✅ Yeni kiosk kanalı
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, KIOSK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isDeviceOwner" -> result.success(isDeviceOwner())
                    "startKiosk" -> result.success(startKioskMode())
                    "stopKiosk" -> result.success(stopKioskMode())
                    else -> result.notImplemented()
                }
            }
    }

    private fun isDeviceOwner(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        return dpm.isDeviceOwnerApp(packageName)
    }

    private fun startKioskMode(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = ComponentName(this, MyDeviceAdminReceiver::class.java)

        // Device Owner değilse tam kiosk başlatamayız
        if (!dpm.isDeviceOwnerApp(packageName)) return false

        // Allowlist
        dpm.setLockTaskPackages(admin, arrayOf(packageName))

        startLockTask()
        return true
    }

    private fun stopKioskMode(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = ComponentName(this, MyDeviceAdminReceiver::class.java)

        if (!dpm.isDeviceOwnerApp(packageName)) return false

        stopLockTask()
        dpm.setLockTaskPackages(admin, emptyArray())
        return true
    }
}

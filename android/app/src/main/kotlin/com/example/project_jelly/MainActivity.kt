package com.example.project_jelly

import android.app.ActivityManager
import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.Process
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.project_jelly/resourceUsage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getResourceUsage" -> {
                    val batteryUsage = getBatteryUsage()
                    val memoryUsage = getMemoryUsage()
                    val cpuUsage = getCpuUsage()
                    val usageStats = mapOf(
                            "batteryUsage" to batteryUsage,
                            "memoryUsage" to memoryUsage,
                            "cpuUsage" to cpuUsage
                    )
                    result.success(usageStats)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBatteryUsage(): String {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        // Note: This API requires Android 6.0 (API level 23) or higher.
        val batteryUsage = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val batteryPercent: Int = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            "Battery level: $batteryPercent%"
        } else {
            "Battery level not available on pre-Marshmallow devices."
        }
        return batteryUsage
    }

    private fun getMemoryUsage(): String {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        val totalMemory = memoryInfo.totalMem / (1024 * 1024)
        val availMemory = memoryInfo.availMem / (1024 * 1024)
        return "Total Memory: ${totalMemory}MB, Available Memory: ${availMemory}MB"
    }

    private fun getCpuUsage(): String {
        try {
            val pid = Process.myPid()
            val cpuStatPath = "/proc/$pid/stat"
            val reader = RandomAccessFile(cpuStatPath, "r")
            val load = reader.readLine().split(" ")

            val utime = load[13].toLong()
            val stime = load[14].toLong()
            val cutime = load[15].toLong()
            val cstime = load[16].toLong()
            val startTime = load[21].toLong()
            val uptime = System.currentTimeMillis() / 10

            val totalProcessTime = utime + stime + cutime + cstime
            val totalTime = uptime - startTime

            reader.close()

            // The CPU usage calculation will be a rough estimation,
            // as we are considering total time passed since the process start,
            // which includes sleep time as well. Real CPU monitoring requires polling at intervals.
            val cpuUsage = totalProcessTime / (totalTime.toFloat() * numberOfCores())

            return "Approximate CPU usage: ${(cpuUsage * 100).toInt()}%"
        } catch (e: Exception) {
            return "Failed to read CPU usage: ${e.message}"
        }
    }

    private fun numberOfCores(): Int {
        return File("/sys/devices/system/cpu/").listFiles { pathname ->
            Pattern.matches("cpu[0-9]+", pathname.name)
        }?.size ?: 1
    }
}
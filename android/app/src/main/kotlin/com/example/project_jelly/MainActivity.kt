package com.example.project_jelly

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.RandomAccessFile

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.project_jelly/resourceUsage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getResourceUsage") {
                val memoryUsage = getMemoryUsage()
                val cpuUsage = getCpuUsage()
                val usageStats = HashMap<String, String>()
                usageStats["memoryUsage"] = memoryUsage
                usageStats["cpuUsage"] = cpuUsage
                result.success(usageStats)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getMemoryUsage(): String {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        val totalMemory = memoryInfo.totalMem / (1024 * 1024)
        val freeMemory = memoryInfo.availMem / (1024 * 1024)
        val usedMemory = totalMemory - freeMemory
        return "Used/Total memory: $usedMemory / $totalMemory MB"
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun getCpuUsage(): String {
        try {
            RandomAccessFile("/proc/stat", "r").use { reader ->
                val load = reader.readLine().split(" ")
                val user = load[2].toLong()
                val nice = load[3].toLong()
                val system = load[4].toLong()
                val idle = load[5].toLong()
                val iowait = load[6].toLong()
                val irq = load[7].toLong()
                val softirq = load[8].toLong()
                val steal = load[9].toLong()
                val total = user + nice + system + idle + iowait + irq + softirq + steal

                reader.seek(0)
                Thread.sleep(100)
                reader.readLine().split(" ").let {
                    val user2 = it[2].toLong()
                    val nice2 = it[3].toLong()
                    val system2 = it[4].toLong()
                    val idle2 = it[5].toLong()
                    val iowait2 = it[6].toLong()
                    val irq2 = it[7].toLong()
                    val softirq2 = it[8].toLong()
                    val steal2 = it[9].toLong()
                    val total2 = user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2

                    val totalDiff = total2 - total
                    val idleDiff = idle2 - idle

                    val cpuUsage = (totalDiff - idleDiff) * 100 / totalDiff
                    return "CPU usage: $cpuUsage%"
                }
            }
        } catch (ex: IOException) {
            ex.printStackTrace()
        } catch (ex: InterruptedException) {
            ex.printStackTrace()
        }
        return "Failed to read CPU usage."
    }
}
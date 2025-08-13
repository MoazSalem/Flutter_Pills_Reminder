package com.moazsalem.pills_reminder

import android.util.Log
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel

class RescheduleBootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if (Intent.ACTION_BOOT_COMPLETED == intent?.action) {
            Log.i("RescheduleBootReceiver", "Boot completed — starting notification reschedule")

            // Initialize Flutter engine loader
            val loader = FlutterLoader()
            loader.startInitialization(context!!)
            loader.ensureInitializationComplete(context, null)

            // Create a new FlutterEngine
            val engine = FlutterEngine(context)

            // Execute your background Dart entrypoint
            engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(
                    loader.findAppBundlePath(),
                    "package:pills_reminder/features/notifications/entrypoints/reschedule_notifications_entrypoint.dart", // Dart package uri
                    "rescheduleAllNotifications" // Dart function name
                )
            )

            // Create MethodChannel for Dart -> Kotlin communication to kill this engine instance
            MethodChannel(
                engine.dartExecutor.binaryMessenger,
                "boot_reschedule_channel"
            ).setMethodCallHandler { call, _ ->
                if (call.method == "rescheduleComplete") {
                    Log.i(
                        "RescheduleBootReceiver",
                        "Dart finished rescheduling. Destroying engine."
                    )
                    engine.destroy()
                }
            }
        }
    }
}


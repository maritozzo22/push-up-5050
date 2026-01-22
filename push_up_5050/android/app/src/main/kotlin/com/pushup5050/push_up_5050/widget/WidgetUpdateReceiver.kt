package com.pushup5050.push_up_5050.widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import android.util.Log
import java.util.concurrent.TimeUnit

/**
 * BroadcastReceiver for handling widget update scheduling.
 *
 * Responds to:
 * - BOOT_COMPLETED: Re-schedules midnight update after device reboot
 * - Custom intent: Manual scheduling trigger from app
 *
 * Uses WorkManager for battery-efficient, persistent scheduling.
 */
class WidgetUpdateReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "Received broadcast: $action")

        if (action == Intent.ACTION_BOOT_COMPLETED ||
            action == ACTION_SCHEDULE_UPDATE) {
            Log.d(TAG, "Scheduling midnight widget update")
            scheduleMidnightUpdate(context)
        }
    }

    companion object {
        private const val TAG = "WidgetUpdateReceiver"
        const val ACTION_SCHEDULE_UPDATE = "com.pushup5050.WIDGET_UPDATE_SCHEDULE"

        /**
         * Schedule the midnight widget update using WorkManager.
         *
         * Calculates time until 00:01 and schedules a periodic task
         * that runs every 24 hours. The schedule persists across
         * app restarts and device reboots.
         *
         * @param context Application context
         */
        fun scheduleMidnightUpdate(context: Context) {
            try {
                // Calculate time until 00:01
                val now = System.currentTimeMillis()
                val calendar = java.util.Calendar.getInstance().apply {
                    set(java.util.Calendar.HOUR_OF_DAY, 0)
                    set(java.util.Calendar.MINUTE, 1)
                    set(java.util.Calendar.SECOND, 0)
                    set(java.util.Calendar.MILLISECOND, 0)
                    add(java.util.Calendar.DAY_OF_MONTH, 1) // Tomorrow
                }

                val delayMillis = calendar.timeInMillis - now
                val initialDelay = if (delayMillis > 0) delayMillis else TimeUnit.DAYS.toMillis(1)

                Log.d(TAG, "Scheduling midnight update in ${initialDelay / 1000 / 60} minutes")

                // Build constraints - minimal for battery efficiency
                val constraints = Constraints.Builder()
                    .setRequiresDeviceIdle(false)
                    .setRequiresCharging(false)
                    .build()

                // Create periodic work request (24-hour interval)
                val workRequest = PeriodicWorkRequestBuilder<MidnightWidgetUpdateWorker>(
                    24, TimeUnit.HOURS
                )
                    .setInitialDelay(initialDelay, TimeUnit.MILLISECONDS)
                    .setConstraints(constraints)
                    .build()

                // Enqueue unique work - keeps existing if already scheduled
                WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                    MidnightWidgetUpdateWorker.WORK_NAME,
                    ExistingPeriodicWorkPolicy.KEEP,
                    workRequest
                )

                Log.d(TAG, "Midnight update scheduled successfully")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to schedule midnight update", e)
            }
        }
    }
}

package com.pushup5050.push_up_5050.widget

import android.content.Context
import android.appwidget.AppWidgetManager
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import android.util.Log
import android.content.ComponentName

/**
 * WorkManager worker that updates widgets at midnight.
 *
 * Runs daily at 00:01 to refresh widget calendars. The widget providers
 * recalculate day statuses based on the current date, so "yesterday"
 * becomes "missed" if no workout was completed.
 */
class MidnightWidgetUpdateWorker(
    context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result {
        return try {
            Log.d(TAG, "Starting midnight widget update")

            val appWidgetManager = AppWidgetManager.getInstance(applicationContext)

            // Update QuickStart widget (4x4)
            val quickStartProvider = ComponentName(
                applicationContext,
                PushupWidgetQuickStartProvider::class.java
            )
            val quickStartIds = appWidgetManager.getAppWidgetIds(quickStartProvider)
            if (quickStartIds.isNotEmpty()) {
                PushupWidgetQuickStartProvider().onUpdate(
                    applicationContext,
                    appWidgetManager,
                    quickStartIds
                )
                Log.d(TAG, "Updated QuickStart widget (${quickStartIds.size} instances)")
            }

            // Update Small widget (2x1)
            val smallProvider = ComponentName(
                applicationContext,
                PushupWidgetSmallProvider::class.java
            )
            val smallIds = appWidgetManager.getAppWidgetIds(smallProvider)
            if (smallIds.isNotEmpty()) {
                PushupWidgetSmallProvider().onUpdate(
                    applicationContext,
                    appWidgetManager,
                    smallIds
                )
                Log.d(TAG, "Updated Small widget (${smallIds.size} instances)")
            }

            Log.d(TAG, "Midnight widget update completed successfully")
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "Failed to update widgets at midnight", e)
            // Retry on failure
            Result.retry()
        }
    }

    companion object {
        private const val TAG = "MidnightWidgetUpdate"
        const val WORK_NAME = "midnight_widget_update"
    }
}

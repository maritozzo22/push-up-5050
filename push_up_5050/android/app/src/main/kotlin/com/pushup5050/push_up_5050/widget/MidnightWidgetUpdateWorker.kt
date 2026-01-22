package com.pushup5050.push_up_5050.widget

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import es.antonborri.home_widget.HomeWidget
import android.util.Log

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

            // Trigger widget refresh - calendar will re-render
            // with updated day statuses (yesterday may now be missed)
            HomeWidget.updateWidget(
                applicationContext,
                "PushupWidgetQuickStartProvider"
            )
            Log.d(TAG, "Updated QuickStart widget")

            HomeWidget.updateWidget(
                applicationContext,
                "PushupWidgetSmallProvider"
            )
            Log.d(TAG, "Updated Small widget")

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

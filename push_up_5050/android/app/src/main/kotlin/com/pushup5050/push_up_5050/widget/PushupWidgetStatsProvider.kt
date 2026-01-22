package com.pushup5050.push_up_5050.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import com.pushup5050.push_up_5050.MainActivity
import com.pushup5050.push_up_5050.R
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject

/**
 * Widget 1: Quick Stats
 * Shows today's push-ups and total progress with START button
 *
 * Data source: home_widget storage (shared with Flutter)
 */
class PushupWidgetStatsProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Called when first widget is added
    }

    override fun onDisabled(context: Context) {
        // Called when last widget is removed
    }

    companion object {
        private const val TAG = "PushupWidgetStats"
        private const val DATA_KEY = "pushup_json_data"

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.e(TAG, "updateAppWidget STATS called for widgetId: $appWidgetId")
            val views = RemoteViews(context.packageName, R.layout.pushup_widget_stats)

            // Get SharedPreferences from home_widget plugin
            val widgetData = HomeWidgetPlugin.getData(context)
            Log.e(TAG, "Got SharedPreferences from HomeWidgetPlugin")

            val jsonData = widgetData.getString(DATA_KEY, null)
            Log.e(TAG, "JSON data: $jsonData")

            // Parse JSON data - use var to allow reassignment
            var todayPushups = 0
            var totalPushups = 0
            var goalPushups = 5050

            if (!jsonData.isNullOrBlank()) {
                try {
                    val json = JSONObject(jsonData)
                    // Use optInt() to avoid exceptions
                    todayPushups = json.optInt("todayPushups", 0)
                    totalPushups = json.optInt("totalPushups", 0)
                    goalPushups = json.optInt("goalPushups", 5050)
                    Log.e(TAG, "Parsed: today=$todayPushups, total=$totalPushups")
                } catch (e: Exception) {
                    Log.e(TAG, "JSON parse error", e)
                    // Fallback to defaults if JSON parsing fails
                    todayPushups = 0
                    totalPushups = 0
                    goalPushups = 5050
                }
            } else {
                Log.w(TAG, "No JSON data found")
            }

            // Update views
            views.setTextViewText(R.id.today_count, todayPushups.toString())
            views.setTextViewText(R.id.total_count, "$totalPushups / $goalPushups")

            // Set click intent for START button to deep link
            val deepLinkIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("pushup5050://series_selection")
                // Start as new task but don't create multiple instances
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }

            views.setOnClickPendingIntent(R.id.start_button,
                android.app.PendingIntent.getActivity(
                    context,
                    0,
                    deepLinkIntent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                )
            )

            // Update widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

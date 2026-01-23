package com.pushup5050.push_up_5050.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import com.pushup5050.push_up_5050.MainActivity
import com.pushup5050.push_up_5050.R
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject

/**
 * Widget: Small Stats Vertical (1x2)
 * Shows today/total stats in compact vertical layout
 *
 * Data source: home_widget storage (shared with Flutter)
 *
 * Layout: pushup_widget_1x2.xml (vertical design)
 */
class PushupWidgetSmallProvider : AppWidgetProvider() {

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
        private const val TAG = "PushupWidgetSmall"

        private const val JSON_KEY = "pushup_json_data"
        private const val TODAY_KEY = "pushup_today_pushups"
        private const val TOTAL_KEY = "pushup_total_pushups"
        private const val GOAL_KEY = "pushup_goal_pushups"

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.e(TAG, "updateAppWidget SMALL called for widgetId: $appWidgetId")
            val views = RemoteViews(context.packageName, R.layout.pushup_widget_1x2)

            // Get SharedPreferences from home_widget plugin
            val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
            Log.e(TAG, "Got SharedPreferences from HomeWidgetPlugin")

            // Try to load data
            var todayPushups = 0
            var totalPushups = 0
            var goalPushups = 5050

            // First try: JSON data
            val jsonData = widgetData.getString(JSON_KEY, null)
            if (!jsonData.isNullOrBlank()) {
                try {
                    Log.e(TAG, "Found JSON data")
                    val json = JSONObject(jsonData)
                    todayPushups = json.optInt("todayPushups", 0)
                    totalPushups = json.optInt("totalPushups", 0)
                    goalPushups = json.optInt("goalPushups", 5050)
                    Log.e(TAG, "Parsed from JSON: today=$todayPushups, total=$totalPushups")
                } catch (e: Exception) {
                    Log.e(TAG, "JSON parse error", e)
                }
            } else {
                // Fallback: Individual keys
                Log.e(TAG, "No JSON data, trying individual keys")
                todayPushups = widgetData.getString(TODAY_KEY, "0")?.toIntOrNull() ?: 0
                totalPushups = widgetData.getString(TOTAL_KEY, "0")?.toIntOrNull() ?: 0
                goalPushups = widgetData.getString(GOAL_KEY, "5050")?.toIntOrNull() ?: 5050
                Log.e(TAG, "Parsed from individual keys: today=$todayPushups, total=$totalPushups")
            }

            // Update stats views
            views.setTextViewText(R.id.today_count, todayPushups.toString())
            views.setTextViewText(R.id.total_count_top, totalPushups.toString())

            // Set click intent to open app
            val deepLinkIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("pushup5050://series_selection")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }

            views.setOnClickPendingIntent(R.id.today_count,
                android.app.PendingIntent.getActivity(
                    context,
                    0,
                    deepLinkIntent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                )
            )

            // Update widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.e(TAG, "Widget update complete")
        }
    }
}

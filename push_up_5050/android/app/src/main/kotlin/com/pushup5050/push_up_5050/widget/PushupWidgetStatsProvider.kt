package com.pushup5050.push_up_5050.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import com.pushup5050.push_up_5050.MainActivity
import com.pushup5050.push_up_5050.R
import com.home_widget.HomeWidgetPlugin
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
        private const val DATA_KEY = "pushup_json_data"

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.pushup_widget_stats)

            // Load widget data from home_widget storage
            val jsonData = HomeWidgetPlugin.getData(context, DATA_KEY)

            // Parse JSON data
            val todayPushups: Int
            val totalPushups: Int
            val goalPushups: Int

            if (!jsonData.isNullOrEmpty()) {
                try {
                    val json = JSONObject(jsonData)
                    todayPushups = json.optInt("todayPushups", 0)
                    totalPushups = json.optInt("totalPushups", 0)
                    goalPushups = json.optInt("goalPushups", 5050)
                } catch (e: Exception) {
                    // Fallback to zeros if JSON parsing fails
                    todayPushups = 0
                    totalPushups = 0
                    goalPushups = 5050
                }
            } else {
                // No data available - use defaults
                todayPushups = 0
                totalPushups = 0
                goalPushups = 5050
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

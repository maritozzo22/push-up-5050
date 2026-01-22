package com.pushup5050.push_up_5050.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import com.pushup5050.push_up_5050.R

/**
 * Widget 2: Calendar Preview
 * Shows 30-day calendar with completion status
 */
class PushupWidgetCalendarProvider : AppWidgetProvider() {

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
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.pushup_widget_calendar)

            // Load widget data from shared preferences
            val prefs = context.getSharedPreferences("pushup_widget_data", Context.MODE_PRIVATE)

            val calendarJson = prefs.getString("calendar_days", "{}")

            // Parse calendar data and update grid
            // For now, show static placeholder
            // TODO: Implement calendar grid adapter

            // Set click intent to open app
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            intent?.let {
                views.setOnClickPendingIntent(R.id.calendar_grid,
                    android.app.PendingIntent.getActivity(
                        context,
                        0,
                        it,
                        android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                    )
                )
            }

            // Update widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

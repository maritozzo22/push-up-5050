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
import org.json.JSONArray
import org.json.JSONObject

/**
 * Widget: Small Stats with 3 Day Indicators (2x1)
 * Shows today/total stats + yesterday/today/tomorrow calendar
 *
 * Data source: home_widget storage (shared with Flutter)
 * Reads threeDayData from JSON for 3-day calendar display
 *
 * Day indicator colors:
 * - Orange glow: completed (checkmark)
 * - Red outline: missed (X)
 * - Gray: pending/future
 * - Orange border: in progress (today, not yet completed)
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
        private const val TODAY_GOAL_REACHED_KEY = "pushup_today_goal_reached"

        /**
         * Data class for 3-day calendar info from JSON
         */
        data class ThreeDayInfo(
            val day: Int,
            val dayLabel: String,    // I, O, D (Ieri, Oggi, Domani)
            val status: String,      // completed, missed, pending, today
            val pushups: Int
        )

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.e(TAG, "updateAppWidget SMALL called for widgetId: $appWidgetId")
            val views = RemoteViews(context.packageName, R.layout.pushup_widget_quick_start_small)

            // Get SharedPreferences from home_widget plugin
            val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
            Log.e(TAG, "Got SharedPreferences from HomeWidgetPlugin")

            // Try to load data
            var todayPushups = 0
            var totalPushups = 0
            var goalPushups = 5050
            var todayGoalReached = false
            var threeDayDataList: List<ThreeDayInfo> = emptyList()

            // First try: JSON data
            val jsonData = widgetData.getString(JSON_KEY, null)
            if (!jsonData.isNullOrBlank()) {
                try {
                    Log.e(TAG, "Found JSON data")
                    val json = JSONObject(jsonData)
                    todayPushups = json.optInt("todayPushups", 0)
                    totalPushups = json.optInt("totalPushups", 0)
                    goalPushups = json.optInt("goalPushups", 5050)
                    todayGoalReached = json.optBoolean("todayGoalReached", false)
                    Log.e(TAG, "Parsed from JSON: today=$todayPushups, total=$totalPushups, goalReached=$todayGoalReached")

                    // Parse threeDayData array
                    val threeDayDataArray = json.optJSONArray("threeDayData")
                    if (threeDayDataArray != null) {
                        threeDayDataList = parseThreeDayData(threeDayDataArray)
                        Log.e(TAG, "Parsed ${threeDayDataList.size} days from threeDayData")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "JSON parse error", e)
                }
            } else {
                // Fallback: Individual keys
                Log.e(TAG, "No JSON data, trying individual keys")
                todayPushups = widgetData.getString(TODAY_KEY, "0")?.toIntOrNull() ?: 0
                totalPushups = widgetData.getString(TOTAL_KEY, "0")?.toIntOrNull() ?: 0
                goalPushups = widgetData.getString(GOAL_KEY, "5050")?.toIntOrNull() ?: 5050
                todayGoalReached = widgetData.getString(TODAY_GOAL_REACHED_KEY, "false")?.toBoolean() ?: false
                Log.e(TAG, "Parsed from individual keys: today=$todayPushups, total=$totalPushups")
            }

            // Update stats views
            views.setTextViewText(R.id.today_count, todayPushups.toString())
            views.setTextViewText(R.id.total_count, "$totalPushups / $goalPushups")

            // Update 3-day calendar indicators
            updateThreeDayIndicators(views, threeDayDataList)

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

        /**
         * Parse threeDayData from JSON array
         * Expected format: 3 entries for [yesterday, today, tomorrow]
         */
        private fun parseThreeDayData(array: JSONArray): List<ThreeDayInfo> {
            val result = mutableListOf<ThreeDayInfo>()
            for (i in 0 until array.length()) {
                try {
                    val dayObj = array.getJSONObject(i)
                    val day = dayObj.optInt("day", 0)
                    val dayLabel = dayObj.optString("dayLabel", "")
                    val status = dayObj.optString("status", "pending")
                    val pushups = dayObj.optInt("pushups", 0)

                    if (dayLabel.isNotEmpty()) {
                        result.add(ThreeDayInfo(day, dayLabel, status, pushups))
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error parsing three day at index $i", e)
                }
            }
            return result
        }

        /**
         * Update 3-day calendar indicators based on threeDayData
         * Maps to: day_yesterday, day_today, day_tomorrow
         */
        private fun updateThreeDayIndicators(views: RemoteViews, threeDayData: List<ThreeDayInfo>) {
            // If we have threeDayData from JSON (expected 3 entries)
            if (threeDayData.size >= 3) {
                // Yesterday (index 0)
                val yesterday = threeDayData[0]
                updateDayIndicator(
                    views,
                    R.id.day_yesterday_bg,
                    R.id.day_yesterday_text,
                    yesterday.status,
                    "Ieri"
                )

                // Today (index 1)
                val today = threeDayData[1]
                updateDayIndicator(
                    views,
                    R.id.day_today_bg,
                    R.id.day_today_text,
                    today.status,
                    "Oggi"
                )

                // Tomorrow (index 2) - always show as pending
                val tomorrow = threeDayData[2]
                updateDayIndicator(
                    views,
                    R.id.day_tomorrow_bg,
                    R.id.day_tomorrow_text,
                    "pending",
                    "Domani"
                )
            } else {
                // Fallback: Show pending for all days
                updateDayIndicator(views, R.id.day_yesterday_bg, R.id.day_yesterday_text, "pending", "")
                updateDayIndicator(views, R.id.day_today_bg, R.id.day_today_text, "pending", "")
                updateDayIndicator(views, R.id.day_tomorrow_bg, R.id.day_tomorrow_text, "pending", "")
            }
        }

        /**
         * Update a single day indicator with status-based styling
         */
        private fun updateDayIndicator(
            views: RemoteViews,
            bgViewId: Int,
            textViewId: Int,
            status: String,
            label: String
        ) {
            when (status) {
                "completed" -> {
                    // Orange glow with checkmark
                    views.setInt(bgViewId, "setImageResource", R.drawable.day_indicator_glow)
                    views.setTextViewText(textViewId, "✓")
                    views.setTextColor(textViewId, 0xFFFFFFFF.toInt())
                }
                "missed" -> {
                    // Red outline with X
                    views.setInt(bgViewId, "setImageResource", R.drawable.day_indicator_missed_new)
                    views.setTextViewText(textViewId, "✗")
                    views.setTextColor(textViewId, 0xFFF44336.toInt())
                }
                "today" -> {
                    // Orange border (in progress)
                    views.setInt(bgViewId, "setImageResource", R.drawable.day_indicator_in_progress)
                    views.setTextViewText(textViewId, "")
                }
                else -> {
                    // Pending/future - gray
                    views.setInt(bgViewId, "setImageResource", R.drawable.day_indicator_pending)
                    views.setTextViewText(textViewId, "")
                }
            }
        }
    }
}

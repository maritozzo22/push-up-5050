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
import java.util.Locale

/**
 * Widget: Quick Start (4x4)
 * Shows circular START button with stats and 7-day calendar row
 *
 * Data source: home_widget storage (shared with Flutter)
 * Reads weekDayData from JSON for calendar display
 *
 * Layout: pushup_widget_4x4.xml (matching template design)
 */
class PushupWidgetQuickStartProvider : AppWidgetProvider() {

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
        private const val TAG = "PushupWidgetQuickStart"

        private const val JSON_KEY = "pushup_json_data"
        private const val TODAY_KEY = "pushup_today_pushups"
        private const val TOTAL_KEY = "pushup_total_pushups"
        private const val GOAL_KEY = "pushup_goal_pushups"
        private const val STREAK_KEY = "pushup_streak_days"

        // Italian day labels for calendar row (Monday-Sunday)
        private val DAY_LABELS_IT = listOf("L", "M", "M", "G", "V", "S", "D")

        // English day labels for calendar row (Monday-Sunday)
        private val DAY_LABELS_EN = listOf("M", "T", "W", "T", "F", "S", "S")

        /**
         * Get localized day labels based on device locale
         * @param context Application context
         * @return List of 7 single-character day labels (Monday-Sunday)
         */
        fun getDayLabels(context: Context): List<String> {
            val locale: Locale = context.resources.configuration.locales.get(0)
            return if (locale.language == "it") {
                DAY_LABELS_IT
            } else {
                DAY_LABELS_EN
            }
        }

        /**
         * Data class for calendar day info from JSON
         */
        data class WeekDayInfo(
            val day: Int,
            val dayLabel: String,
            val status: String,    // completed, missed, pending, today
            val pushups: Int,
            val isPartOfStreak: Boolean
        )

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.e(TAG, "updateAppWidget called for widgetId: $appWidgetId")
            val views = RemoteViews(context.packageName, R.layout.pushup_widget_4x4)

            // Get SharedPreferences from home_widget plugin
            val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
            Log.e(TAG, "Got SharedPreferences from HomeWidgetPlugin")

            // Try to load data
            var todayPushups = 0
            var totalPushups = 0
            var goalPushups = 5050
            var streakDays = 0
            var weekDayDataList: List<WeekDayInfo> = emptyList()
            var hasStreakLine = false

            // First try: JSON data
            val jsonData = widgetData.getString(JSON_KEY, null)
            if (!jsonData.isNullOrBlank()) {
                try {
                    Log.e(TAG, "Found JSON data")
                    val json = JSONObject(jsonData)
                    todayPushups = json.optInt("todayPushups", 0)
                    totalPushups = json.optInt("totalPushups", 0)
                    goalPushups = json.optInt("goalPushups", 5050)
                    streakDays = json.optInt("streakDays", 0)
                    hasStreakLine = json.optBoolean("hasStreakLine", false)

                    // Parse weekDayData array
                    val weekDayDataArray = json.optJSONArray("weekDayData")
                    if (weekDayDataArray != null) {
                        weekDayDataList = parseWeekDayData(weekDayDataArray)
                        Log.e(TAG, "Parsed ${weekDayDataList.size} week days from JSON")
                    }

                    Log.e(TAG, "Parsed from JSON: today=$todayPushups, total=$totalPushups, streak=$streakDays")
                } catch (e: Exception) {
                    Log.e(TAG, "JSON parse error", e)
                }
            } else {
                // Fallback: Individual keys
                Log.e(TAG, "No JSON data, trying individual keys")
                todayPushups = widgetData.getString(TODAY_KEY, "0")?.toIntOrNull() ?: 0
                totalPushups = widgetData.getString(TOTAL_KEY, "0")?.toIntOrNull() ?: 0
                goalPushups = widgetData.getString(GOAL_KEY, "5050")?.toIntOrNull() ?: 5050
                streakDays = widgetData.getString(STREAK_KEY, "0")?.toIntOrNull() ?: 0
                Log.e(TAG, "Parsed from individual keys: today=$todayPushups, total=$totalPushups, streak=$streakDays")
            }

            // Update stats views
            views.setTextViewText(R.id.today_count, todayPushups.toString())
            views.setTextViewText(R.id.total_count, "$totalPushups / $goalPushups")

            // Update calendar day buttons based on weekDayData
            updateCalendarDays(context, views, weekDayDataList)

            // Set click intent for START button container to deep link
            val deepLinkIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("pushup5050://series_selection")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }

            views.setOnClickPendingIntent(R.id.start_button_container,
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
         * Parse weekDayData from JSON array
         */
        private fun parseWeekDayData(array: JSONArray): List<WeekDayInfo> {
            val result = mutableListOf<WeekDayInfo>()
            for (i in 0 until array.length()) {
                try {
                    val dayObj = array.getJSONObject(i)
                    val day = dayObj.optInt("day", 0)
                    val dayLabel = dayObj.optString("dayLabel", "")
                    val status = dayObj.optString("status", "pending")
                    val pushups = dayObj.optInt("pushups", 0)
                    val isPartOfStreak = dayObj.optBoolean("isPartOfStreak", false)

                    if (dayLabel.isNotEmpty()) {
                        result.add(WeekDayInfo(day, dayLabel, status, pushups, isPartOfStreak))
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error parsing week day at index $i", e)
                }
            }
            return result
        }

        /**
         * Update calendar day buttons with status-based backgrounds
         * Uses new unified widget_day_chip_* drawables for visual consistency
         * Day labels are localized based on device locale
         */
        private fun updateCalendarDays(context: Context, views: RemoteViews, weekDayData: List<WeekDayInfo>) {
            val dayButtonIds = intArrayOf(
                R.id.day_1, R.id.day_2, R.id.day_3, R.id.day_4,
                R.id.day_5, R.id.day_6, R.id.day_7
            )

            // Get localized day labels (Italian: L M M G V S D, English: M T W T F S S)
            val dayLabels = getDayLabels(context)

            // If we have weekDayData from JSON, use it
            if (weekDayData.size == 7) {
                for (i in dayButtonIds.indices) {
                    val dayInfo = weekDayData[i]

                    // Use new widget_day_chip_* drawables from Plan 01
                    val backgroundRes = when (dayInfo.status) {
                        "completed" -> R.drawable.widget_day_chip_completed
                        "missed" -> R.drawable.widget_day_chip_missed
                        "today" -> R.drawable.widget_day_chip_pending  // Today uses pending base with orange border
                        else -> R.drawable.widget_day_chip_pending
                    }

                    views.setInt(dayButtonIds[i], "setBackgroundResource", backgroundRes)

                    // Set localized day label text
                    views.setTextViewText(dayButtonIds[i], dayLabels.getOrElse(i) { dayLabels[0] })

                    // Set text color based on status
                    val textColor = when (dayInfo.status) {
                        "completed" -> 0xFFFFFFFF.toInt()  // White on completed
                        "missed" -> 0xFFFFFFFF.toInt()     // White on missed (X is red in drawable)
                        "today" -> 0xFFFFFFFF.toInt()      // White for today
                        else -> 0xFFB9C0C7.toInt()         // Soft gray for pending (widget_day_pending_text color)
                    }
                    views.setTextColor(dayButtonIds[i], textColor)
                }
            } else {
                // Fallback: Use default gray background with localized labels
                for (i in dayButtonIds.indices) {
                    views.setInt(dayButtonIds[i], "setBackgroundResource", R.drawable.widget_day_chip_pending)
                    views.setTextViewText(dayButtonIds[i], dayLabels.getOrElse(i) { dayLabels[0] })
                    views.setTextColor(dayButtonIds[i], 0xFFB9C0C7.toInt())
                }
            }
        }
    }
}

package com.rowhomelabs.rssreader.models

import com.rowhomelabs.rssreader.R
import com.rowhomelabs.rssreader.baseUrl
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import dev.hotwire.navigation.tabs.HotwireBottomTab

private val feeds = HotwireBottomTab(
    title = "Feeds",
    iconResId = R.drawable.inbox_24px,
    configuration = NavigatorConfiguration(
        name = "feeds",
        navigatorHostId = R.id.feeds_nav_host,
        startLocation = "$baseUrl/feeds"
    )
)

private val entries = HotwireBottomTab(
    title = "Entries",
    iconResId = R.drawable.list_24px,
    configuration = NavigatorConfiguration(
        name = "entries",
        navigatorHostId = R.id.entries_nav_host,
        startLocation = "$baseUrl/entries"
    )
)

private val settings = HotwireBottomTab(
    title = "Settings",
    iconResId = R.drawable.settings_24px,
    configuration = NavigatorConfiguration(
        name = "settings",
        navigatorHostId = R.id.settings_nav_host,
        startLocation = "$baseUrl/user/edit"
    )
)

val mainTabs = listOf(
    feeds,
    entries,
    settings,
)

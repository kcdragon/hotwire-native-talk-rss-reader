package com.rowhomelabs.rssreader

import android.app.Application
import com.masilotti.bridgecomponents.shared.Bridgework
import com.rowhomelabs.rssreader.components.SignInWithOauthComponent
import com.rowhomelabs.rssreader.fragments.RefreshAppFragment
import com.rowhomelabs.rssreader.fragments.WebFragment
import dev.hotwire.core.bridge.BridgeComponentFactory
import dev.hotwire.core.bridge.KotlinXJsonConverter
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.turbo.config.PathConfiguration
import dev.hotwire.navigation.config.registerBridgeComponents
import dev.hotwire.navigation.config.registerFragmentDestinations

class RssReaderApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        Hotwire.config.jsonConverter = KotlinXJsonConverter()

        Hotwire.loadPathConfiguration(
            context = this,
            location = PathConfiguration.Location(
                remoteFileUrl = "$baseUrl/hotwire_native/configuration/android_v1.json"
            )
        )

        Hotwire.registerFragmentDestinations(
            RefreshAppFragment::class,
            WebFragment::class,
        )

        Hotwire.registerBridgeComponents(
            BridgeComponentFactory("sign-in-with-oauth", ::SignInWithOauthComponent),
            *Bridgework.coreComponents
        )
    }
}

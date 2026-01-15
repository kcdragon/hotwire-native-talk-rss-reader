package com.rowhomelabs.rssreader.components

import android.net.Uri
import android.util.Log
import androidx.browser.customtabs.CustomTabsIntent
import androidx.lifecycle.Observer
import com.rowhomelabs.rssreader.MainActivity
import com.rowhomelabs.rssreader.baseUrl
import com.rowhomelabs.rssreader.fragments.WebFragment
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import androidx.core.net.toUri

class SignInWithOauthComponent(
    name: String,
    private val delegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, delegate) {

    private var tokenAuthPath: String? = null
    private var authObserver: Observer<String?>? = null

    private val fragment: WebFragment?
        get() = delegate.destination.fragment as? WebFragment

    override fun onReceive(message: Message) {
        when (message.event) {
            "click" -> handleClick(message)
        }
    }

    private fun handleClick(message: Message) {
        val data = message.data<MessageData>() ?: run {
            Log.e(TAG, "Missing message data")
            return
        }

        val startUrl = "$baseUrl${data.startPath}".toUri()
        tokenAuthPath = data.tokenAuthPath

        launchChromeCustomTab(startUrl)
        observeAuthCompletion()
    }

    private fun launchChromeCustomTab(url: Uri) {
        val context = fragment?.requireContext() ?: run {
            Log.e(TAG, "No context available")
            return
        }

        val customTabsIntent = CustomTabsIntent.Builder()
            .setShowTitle(true)
            .build()

        customTabsIntent.launchUrl(context, url)
        Log.d(TAG, "Launched Chrome Custom Tab for OAuth: $url")
    }

    private fun observeAuthCompletion() {
        val fragment = this.fragment ?: run {
            Log.e(TAG, "No fragment available for lifecycle owner")
            return
        }

        authObserver = Observer { token ->
            Log.d(TAG, "Auth completion received with token: ${token != null}")
            authenticateWithToken(token)
        }

        MainActivity.authTokenLiveData.observe(fragment.viewLifecycleOwner, authObserver!!)
    }

    private fun authenticateWithToken(token: String?) {
        val navigator = fragment?.navigator ?: run {
            Log.e(TAG, "No fragment navigator available")
            fragment?.navigator?.clearAll()
            return
        }

        if (token != null && tokenAuthPath != null) {
            val tokenLoginUrl = "$baseUrl$tokenAuthPath".toUri()
                .buildUpon()
                .appendQueryParameter("token", token)
                .build()

            Log.d(TAG, "Navigating to token login: $tokenLoginUrl")
            navigator.route(tokenLoginUrl.toString())
        } else {
            Log.d(TAG, "No token received, reloading")
            navigator.clearAll()
        }

        // Clean up after authentication
        tokenAuthPath = null
        removeAuthObserver()
    }

    private fun removeAuthObserver() {
        authObserver?.let { observer ->
            MainActivity.authTokenLiveData.removeObserver(observer)
            authObserver = null
        }
    }

    @Serializable
    data class MessageData(
        @SerialName("startPath") val startPath: String,
        @SerialName("tokenAuthPath") val tokenAuthPath: String
    )

    companion object {
        private const val TAG = "SignInWithOauth"
    }
}

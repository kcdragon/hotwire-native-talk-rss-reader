package com.rowhomelabs.rssreader

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import androidx.activity.enableEdgeToEdge
import androidx.lifecycle.MutableLiveData
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.rowhomelabs.rssreader.models.mainTabs
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.tabs.HotwireBottomNavigationController
import dev.hotwire.navigation.tabs.navigatorConfigurations
import dev.hotwire.navigation.util.applyDefaultImeWindowInsets

const val baseUrl = BuildConfig.BASE_URL

class MainActivity : HotwireActivity() {
    private lateinit var bottomNavigationController: HotwireBottomNavigationController

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContentView(R.layout.activity_main)
        findViewById<View>(R.id.main).applyDefaultImeWindowInsets()

        initializeBottomTabs()
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (intent.action == Intent.ACTION_VIEW && intent.data != null) {
            handleDeepLink(intent.data!!)
        }
    }

    private fun handleDeepLink(uri: Uri) {
        when (uri.host) {
            "auth-callback" -> {
                val token = uri.getQueryParameter("token")
                authTokenLiveData.postValue(token)
            }
        }
    }

    override fun navigatorConfigurations() = mainTabs.navigatorConfigurations

    private fun initializeBottomTabs() {
        val bottomNavigationView = findViewById<BottomNavigationView>(R.id.bottom_nav)

        bottomNavigationController = HotwireBottomNavigationController(this, bottomNavigationView)
        bottomNavigationController.load(mainTabs, 0)
    }

    fun resetNavigators() {
        delegate.resetNavigators()
    }

    companion object {
        val authTokenLiveData = MutableLiveData<String?>()
    }
}

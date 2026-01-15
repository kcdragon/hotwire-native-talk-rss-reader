//
//  AppDelegate.swift
//  RSSReader
//
//  Created by Mike Dalton on 11/22/25.
//

import BridgeComponents
import HotwireNative
import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let localPathConfigURL = Bundle.main.url(forResource: "path-configuration", withExtension: "json")!
        let remotePathConfigURL = baseUrl.appending(path: "hotwire_native/configuration/ios_v1.json")
        Hotwire.loadPathConfiguration(from: [
            .file(localPathConfigURL),
            .server(remotePathConfigURL)
        ])
        
        // prevent click-hold from opening a preview window
        Hotwire.config.makeCustomWebView = { config in
            let webView  = WKWebView(frame: .zero, configuration: config)
            webView.allowsLinkPreview = false
            
            if #available(iOS 16.4, *) {
                #if DEBUG
                webView.isInspectable = true
                #else
                webView.isInspectable = false
                #endif
            }

            return webView
        }
        
        Hotwire.registerBridgeComponents([
            SignInWithOauthComponent.self,
        ] + Bridgework.coreComponents)
        
        #if DEBUG
        Hotwire.config.debugLoggingEnabled = true
        #endif
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

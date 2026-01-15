//
//  SceneController.swift
//  RSSReader
//
//  Created by Mike Dalton on 11/22/25.
//

import HotwireNative
import UIKit

let baseUrl = URL(string: "http://localhost:3000")!

class SceneController: UIResponder {
    var window: UIWindow?
    
    private lazy var tabBarController = HotwireTabBarController(navigatorDelegate: self)
}

extension SceneController: UIWindowSceneDelegate {
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        tabBarController.load(HotwireTab.all)

        // Handle URL if app was launched via custom URL scheme
        if let urlContext = connectionOptions.urlContexts.first {
            handleIncomingURL(urlContext.url)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleIncomingURL(url)
    }

    private func handleIncomingURL(_ url: URL) {
        print("Received custom URL: \(url)")

        // Extract the host from the custom URL (e.g., untitledrssreader://auth-callback -> "auth-callback")
        guard let host = url.host else { return }

        switch host {
        case "auth-callback":
            // Extract token from query parameters
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let token = components?.queryItems?.first(where: { $0.name == "token" })?.value

            // Post notification with token to dismiss Safari and authenticate
            NotificationCenter.default.post(
                name: .signInWithOauthCompleted,
                object: nil,
                userInfo: token != nil ? ["token": token!] : nil
            )
        default:
            // Build the destination URL by appending to the base URL
            let destinationURL = baseUrl.appendingPathComponent(host)
            tabBarController.activeNavigator.route(destinationURL)
        }
    }
}

extension SceneController: NavigatorDelegate {
    func handle(proposal: VisitProposal, from navigator: Navigator) -> ProposalResult {
        print("proposal.url: \(proposal.url)")
        print("proposal.viewController: \(proposal.viewController)")

        switch proposal.viewController {
        case RefreshAppViewController.pathConfigurationIdentifier:
            tabBarController.load(HotwireTab.all)
            return .accept
        default:
            return .accept
        }
    }
}

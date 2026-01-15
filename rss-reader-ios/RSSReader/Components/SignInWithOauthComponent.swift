//
//  SignInWithOauthComponent.swift
//  RSSReader
//
//  Created by Mike Dalton on 11/23/25.
//

import HotwireNative
import SafariServices
import UIKit
import WebKit

final class SignInWithOauthComponent: BridgeComponent {
    override nonisolated class var name: String { "sign-in-with-oauth" }

    private var viewController: UIViewController? {
        delegate?.destination as? UIViewController
    }

    private var safariViewController: SFSafariViewController?
    private var tokenAuthPath: String?

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }

        switch event {
        case .click:
            onClick(message: message)
        }
    }

    private func onClick(message: Message) {
        guard let data: MessageData = message.data() else {
            print("SignInWithOauth: Missing message data.")
            return
        }

        guard let startUrl = URL(string: "\(baseUrl)\(data.startPath)") else {
            print("SignInWithOauth: Invalid start URL")
            return
        }

        self.tokenAuthPath = data.tokenAuthPath

        launchSafariViewController(with: startUrl)
    }

    private func launchSafariViewController(with url: URL) {
        guard let viewController = viewController else {
            print("SignInWithOauth: No view controller available")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        self.safariViewController = safariVC

        // Listen for auth completion notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAuthCompletion),
            name: .signInWithOauthCompleted,
            object: nil
        )

        viewController.present(safariVC, animated: true)
    }

    @objc private func handleAuthCompletion(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .signInWithOauthCompleted, object: nil)

        let token = notification.userInfo?["token"] as? String

        safariViewController?.dismiss(animated: true) { [weak self] in
            self?.safariViewController = nil
            self?.authenticateWithToken(token)
        }
    }

    private func authenticateWithToken(_ token: String?) {
        guard let webViewController = delegate?.destination as? HotwireWebViewController,
              let webView = webViewController.visitableView.webView else {
            print("SignInWithOauth: No web view available")
            return
        }

        if let token = token, let tokenAuthPath = tokenAuthPath {
            // Navigate to token login endpoint to establish session in WKWebView
            guard let tokenLoginUrl = URL(string: "\(baseUrl)\(tokenAuthPath)") else {
                print("SignInWithOauth: Invalid token auth URL")
                return
            }

            var components = URLComponents(url: tokenLoginUrl, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "token", value: token)]

            if let url = components?.url {
                print("SignInWithOauth: Navigating to token login")
                webView.load(URLRequest(url: url))
            }
        } else {
            print("SignInWithOauth: No token received, just reloading")
            webView.reload()
        }
    }
}

private extension SignInWithOauthComponent {
    enum Event: String {
        case click
    }

    struct MessageData: Decodable {
        let startPath: String
        let tokenAuthPath: String
    }
}

extension Notification.Name {
    static let signInWithOauthCompleted = Notification.Name("signInWithOauthCompleted")
}

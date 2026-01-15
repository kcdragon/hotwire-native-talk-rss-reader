//
//  Tabs.swift
//  RSSReader
//
//  Created by Mike Dalton on 11/29/25.
//

import Foundation
import HotwireNative
import UIKit

extension HotwireTab {
    static let all: [HotwireTab] = {
        var tabs: [HotwireTab] = [
            .feeds,
            .entries,
            .settings
        ]

        return tabs
    }()

    static let feeds = HotwireTab(
        title: "Feeds",
        image: .init(systemName: "tray")!,
        url: baseUrl.appending(path: "/feeds")
    )

    static let entries = HotwireTab(
        title: "Entries",
        image: .init(systemName: "list.bullet")!,
        url: baseUrl.appending(path: "/entries")
    )

    static let settings = HotwireTab(
        title: "Settings",
        image: .init(systemName: "gear")!,
        url: baseUrl.appending(path: "/user/edit")
    )
}

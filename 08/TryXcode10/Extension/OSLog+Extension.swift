//
//  OSLog+Extension.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/08/24.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import Foundation
import os.signpost

private let bundleID = Bundle.main.bundleIdentifier ?? ""

extension OSLog {

    /// for measuring image download process.
    static let downloadImage = OSLog(subsystem: bundleID, category: "downloadLog")
    static let removeConstraints = OSLog(subsystem: bundleID, category: "removeConstraints")
    static let toggleConstraints = OSLog(subsystem: bundleID, category: "toggleConstraints")
}

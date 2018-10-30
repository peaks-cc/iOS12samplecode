//
//  OSLog+Extension.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/08/24.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import Foundation
import os.signpost

let bundleID = Bundle.main.bundleIdentifier ?? ""
let downloadImageLog = OSLog(subsystem: bundleID, category: "downloadLog")
let removeConstraintsLog = OSLog(subsystem: bundleID, category: "removeConstraints")
let toggleConstraintsLog = OSLog(subsystem: bundleID, category: "toggleConstraints")

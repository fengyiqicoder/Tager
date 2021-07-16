//
//  AppGroup.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

let appGroupSuitName = "group.LabelMaker"

extension UserDefaults {
    
    static var appGroup: UserDefaults {
        return UserDefaults(suiteName: appGroupSuitName)!
    }
}

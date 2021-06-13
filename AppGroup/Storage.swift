//
//  AppGroup.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import Foundation

extension UserDefaults {
    
    static var appGroup: UserDefaults {
        return UserDefaults(suiteName: "group.LabelMaker")!
    }
    
    var test: String {
        set {
            UserDefaults.appGroup.setValue(newValue, forKey: "test")
        }
        get {
            UserDefaults.appGroup.string(forKey: "test") ?? ""
        }
    }
}

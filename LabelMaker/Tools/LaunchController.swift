//
//  LaunchController.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/10.
//

import AppKit

class LaunchController {
    static var shared = LaunchController()
    
    func checkFistTimeLaunch() -> Bool {
        if firstTimeLaunch {
            firstTimeLaunch = false
            return true
        } else {
            return false
        }
    }
    
    private var firstTimeLaunch: Bool {
        get {
            UserDefaults.standard.object(forKey: "firstTime") as? Bool ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "firstTime")
        }
    }
}

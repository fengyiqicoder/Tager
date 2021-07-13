//
//  AppDelegate.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        SandBoxController.shared.getAccess()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }


}


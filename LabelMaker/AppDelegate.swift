//
//  AppDelegate.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var copySupportEmailMenu: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        copySupportEmailMenu.title = "Copy Support Email".localize
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @IBAction func copyEmail(_ sender: NSMenuItem) {
        let pastboard = NSPasteboard.general
        pastboard.clearContents()
        let supportEmailString = "tagerapp@gmail.com"
        pastboard.setString(supportEmailString, forType: .string)
    }
    
}


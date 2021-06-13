//
//  FinderSync.swift
//  Menu
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    var myFolderURL = URL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        menu.addItem(withTitle: "Clean Icon", action: #selector(testAction1(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Add Test Icon", action: #selector(testAction2(_:)), keyEquivalent: "")
        return menu
    }
    
    @IBAction func testAction1(_ sender: AnyObject?) {
        
        FIFinderSyncController.default().selectedItemURLs()?.forEach({ url in
            NSWorkspace.shared.setIcon(nil, forFile: url.path)
        })
        
        UserDefaults.appGroup.test = "Clean up"
    }
    
    @IBAction func testAction2(_ sender: AnyObject?) {
        let testImage = NSImage(named: "TestImage")
        FIFinderSyncController.default().selectedItemURLs()?.forEach({ url in
            NSWorkspace.shared.setIcon(testImage, forFile: url.path)
        })
    }
    
}


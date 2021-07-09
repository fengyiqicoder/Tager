//
//  FinderSync.swift
//  Menu
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    private var myFolderURL = URL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu()
        if menuKind == .contextualMenuForItems {
            let menuItems = IconModelController.shared.iconModels.enumerated().map { (order, model) -> NSMenuItem in
                let menuItem = NSMenuItem(title: model.name, action: #selector(changeIcon(item:)), keyEquivalent: "")
                menuItem.toolTip = model.uuid
                menuItem.tag = order
                menuItem.image = model.image
                return menuItem
            }
            menuItems.forEach { item in
                menu.addItem(item)
            }
            menu.addItem(withTitle: "clear icon", action: #selector(clearIcon), keyEquivalent: "")
        }
        return menu
    }
    
    @objc
    func changeIcon(item: NSMenuItem) {
        let model = IconModelController.shared.iconModels[item.tag]
        FIFinderSyncController.default().selectedItemURLs()?.forEach({ url in
            NSWorkspace.shared.setIcon(model.image, forFile: url.path)
            NSWorkspace.shared.noteFileSystemChanged(url.path)
        })
    }
    
    @objc
    func clearIcon(_ sender: AnyObject?) {
        FIFinderSyncController.default().selectedItemURLs()?.forEach({ url in
            NSWorkspace.shared.setIcon(nil, forFile: url.path)
        })
    }
    
}


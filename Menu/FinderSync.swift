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
        if menuKind == .contextualMenuForItems {
            let menu = NSMenu()
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
            menu.addItem(withTitle: "Clear Tager Icon", action: #selector(clearIcon), keyEquivalent: "")
            
            //FIXME: 2.0 Feature
//            let fatherMenu = NSMenu()
//            let fatherItem = NSMenuItem(title: "Change to Tager Icon", action: nil, keyEquivalent: "")
//            fatherMenu.addItem(fatherItem)
//            fatherMenu.setSubmenu(menu, for: fatherItem)
//            return fatherMenu
            return menu
        }
        
        return NSMenu()
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


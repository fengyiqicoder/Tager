//
//  MainWindowController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

class MainWindowController: NSWindowController {
    
    var mainVC: MainController? {
        window?.contentViewController as? MainController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateTitle()
    }
    
    func updateTitle() {
        window?.title = "Tager's Icons".localize //图标库
        window?.subtitle = "\(IconModelController.shared.iconModels.count) " + "icons".localize
    }
    
    @IBOutlet weak var infoItem: NSToolbarItem!
    @IBOutlet weak var toolbar: NSToolbar!
    
    @IBAction func info(_ sender: NSToolbarItem) {
        let popover = NSPopover()
        popover.behavior = .semitransient
        popover.animates = true
        let button: NSButton = (sender.value(forKey: "button") as? NSButton)!
        
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(identifier: "InfoViewController") as InfoViewController
        popover.contentViewController = vc
        popover.show(relativeTo: button.bounds,
                     of: button,
                     preferredEdge: .maxY)
    }
    
    @IBAction func add(_ sender: NSToolbarItem) {
        mainVC?.addNewIcon()
    }
    
}

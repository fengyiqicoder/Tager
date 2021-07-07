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
        window?.title = "Tager's Icons" //图标库
        window?.subtitle = "\(IconModelController.shared.iconModels.count) icons"
    }
    
    @IBOutlet weak var infoItem: NSToolbarItem!
    @IBOutlet weak var toolbar: NSToolbar!
    
    @IBAction func info(_ sender: NSToolbarItem) {
        
    }
    
    @IBAction func add(_ sender: NSToolbarItem) {
        mainVC?.addNewIcon()
    }
    
}

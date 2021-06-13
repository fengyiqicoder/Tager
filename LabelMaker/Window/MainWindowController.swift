//
//  MainWindowController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.title = "Tager 图标库"
        window?.subtitle = "0 个图标"
    }
    
    @IBOutlet weak var infoItem: NSToolbarItem!
    @IBOutlet weak var toolbar: NSToolbar!
    
    @IBAction func info(_ sender: NSToolbarItem) {
        print("Info")
    }
    
    @IBAction func add(_ sender: NSToolbarItem) {
        print("add item")
    }
    
}

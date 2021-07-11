//
//  InfoViewController.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/8.
//

import AppKit

class InfoViewController: NSViewController {
        
    static func showAsWindow() {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(identifier: "InfoViewController") as InfoViewController

        let window = NSWindow(contentViewController: vc)
        let windowController = NSWindowController(window: window)
        
        windowController.showWindow(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func done(_ sender: NSButton) {
        dismissPopover()
    }
    
}

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
    
    @IBOutlet weak var authorizeButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAuthorizeState()
    }
    
    func reloadAuthorizeState()  {
//        authorizeButton.isEnabled = !SandBoxController.shared.hasAccess
        authorizeButton.image = SandBoxController.shared.hasAccess ? NSImage(systemSymbolName: "checkmark.circle", accessibilityDescription: nil) : NSImage(systemSymbolName: "folder", accessibilityDescription: nil)
    }
    
    
    @IBAction func authorize(_ sender: NSButton) {
        //BookMark shit
        SandBoxController.shared.openChooseFoldPanel {
            self.reloadAuthorizeState()
            MainController.shared.reloadAccessState()
        }
    }
    
    
    @IBAction func done(_ sender: NSButton) {
        dismissPopover()
    }
    
}

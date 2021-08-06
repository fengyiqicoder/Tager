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
        self.title = ""
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        reloadAuthorizeState()
    }
    
    func reloadAuthorizeState()  {
        let hasAccess = SandBoxController.shared.hasAccess
        //FIXME: 还没解决bookmark过期问题,这个入口先一直开着
//        authorizeButton.isEnabled = !SandBoxController.shared.hasAccess
        authorizeButton.image = SandBoxController.shared.hasAccess ? NSImage(systemSymbolName: "checkmark.circle", accessibilityDescription: nil) : NSImage(systemSymbolName: "folder", accessibilityDescription: nil)
        if let window = self.view.window {
            var frame = window.frame
            frame.set(height: hasAccess ? 620 : 280)
            window.setFrame(frame, display: true, animate: true)
        }
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

extension CGRect {
    mutating func set(height: CGFloat) {
        let oldHeight = self.size.height
        self.size.height = height
        let gap = oldHeight - height
        self.origin.y += gap
    }
}

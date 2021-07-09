//
//  InfoViewController.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/8.
//

import AppKit

class InfoViewController: NSViewController {
        
    static func showAsWindow() {
        //FIXME: Show it in first time launch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func done(_ sender: NSButton) {
        dismissPopover()
    }
    
}

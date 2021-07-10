//
//  TextField.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/10.
//

import AppKit

class TextField: NSTextField {
    
    weak var customDelegate: TextFieldDelegate!
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        customDelegate.textFieldDidChange(textField: self)
    }
}

protocol TextFieldDelegate: AnyObject {
    func textFieldDidChange(textField: NSTextField)
}

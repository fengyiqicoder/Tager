//
//  IconEditor+Custom.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/12.
//

import AppKit

extension IconEditorViewController {
    
    var assignLabelSize: CGFloat? {
        get {
            autoSizeCheckBox.state == .on ? nil : CGFloat(customSizeSlider.floatValue)
        }
        set {
            if let currentSize = newValue {
                customSizeSlider.isEnabled = true
                setCustom(size: CGFloat(currentSize))
            } else {
                configCustomEditorView(size: nil)
                configPostionWith(type: selectedTypeItem?.itemType ?? ColorfulType.defualt.itemType)
                resetSymbol(size: symbolDefaultSize)
                save()
            }
        }
    }
    
    func configCustomEditorView(size: CGFloat?) {
        guard let oldSize = size else {
            autoSizeCheckBox.state = .on
            customSizeSlider.isEnabled = false
            return
        }
        autoSizeCheckBox.state = .off
        customSizeSlider.isEnabled = true
        customSizeSlider.floatValue = Float(oldSize)
        
        setCustom(size: oldSize)
    }
    @IBAction func autoSizeEnable(_ sender: NSButton) {
        if sender.state == .on {
            assignLabelSize = nil
        } else {
            assignLabelSize = CGFloat(customSizeSlider.floatValue)
        }
        
    }
    
    @IBAction func customsizeChanged(_ sender: NSSlider) {
        let currentSize = CGFloat(sender.floatValue)
        setCustom(size: currentSize)
    }
    
    func setCustom(size: CGFloat) {
//        markerLabelWidthConstraint.constant = size
        view.layoutSubtreeIfNeeded()
        markerLabel.resizeText()
        
        let symbolSize = size/2
        resetSymbol(size: symbolSize)
        save()
    }
}

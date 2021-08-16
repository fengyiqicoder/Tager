//
//  MaxiumFontLabel.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/2.
//

import AppKit

extension NSTextField {
    private var defaultMaxFontSize: CGFloat { 100 }
    
    func changeFontToFit(maxFontSize: CGFloat) {
        var currentTextWidth = CGFloat.greatestFiniteMagnitude
        var fitFontSize = maxFontSize
        
        while frame.width - 10 < currentTextWidth {
            fitFontSize -= 1
            let smallerFont = self.font!.to(pointSize: fitFontSize)
            currentTextWidth = stringValue.calculateWidth(font: smallerFont)
        }
        self.font = self.font!.to(pointSize: fitFontSize)
    }
    
    func set(text: String) {
        self.stringValue = text
        changeFontToFit(maxFontSize: defaultMaxFontSize)
    }
    
    func resizeText() {
        set(text: stringValue)
    }
}

fileprivate
extension String {
    func calculateWidth(font: NSFont) -> CGFloat {
        let attributionFont  = [NSAttributedString.Key.font: font]
        return (((self) as NSString).size(withAttributes: attributionFont)).width
    }
}

extension NSFont {
    func to(pointSize: CGFloat) -> NSFont {
        let font = NSFont(name: self.fontName, size: pointSize)!
        return font
    }
}

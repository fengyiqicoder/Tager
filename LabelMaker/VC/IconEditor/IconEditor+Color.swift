//
//  IconEditor+Color.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/12.
//

import AppKit

extension IconEditorViewController {
    var colorViews: [NSBox] { [ color1View, color2View, color3View, color4View, color5View, color6View ]}
    
    func initColorPicker() {
        colorViews.forEach { view in
            view.wantsLayer = true
            view.layer?.cornerRadius = 11
            view.layer?.cornerCurve = .continuous
            
        }
    }
    
    @IBAction func clickColorPicker(_ sender: NSClickGestureRecognizer) {
        let location = sender.location(in: colorPickerView)
        
        colorViews.enumerated().forEach { (order, box) in
            if box.frame.contains(location) {
                selectMarkShowOn(order: order)
                let color = colorViews[order].fillColor
                set(color: color.withAlphaComponent(CGFloat(opacitySlider.floatValue)))
                save()
            }
        }
    }
    
    func selectMarkShowOn(order: Int) {
        //color selected marker
        selectedMarker?.removeFromSuperview()
        
        let selectedColorView = colorViews[order]
        let selectedImage = NSImageView(frame: selectedColorView.frame)
        selectedImage.image = NSImage(named: "checkmark")
        colorPickerView.addSubview(selectedImage)
        
        selectedMarker = selectedImage
    }
    
    func set(color: NSColor) {
        //color changed
        markerLabel.textColor = color
        symbolImageView.contentTintColor = color
        selectedColor = color
    }
    
    func selected(color: NSColor) {
        var colorOrder = 0
        let originColor = color.withAlphaComponent(1.0)
        colorViews.enumerated().forEach { (order, view) in
            if view.fillColor.cgColor == originColor.cgColor {
                colorOrder = order
            }
            
        }
        selectMarkShowOn(order: colorOrder)
        set(color: color)
    }
    
    @IBAction func opacity(_ sender: NSSlider) {
        let currentOpacity = CGFloat(sender.floatValue)
        guard let color = selectedColor?.withAlphaComponent(currentOpacity) else { return }
        set(color: color)
        save()
    }
}

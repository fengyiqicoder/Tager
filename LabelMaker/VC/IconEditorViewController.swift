//
//  IconEditorViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/21.
//

import AppKit

class IconEditorViewController: NSViewController {
    //MARK: - Properties
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var markerTextField: NSTextField!
    @IBOutlet weak var markerTypeSwitch: NSSegmentedControl!
    @IBOutlet weak var markerColorBox: NSBox!
    var uuid: String!
    
    var model: IconModel {
        set {
            imageView.image = newValue.image
            nameTextField.stringValue = newValue.name
//            let color = NSColor(
//            labelTextField.
        }
        get {
            IconModel(uuid: uuid,
                      name: nameTextField.stringValue,
                      image: imageView.image!,
                      markerStr: markerTextField.stringValue)
        }
    }
    
}

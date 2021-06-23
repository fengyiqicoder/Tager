//
//  IconEditorViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/21.
//

import AppKit

class IconEditorWindowController: NSWindowController {
    static let shared = IconEditorWindowController()
    private var currentWindow: NSWindowController? = nil

    func closeAllEditorWindow() {
        NSApp.windows.forEach {
            if $0.contentViewController is IconEditorViewController {
                $0.close()
            }
        }
    }
    
    func show(model: IconModel) {
        closeAllEditorWindow()
        
        let newWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "IconEditorWindowController") as? IconEditorWindowController
        let frame = NSScreen.main!.getCenterFrame(with: newWindowController!.window!.frame.size)
        newWindowController?.window?.setFrame(frame, display: true)
        newWindowController?.vc.model = model
        newWindowController?.showWindow(nil)
        print("show \(model.uuid)")
        currentWindow = newWindowController
    }
    
    private var vc: IconEditorViewController {
        contentViewController as! IconEditorViewController
    }
}

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
            markerTextField.stringValue = newValue.markerStr
            uuid = newValue.uuid
        }
        get {
            IconModel(uuid: uuid,
                      name: nameTextField.stringValue,
                      markerStr: markerTextField.stringValue,
                      image: imageView.image!,
                      color: NSColor.white)
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        MainController.shared.deselect(id: uuid)
    }
}

extension NSScreen {
    func getCenterFrame(with size: CGSize) -> CGRect {
        if let mainSize = NSScreen.main?.frame.size {
            let x = mainSize.width/2 - size.width/2
            let y = mainSize.height/2 - size.height/2
            return CGRect(x: x, y: y, width: size.width, height: size.height)
        }
        return CGRect.zero
    }
}


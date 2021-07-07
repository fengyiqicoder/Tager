//
//  IconEditorViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/21.
//

import AppKit

class IconEditorWindowController: NSWindowController {
    static let shared = IconEditorWindowController()
    
    private var vc: IconEditorViewController {
        contentViewController as! IconEditorViewController
    }
    
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
        newWindowController?.vc.model = model
        newWindowController?.showWindow(nil)
    }
    
}

class IconEditorViewController: NSViewController {
    //MARK: - Properties
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var markerTextField: NSTextField!
    @IBOutlet weak var markerTypeSwitch: NSSegmentedControl!
    
    var uuid: String!
    
    private let markerMaxFontSize: CGFloat = 50
    var model: IconModel {
        set {
            imageView.image = NSImage(named: "folderIcon")
            nameTextField.stringValue = newValue.name
            
            if let markerStr = newValue.markerStr {
                setMarker(string: markerStr)
            }
            if let symbolStr = newValue.symbolStr {
                setSymbol(name: symbolStr)
            }
            
            uuid = newValue.uuid
            selected(color: newValue.color)
        }
        get {
            //FIXME: ICON image 分辨率不够高
            var model = IconModel(uuid: uuid,
                                  name: nameTextField.stringValue,
                                  image: iconView.image(),
                                  color: selectedColor ?? NSColor.white)
            if isUsingSymbol {
                model.set(symbolStr: symbolName ?? "")
            } else {
                model.set(markerStr: markerTextField.stringValue)
            }
            return model
        }
    }
    
    //MARK: - ColorPicker
    
    private var selectedColor: NSColor?
    
    @IBOutlet weak var colorPickerView: NSBox!
    @IBOutlet weak var clickGesture: NSClickGestureRecognizer!
    @IBOutlet weak var color1View: NSBox!
    @IBOutlet weak var color2View: NSBox!
    @IBOutlet weak var color3View: NSBox!
    @IBOutlet weak var color4View: NSBox!
    @IBOutlet weak var color5View: NSBox!
    @IBOutlet weak var color6View: NSBox!
    private var colorViews: [NSBox] { [ color1View, color2View, color3View, color4View, color5View, color6View ]}

    @IBAction func clickColorPicker(_ sender: NSClickGestureRecognizer) {
        let colorCount = 6
        let location = sender.location(in: colorPickerView)
        let colorWidth = colorPickerView.frame.width/CGFloat(colorCount)
        
        var selected = 0
        for selectedColor in 1...colorCount
            where location.x < CGFloat(selectedColor)*colorWidth {
                selected = selectedColor
                break
        }
        
        selected -= 1
        selectedColor(order: selected)
        save()
    }
    
    private var selectedMarker: NSImageView?
    private func selectedColor(order: Int) {
        //color selected marker
        selectedMarker?.removeFromSuperview()
        
        let selectedColorView = colorViews[order]
        let selectedImage = NSImageView(frame: selectedColorView.frame)
        selectedImage.image = NSImage(named: "checkmark")
        colorPickerView.addSubview(selectedImage)
        
        selectedMarker = selectedImage
        
        //color changed
        let color = colorViews[order].fillColor
        markerLabel.textColor = color
        symbolImageView.contentTintColor = color
        selectedColor = color
    }
    
    
    private func selected(color: NSColor) {
        var colorOrder = 0
        colorViews.enumerated().forEach { (order, view) in
            if view.fillColor.cgColor == color.cgColor {
                colorOrder = order
            }   

        }
        selectedColor(order: colorOrder)
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        markerTextField.delegate = self
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        MainController.shared.deselect(id: uuid)
    }
    
    //MARK: - Icon generator
    
    @IBOutlet weak var iconView: NSView!
    @IBOutlet weak var folderImageView: NSImageView!
    @IBOutlet weak var symbolImageView: NSImageView!
    @IBOutlet weak var markerLabel: NSTextField!
    @IBOutlet weak var symbolLabel: NSImageView!
    
    //MARK: - Popover symbolPicker
    
    var isUsingSymbol: Bool {
        set {
            markerLabel.isHidden = newValue
            symbolImageView.isHidden = !newValue
            markerTextField.isHidden = newValue
            symbolLabel.isHidden = !newValue
            
            markerTypeSwitch.selectedSegment = newValue ? 1 : 0
        }
        get {
            markerTypeSwitch.isSelected(forSegment: 1)
        }
    }
    
    @IBAction func switchChanged(_ sender: NSSegmentedControl) {
        if sender.isSelected(forSegment: 1) {
            isUsingSymbol = true
            showSymbolePicker(from: sender)
        } else {
            isUsingSymbol = false
            popoverVC?.dismissPopover()
        }
        
        markerTextField.isHidden = isUsingSymbol
    }
    
    private var popoverVC: NSViewController?
    func showSymbolePicker(from sourceView: NSView){
        let popover = NSPopover()
        popover.behavior = .semitransient
        popover.animates = true
        
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(identifier: "SymbolPickerVewController") as SymbolPickerViewController
        vc.symbolDelegate = self
        popover.contentViewController = vc
        popover.show(relativeTo: sourceView.bounds, of: sourceView, preferredEdge: .maxX)
        popoverVC = vc
    }
    
    //Abount symbol
    private var symbolName: String?
    private func setSymbol(name: String) {
        symbolName = name
        isUsingSymbol = true
        
        let symbolSize: CGFloat = 60
        symbolLabel.image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        symbolImageView.image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular))
        symbolImageView.contentTintColor = selectedColor ?? NSColor.white
    }
    
    private func setMarker(string: String) {
        isUsingSymbol = false
        markerLabel.set(text: string, with: 50)
        if markerTextField.stringValue != string {
            markerTextField.stringValue = string
        }
    }

}

extension IconEditorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        //FIXME: 名称textfield会触发这个
        setMarker(string: model.markerStr ?? "nil")
        save()
    }
    
    func save() {
        IconModelController.shared.save(model: model)
        MainController.shared.collectionView.reloadData()
    }
}

extension IconEditorViewController: SymbolItemDelegate {
    func didSelect(item: SymbolItem) {
        setSymbol(name: item.symbol)
        popoverVC?.dismissPopover()
        save()
    }
}

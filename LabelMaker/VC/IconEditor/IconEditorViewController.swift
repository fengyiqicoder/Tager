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
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var markerTextField: TextField!
    @IBOutlet weak var markerTypeSwitch: NSSegmentedControl!
    
    var uuid: String!
    
    private let markerMaxFontSize: CGFloat = 50
    var model: IconModel {
        set {
            view.window?.title = newValue.name
            let imageName = newValue.type?.imageAssetName ?? "folderIcon"
            imageView.image = NSImage(named: imageName)
            nameTextField.stringValue = newValue.name
            
            if let markerStr = newValue.markerStr {
                setMarker(string: markerStr)
            }
            if let symbolStr = newValue.symbolStr {
                setSymbol(name: symbolStr)
            }
            
            uuid = newValue.uuid
            
            selected(color: newValue.color)
            opacitySlider.floatValue = Float(newValue.color.alphaComponent)
            //Select image asset
            initSelectedType(item: newValue.type ?? ColorfulType.defualt)
            configPostionWith(type: newValue.type?.itemType ?? ColorfulType.defualt.itemType)
            
            configCustomEditorView(size: newValue.assignLabelSize)
        }
        get {
            var model = IconModel(uuid: uuid,
                                  name: nameTextField.stringValue,
                                  image: iconView.image(),
                                  color: selectedColor ?? NSColor.white)
            
            //这两个属性可能是空的,用户使用的是旧版本的Tager
            model.type = selectedItemWithColor ?? selectedTypeItem
            model.assignLabelSize = assignLabelSize
            if isUsingSymbol {
                model.set(symbolStr: symbolName ?? "")
            } else {
                model.set(markerStr: markerTextField.stringValue)
            }
            return model
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.tag = 0
        markerTextField.tag = 1
        nameTextField.customDelegate = self
        markerTextField.customDelegate = self
        
        configTypeSelection()
        initColorPicker()
    }
    
    var justLoaeded: Bool = true
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        MainController.shared.deselect(id: uuid)
        
    }
    
    //MARK: - Type
    @IBOutlet weak var typeCollectionView: TypeCollectionView!
    @IBOutlet weak var typeSelectScrollView: NSScrollView!
    @IBOutlet weak var typeWithColorCollectionView: TypeCollectionView!
    
    var selectedTypeItem: ColorfulType? {
        didSet {
            guard let newType = selectedTypeItem else { return }
            configPostionIfNoAutosize(type: newType.itemType)
            
            typeWithColorCollectionView.reloadData()
            if !justLoaeded {
                DispatchQueue.main.async {
                    self.typeWithColorCollectionView.select(order: 0)
                }
            } else {
                justLoaeded = false
            }
        }
    }
    
    var selectedItemWithColor: ColorfulType? {
        didSet {
            guard let item = selectedItemWithColor, let image = item.image else { return }
            imageView.image = image
            save()
        }
    }
    
    //MARK: - Color View
    @IBOutlet weak var colorPickerView: NSBox!
    @IBOutlet weak var clickGesture: NSClickGestureRecognizer!
    @IBOutlet weak var color1View: NSBox!
    @IBOutlet weak var color2View: NSBox!
    @IBOutlet weak var color3View: NSBox!
    @IBOutlet weak var color4View: NSBox!
    @IBOutlet weak var color5View: NSBox!
    @IBOutlet weak var color6View: NSBox!
    
    var selectedMarker: NSImageView?
    var selectedColor: NSColor?
    
    //Opacity
    @IBOutlet weak var opacitySlider: NSSlider!
    
    
    //MARK: - Icon generator
    
    @IBOutlet weak var iconView: NSView!
    @IBOutlet weak var folderImageView: NSImageView!
    @IBOutlet weak var symbolImageView: NSImageView!
    @IBOutlet weak var markerLabel: NSTextField!
    @IBOutlet weak var symbolLabel: NSImageView!
    
    @IBOutlet weak var markerLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var symbolLabelTopConstraint: NSLayoutConstraint!
    
    //MARK: - Custom
    @IBOutlet weak var autoSizeCheckBox: NSButton!
    @IBOutlet weak var customSizeSlider: NSSlider!
    
    
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
    
    var popoverVC: NSViewController?
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
    
    //Abount Icon Generator
    
    private var symbolName: String?
    let symbolDefaultSize: CGFloat = 60

     func setSymbol(name: String) {
        symbolName = name
        isUsingSymbol = true
        
        symbolLabel.image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        symbolImageView.image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: symbolDefaultSize, weight: .regular))
        symbolImageView.contentTintColor = selectedColor ?? NSColor.white
    }
    
    func resetSymbol(size: CGFloat) {
        guard let name = symbolName else { return }
        let symbolSize: CGFloat = size
        symbolImageView.image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular))
    }
    
    func setMarker(string: String) {
        isUsingSymbol = false
        markerLabel.set(text: string, with: 50)
        if markerTextField.stringValue != string {
            markerTextField.stringValue = string
        }
    }

    //MARK: - Editing buttons
    
    @IBOutlet weak var editLabelButton: NSButton!
    @IBOutlet weak var editColorButton: NSButton!
    @IBOutlet weak var editTypeButton: NSButton!
    @IBOutlet weak var editCustomizeButton: NSButton!
    fileprivate var editButtons: [NSButton] {
        [editLabelButton, editColorButton, editTypeButton, editCustomizeButton]
    }
    fileprivate let editTintColor: NSColor = #colorLiteral(red: 0.4434176981, green: 0.8099910617, blue: 0.9819725156, alpha: 1)
    
    fileprivate
    var buttonToTypeDict: [NSButton: EditingSchema] {
        [ editLabelButton: .label,
          editColorButton: .color,
          editTypeButton: .type,
          editCustomizeButton: .custom]
    }
    
    fileprivate
    var typeToButtonDict: [EditingSchema: NSButton] {
        [ .label: editLabelButton,
          .color: editColorButton,
          .type: editTypeButton,
          .custom: editCustomizeButton]
    }
    
    
    fileprivate
    var currentEditingType: EditingSchema = .label {
        didSet {
            editButtons.forEach { button in
                button.contentTintColor = nil
            }
            let button = typeToButtonDict[currentEditingType]
            button?.contentTintColor = editTintColor
            
            editorViews.forEach { $0.isHidden = true}
            typeToEditorView[currentEditingType]?.isHidden = false
        }
    }
    
    @IBAction
    func openEditPanel(sender: NSButton) {
        let typedType = buttonToTypeDict[sender]!
        if currentEditingType != typedType {
            currentEditingType = typedType
        }
    }
    
    //MARK: - Editing views
    
    @IBOutlet weak var labelEditorView: NSBox!
    @IBOutlet weak var colorEditorView: NSBox!
    @IBOutlet weak var typeEditorView: NSBox!
    @IBOutlet weak var customizeEditorView: NSBox!
    
    fileprivate
    var editorViews: [NSBox] {
        [labelEditorView, colorEditorView, typeEditorView, customizeEditorView]
    }
    fileprivate
    var typeToEditorView: [EditingSchema: NSBox] {
        [ .label: labelEditorView,
          .color: colorEditorView,
          .type: typeEditorView,
          .custom: customizeEditorView ]
    }
    
    
    
}

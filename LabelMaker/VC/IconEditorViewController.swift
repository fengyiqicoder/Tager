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
            initSelected(item: newValue.type ?? ColorfulType.defualt)
            configPostionWith(type: newValue.type?.itemType ?? ColorfulType.defualt.itemType)
        }
        get {
            var model = IconModel(uuid: uuid,
                                  name: nameTextField.stringValue,
                                  image: iconView.image(),
                                  color: selectedColor ?? NSColor.white)
            model.type = selectedItemWithColor ?? selectedTypeItem
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
    
    var isViewAppeared: Bool = false
    override func viewDidAppear() {
        super.viewDidAppear()
        isViewAppeared = true
    }
    
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        MainController.shared.deselect(id: uuid)
        
    }
    
    //MARK: - Type
    @IBOutlet weak var typeCollectionView: TypeCollectionView!
    @IBOutlet weak var typeSelectScrollView: NSScrollView!
    @IBOutlet weak var typeWithColorCollectionView: TypeCollectionView!
    
    func initSelected(item: ColorfulType) {
        let type = item.itemType.defualtColor
        typeItems.enumerated().forEach {
            if $1.imageAssetName == type.imageAssetName {
                typeCollectionView.select(order: $0)
            }
        }
        typeItemsWithColor.enumerated().forEach {
            if $1.imageAssetName == item.imageAssetName {
                let order = $0
                DispatchQueue.main.async {
                    self.typeWithColorCollectionView.select(order: order)
                }
            }
        }
    }
    
    var selectedTypeItem: ColorfulType? {
        didSet {
            guard let newType = selectedTypeItem else { return }
            configPostionWith(type: newType.itemType)
            typeWithColorCollectionView.reloadData()
            if isViewAppeared {
                DispatchQueue.main.async {
                    self.typeWithColorCollectionView.select(order: 0)
                }
            }
        }
    }
    var selectedItemWithColor: ColorfulType? {
        didSet {
            guard let item = selectedItemWithColor, let image = item.image else { return }
            imageView.image = image
            //save
            save()
        }
    }
    
    func configPostionWith(type: IconModel.ItemType) {
        guard let postionConfig = IconModel.ItemsPostionConfigDict[type] else { return }
        markerLabelWidthConstraint.constant = postionConfig.markerWidth
        markerLabelCenterYConstraint.constant = postionConfig.markerCenterOffset
        symbolLabelTopConstraint.constant = postionConfig.symbolsCenterOffset
        view.layoutSubtreeIfNeeded()
        markerLabel.resizeText()
    }
    
    var typeItems: [ColorfulType] {
        IconModel.ItemTypes
    }
    var typeItemsWithColor: [ColorfulType] {
        guard let item = selectedTypeItem else { return [] }
        let colorTypes = IconModel.ItemsColorDict[item.itemType]!
        let currentTypeColorItem = colorTypes.map{
            ColorfulType(type: item.itemType, color: $0)
        }
        return currentTypeColorItem
    }
    
    func configTypeSelection() {
        typeCollectionView.isTypeItem = true
        typeWithColorCollectionView.isTypeItem = false
        
        typeCollectionView.config()
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self

        typeWithColorCollectionView.config()
        typeWithColorCollectionView.delegate = self
        typeWithColorCollectionView.dataSource = self
        
    }
    
    //MARK: - Color View
    
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
    
    private func initColorPicker() {
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
    
    private var selectedMarker: NSImageView?
    private func selectMarkShowOn(order: Int) {
        //color selected marker
        selectedMarker?.removeFromSuperview()
        
        let selectedColorView = colorViews[order]
        let selectedImage = NSImageView(frame: selectedColorView.frame)
        selectedImage.image = NSImage(named: "checkmark")
        colorPickerView.addSubview(selectedImage)
        
        selectedMarker = selectedImage
    }
    
    private func set(color: NSColor) {
        //color changed
        markerLabel.textColor = color
        symbolImageView.contentTintColor = color
        selectedColor = color
    }
    
    private func selected(color: NSColor) {
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
    
    //Opacity
    
    @IBOutlet weak var opacitySlider: NSSlider!
    @IBAction func opacity(_ sender: NSSlider) {
        let currentOpacity = CGFloat(sender.floatValue)
        guard let color = selectedColor?.withAlphaComponent(currentOpacity) else { return }
        set(color: color)
        save()
    }
    
    
    //MARK: - Icon generator
    
    @IBOutlet weak var iconView: NSView!
    @IBOutlet weak var folderImageView: NSImageView!
    @IBOutlet weak var symbolImageView: NSImageView!
    @IBOutlet weak var markerLabel: NSTextField!
    @IBOutlet weak var symbolLabel: NSImageView!
    
    @IBOutlet weak var markerLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var symbolLabelTopConstraint: NSLayoutConstraint!
    
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
    
    //Abount Icon Generator
    
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

enum EditingSchema {
    case label
    case color
    case type
    case custom
}

extension IconEditorViewController: TextFieldDelegate {
    func textFieldDidChange(textField: NSTextField) {
        //Meaning textField is marker
        if textField.tag == 1 {
            setMarker(string: model.markerStr ?? "nil")
        }
        save()
    }
    
    func save() {
        IconModelController.shared.save(model: model)
        view.window?.title = model.name
        MainController.shared.reload()
    }
}

extension IconEditorViewController: SymbolItemDelegate {
    func didSelect(item: SymbolItem) {
        setSymbol(name: item.symbol)
        popoverVC?.dismissPopover()
        save()
    }
}

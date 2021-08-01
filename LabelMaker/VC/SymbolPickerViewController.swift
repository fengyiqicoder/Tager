//
//  SymbolPickerViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/4.
//

import AppKit

class SymbolPickerViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var switcherButton: NSPopUpButton!
    @IBOutlet weak var searchField: NSSearchField!
    
    weak var symbolDelegate: SymbolItemDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size: CGFloat = 120
        let flowLayout = NSCollectionViewGridLayout()
        flowLayout.minimumItemSize = NSSize(width: size, height: size)
        flowLayout.maximumItemSize = NSSize(width: size, height: size)
        flowLayout.minimumInteritemSpacing = 12.0
        flowLayout.minimumLineSpacing = 12.0

        
        collectionView.enclosingScrollView?.contentInsets.top = 270
        collectionView.collectionViewLayout = flowLayout
        collectionView.isSelectable = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setUpSwitch()
        setUpSearchField()
    }
    
    private var currentSymbolGroup: SymbolGroup {
        Symbols.shared.group[switcherButton.indexOfSelectedItem]
    }
    
    private func setUpSearchField() {
        searchField.delegate = self
    }
    
    private func setUpSwitch() {
        switcherButton.menu?.removeAllItems()
        
        Symbols.shared.group.forEach { group in
            let item = NSMenuItem(title: group.groupName, action: #selector(selectItem(sender:)), keyEquivalent: "")
            item.image = NSImage(systemSymbolName: group.groupSymbol, accessibilityDescription: nil)
            switcherButton.menu?.addItem(item)
        }
        
        switcherButton.selectItem(at: 0)
    }
    
    @objc
    func selectItem(sender: NSMenuItem) {
        collectionView.scroll(NSPoint.zero)
        collectionView.reloadData()
    }
    
}

extension SymbolPickerViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if let searchWordStr = currentSearchingValue {
            return makeSearchItem(inputStr: searchWordStr).count
        } else {
            return currentSymbolGroup.symbolNames.count
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SymbolItem"), for: indexPath) as! SymbolItem
        
        if let searchWordStr = currentSearchingValue {
            item.symbol = makeSearchItem(inputStr: searchWordStr)[indexPath.item]
        } else {
            item.symbol = currentSymbolGroup.symbolNames[indexPath.item]
        }
        
        item.delegate = self.symbolDelegate
        return item
    }
    
}

extension SymbolPickerViewController: NSSearchFieldDelegate {
    
    var currentSearchingValue: String? {
        return searchField.stringValue == "" ? nil : searchField.stringValue
    }
    
    func controlTextDidChange(_ obj: Notification) {
        switcherButton.selectItem(at: 0)
        collectionView.reloadData()
    }

    func makeSearchItem(inputStr: String) -> [String] {
        let keywords = inputStr.split(separator: " ")
        let allSymbolNames = Symbols.shared.group.first!.symbolNames
        var result: [String] = []
        keywords.forEach { keyword in
            result = allSymbolNames.compactMap({ symbol in
                return symbol.contains(keyword) ? symbol : nil
            })
        }
        return result
    }
}

extension NSViewController {
    func dismissPopover() {
        self.view.window?.performClose(nil)
    }
}

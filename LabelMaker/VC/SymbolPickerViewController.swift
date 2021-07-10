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
    }
    
    var currentSymbolGroup: SymbolGroup {
        Symbols.shared.group[switcherButton.indexOfSelectedItem]
    }
    
    func setUpSwitch() {
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
        return currentSymbolGroup.symbolNames.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SymbolItem"), for: indexPath) as! SymbolItem
        item.symbol = currentSymbolGroup.symbolNames[indexPath.item]
        item.delegate = self.symbolDelegate
        return item
    }
    
}

extension NSViewController {
    func dismissPopover() {
        self.view.window?.performClose(nil)
    }
}

//
//  TypeCollectionView.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/10.
//

import AppKit

typealias ItemType = IconModel.ItemTypeWithColor

class TypeCollectionView: NSCollectionView {
    var isTypeItem: Bool!
    
    func config() {
        self.collectionViewLayout = flow
        self.isSelectable = true
    }
    
    func selectFirst() {
        selectItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: .left)
    }

    private var flow: NSCollectionViewFlowLayout {
        let flow = NSCollectionViewFlowLayout()
        let itemSize = CGFloat(50)
        flow.itemSize = CGSize(width: itemSize, height: itemSize)
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        return flow
    }
    
}

extension IconEditorViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let typeCollectionView = collectionView as! TypeCollectionView
        if typeCollectionView.isTypeItem {
            selectedTypeItem = typeItems[indexPaths.first!.item]
        } else {
            selectedItemColor = typeColorfulItems[indexPaths.first!.item]
        }
    }
}
extension IconEditorViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let typeCollectionView = collectionView as! TypeCollectionView
        return typeCollectionView.isTypeItem ? typeItems.count : typeColorfulItems.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let typeCollectionView = collectionView as! TypeCollectionView
        let items = typeCollectionView.isTypeItem ? typeItems : typeColorfulItems
        
        let image = NSImage(named: items[indexPath.item].imageAssetName)
        let itemCell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TypeItem"), for: indexPath) as! TypeItem
        itemCell.itemImage.image = image
        return itemCell
    }
    
}


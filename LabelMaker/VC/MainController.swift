//
//  ViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa

class MainController: NSViewController {
    
    static var shared: MainController! {
        for window in NSApp.windows {
            if let mainWindow = window.contentViewController as? MainController {
                return mainWindow
            }
        }
        return nil
    }
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = NSCollectionViewGridLayout()
        flowLayout.minimumItemSize = NSSize(width: 160.0, height: 210.0)
        flowLayout.minimumInteritemSpacing = 12.0
        flowLayout.minimumLineSpacing = 20.0
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.isSelectable = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func deselect(id: String) {
        model.iconModels.enumerated().forEach { (order, itemModel) in
            if itemModel.uuid == id {
                collectionView.deselectItems(at: [IndexPath(item: order, section: 0)])
            }
        }
    }
    
    func deselectAll() {
        collectionView.deselectItems(at: collectionView.selectionIndexPaths)
    }
    
    func addNewIcon() {
        model.iconModels.append(IconModel.defualt)
        collectionView.reloadData()
    }
}

extension MainController: NSCollectionViewDataSource {
    
    var model: IconModelController {
        IconModelController.shared
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        model.iconModels.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let itemModel = model.iconModels[indexPath.item]
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IconItem"), for: indexPath) as! IconItem
        item.label.stringValue = itemModel.name
        item.image.image = itemModel.image
        return item
    }
}

extension MainController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let index = indexPaths.first!
        let item = collectionView.item(at: index.item) as! IconItem
        item.isSelected = true
        
        let itemModel = model.iconModels[index.item]
        IconEditorWindowController.shared.show(model: itemModel)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach {
            let item = collectionView.item(at: $0) as! IconItem
            item.isSelected = false
        }
    }
}

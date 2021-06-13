//
//  ViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa

class MainController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        collectionView.dataSource = self
        //        collectionView.register(IconCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "item"))
    }
    
}

extension MainController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = NSCollectionViewItem()
        //        item.iconTitle.stringValue = "ff"
        return item
    }
    
    
}




class CollectionViewItem: NSCollectionViewItem {
    
    var itemView: ItemView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func loadView() {
        self.itemView = ItemView(frame: NSZeroRect)
        self.view = self.itemView!
    }
    
    func getView() -> ItemView {
        return self.itemView!
    }
}


class ItemView: NSView {
    
    let buttonSize: NSSize = NSSize(width: 100, height: 20)
    let itemSize: NSSize = NSSize(width: 120, height: 40)
    let buttonOrigin: NSPoint = NSPoint(x: 10, y: 10)
    
    var button: NSButton?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: NSRect(origin: frameRect.origin, size: itemSize))
        let newButton = NSButton(frame: NSRect(origin: buttonOrigin, size: buttonSize))
        //    newButton.bezelStyle = NSBezelStyle.RoundedBezelStyle
        self.addSubview(newButton)
        self.button = newButton;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonTitle(title: String) {
        self.button!.title = title
    }
}


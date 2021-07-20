//
//  Sandbox.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/13.
//
// https://developer.apple.com/forums/thread/66259?answerId=278355022#278355022
// https://stackoverflow.com/questions/37897118/using-security-scoped-bookmark-in-finder-sync-extension-with-app-group-userdefau?rq=1

import AppKit

class SandBoxController: NSObject {
    
    static let shared = SandBoxController()
    lazy var homeURLPath: String = {
        let paths = FileManager.default.homeDirectoryForCurrentUser.pathComponents
        let path = paths[0]+paths[1]+"/"+paths[2]
        return path
    }()
    
    
    func openChooseFoldPanel(handler: (()->Void)? = nil ) {
        let openPanel = NSOpenPanel()
        openPanel.directoryURL = URL(string: homeURLPath)
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.message = "Click Open Button".localize
        openPanel.delegate = self
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                guard let url = openPanel.urls.first else { return }
                //using .minimalBookmark to make it work in extension
                //it do not have any app scope so it can't work on the app itself
                let data = try! url.bookmarkData(options: [.minimalBookmark], includingResourceValuesForKeys: nil, relativeTo: nil)
                self.bookmarkData = data
                self.accessableURL = url.path
                print(url.path)
                handler?()
            }
        }
    }
    
    //Only used in Extension
    func getAccessInExtension() {
        restoreBookmark()
    }
    
    var hasAccess: Bool {
        accessableURL == "/" || accessableURL == homeURLPath
    }
    
    var accessableURL: String? {
        set {
            UserDefaults.appGroup.setValue(newValue, forKey: "accessableURL")
        }
        get {
            (UserDefaults.appGroup.object(forKey: "accessableURL") as? String)
        }
    }
    
    private var bookmarkData: Data? {
        set {
            UserDefaults.appGroup.setValue(newValue, forKey: "bookmark")
        }
        get {
            (UserDefaults.appGroup.object(forKey: "bookmark") as? Data)
        }
    }
    
    private func restoreBookmark() {
        guard let bookmarkData = bookmarkData else {
            print("Bookmarkdata nil")
            return
        }
        do{
          var isStale = ObjCBool(false)
          let url = try NSURL(resolvingBookmarkData: bookmarkData, options: URL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
          
          print("resolved url \(url)")
          
          if isStale.boolValue{
            print("renew bookmark data")
            //Does it need to do this at main app?
            let renewBookMark = try url.bookmarkData(options: [.minimalBookmark], includingResourceValuesForKeys: nil, relativeTo: nil)
            self.bookmarkData = renewBookMark
          }
          
          if !url.startAccessingSecurityScopedResource(){
            print("Failed to access sandbox files")
          }
          
          print("Started accessing")
          
        } catch {
          print(error.localizedDescription)
        }

    }
    
}

extension SandBoxController: NSOpenSavePanelDelegate {
     
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        return url.path == homeURLPath
    }
}

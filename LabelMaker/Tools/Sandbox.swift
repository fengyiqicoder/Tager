//
//  Sandbox.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/13.
//

import AppKit

class SandBoxController {
    
    static let shared = SandBoxController()
    
    func openChooseFoldPanel() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.message = "Choose fengyq folder"
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                
                guard let url = openPanel.urls.first else { return }
                let data = try! url.bookmarkData(options: [.withSecurityScope], includingResourceValuesForKeys: nil, relativeTo: nil)
                self.bookmarkData = data
                self.getAccess()
            }
        }
    }
    
    func getAccess() {
        restoreBookmark()
    }
    
    
    var bookmarkData: Data? {
        set {
            UserDefaults.appGroup.setValue(newValue, forKey: "bookmark")
        }
        get {
            (UserDefaults.appGroup.object(forKey: "bookmark") as? Data)
        }
    }
    
    func restoreBookmark() {
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
            let renewBookMark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            self.bookmarkData = renewBookMark
          }
          
          if !url.startAccessingSecurityScopedResource(){
//            alert("Failed to access sandbox files")
          }
          
          print("Started accessing")
//          return true
          
        } catch {
//          alert(error.localizedDescription)
//          return false
        }

    }
    
}

//var bookmarks = [URL: Data]()
//
//func openFolderSelection() -> URL? {
//    let openPanel = NSOpenPanel()
//    openPanel.allowsMultipleSelection = false
//    openPanel.canChooseDirectories = true
//    openPanel.canCreateDirectories = true
//    openPanel.canChooseFiles = false
//    openPanel.begin
//    { (result) -> Void in
//        if result.rawValue == NSApplication.ModalResponse.OK.rawValue
//        {
//            let url = openPanel.url
//            storeFolderInBookmark(url: url!)
//        }
//    }
//    return openPanel.url
//}
//
//func saveBookmarksData() {
//    let data = try? NSKeyedArchiver.archivedData(withRootObject: bookmarks, requiringSecureCoding: false)
//    UserDefaults.appGroup.setValue(data, forKey: "bookmark")
//}
//
//func getBookmarkData() -> [URL: Data] {
//    let data = UserDefaults.appGroup.object(forKey: "bookmark") as! Data
//    let bookmark = try! NSKeyedUnarchiver.unarchivedDictionary(ofKeyClass: URL.self, objectClass: Data.self, from: data)
//    return bookmark
//
//}
//
//func storeFolderInBookmark(url: URL) {
//    do
//    {
//        let data = try url.bookmarkData(options: NSURL.BookmarkCreationOptions.withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
//        bookmarks[url] = data
//    }
//    catch
//    {
//        Swift.print ("Error storing bookmarks")
//    }
//
//}
//
////func getBookmarkPath() -> URL {
////    var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
////    url = url.appendingPathComponent("Bookmarks.dict")
////    return url
////}
//
//func loadBookmarks() {
//    let path = getBookmarkPath()
////    bookmarks = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [URL: Data]
//
//    for bookmark in bookmarks
//    {
//        restoreBookmark(bookmark)
//    }
//}
//
//
//
//func restoreBookmark(_ bookmark: (key: URL, value: Data)) {
//    let restoredUrl: URL?
//    var isStale = false
//
//    Swift.print ("Restoring \\(bookmark.key)")
//    do
//    {
//        restoredUrl = try URL.init(resolvingBookmarkData: bookmark.value, options: NSURL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
//    }
//    catch
//    {
//        Swift.print ("Error restoring bookmarks")
//        restoredUrl = nil
//    }
//
//    if let url = restoredUrl
//    {
//        if isStale
//        {
//            Swift.print ("URL is stale")
//        }
//        else
//        {
//            if !url.startAccessingSecurityScopedResource()
//            {
//                Swift.print ("Couldn't access: \\(url.path)")
//            }
//        }
//    }
//}

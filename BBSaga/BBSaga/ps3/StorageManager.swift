//
//  StorageManager.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 29/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation

enum StorageManagerMode {
    case save
    case load
}

class StorageManager {
    private var underlyingFileManager = FileManager.default
    private var storageManagerMode = StorageManagerMode.save
    private var documentDirURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    private var BBSagaGameDirURL: URL {
        let BBSagaGameDirURL = documentDirURL.appendingPathComponent("BBSaga", isDirectory: true)
        if !underlyingFileManager.fileExists(atPath: BBSagaGameDirURL.path) {
            do {
                try underlyingFileManager.createDirectory(at: BBSagaGameDirURL,
                                                          withIntermediateDirectories: false,
                                                          attributes: nil)
            } catch _ {
                assert(false)
            }
        }
        return BBSagaGameDirURL
    }
    private var gridDesignDirURL: URL {
        let gridDesignDirURL = BBSagaGameDirURL.appendingPathComponent("BubbleGridDesigns", isDirectory: true)
        if !underlyingFileManager.fileExists(atPath: gridDesignDirURL.path) {
            do {
                try underlyingFileManager.createDirectory(at: gridDesignDirURL,
                                                          withIntermediateDirectories: false,
                                                          attributes: nil)
            } catch _ {
                assert(false)
            }
        }
        return gridDesignDirURL
    }
    
    func getCurrentMode() -> StorageManagerMode {
        return storageManagerMode
    }
    
    func setMode(to mode: StorageManagerMode) {
        storageManagerMode = mode
    }
    
    /// load a list of urls in the Document directory,
    /// the files at those urls are supposed to either be empty
    /// or contain the BubbleGrids that have been previously saved inside
    func loadBubbleGridFileURLs() -> [URL]? {
        return try? underlyingFileManager.contentsOfDirectory(
            at: gridDesignDirURL,
            includingPropertiesForKeys: nil,
            options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
    }
    
    /// create a new empty .plist file in the Document directory
    /// if a file of the same name already exists,
    /// the original one will be overwritten by the newly-created empty one
    func createEmptyBubbleGridPlistFile(ofName name: String) {
        let fileURL = gridDesignDirURL.appendingPathComponent(name + ".plist")
        underlyingFileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
    }
    
    /// remove the .plist file at the given url
    func removePlist(at url: URL) {
        try? underlyingFileManager.removeItem(at: url)
    }
    
    func save(contentDic: [String: AnyObject], into fileURL: URL) {
        let contentDataDic = NSKeyedArchiver.archivedData(withRootObject: contentDic)
        try? contentDataDic.write(to: fileURL)
    }
    
    /// try to load data from the file at the specified URL
    /// - returns: the content loaded from the specified file, which is an Optional Dictionary 
    ///     whose keys are of String type and values are of Anyobect type
    ///     if the URL is invalid or the file is empty, return nil
    func load(from fileURL: URL) -> Dictionary<String, AnyObject>? {
        guard let loadedData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        guard !loadedData.isEmpty else {
            return nil
        }
        guard let decodedData = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [String: AnyObject] else {
            return nil
        }
        return decodedData
    }
}











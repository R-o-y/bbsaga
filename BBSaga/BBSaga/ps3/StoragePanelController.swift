//
//  StoragePanelController.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 29/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class StoragePanelController: UITableViewController {
    private var storageManager = StorageManager()
    private let noContentMessage = Setting.noContentMessage
    private let confirmSaveQuestion = Setting.confirmSaveQuestion
    private let confirmLoadQuestion = Setting.confirmLoadQuestion
    private let confirmRemoveQuestion = Setting.confirmRemoveQuestion
    private let inputNamePlaceholder = Setting.inputNamePlaceholder
    private let loadOverwrittenWarning = Setting.loadOverwrittenWarning
    
    func setUpStoragePanel() {
        guard let storagePanel = tableView else {
            return
        }
        storagePanel.layer.cornerRadius = storagePanel.bounds.width * Setting.storagePanelCornerRadiusRate
        storagePanel.rowHeight = Setting.storagePanelRowHeightRatio * storagePanel.bounds.width
        startObservingRemoveGridRequest()
        bindGestureRecognizer(to: storagePanel)

        setupStoragePanelHeader()
    }
    
    /// helper function to bind gesture recognizers
    private func bindGestureRecognizer(to storagePanel: UITableView) {
        storagePanel.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(saveOrLoadByTapping(_:))))
    }
    
    private func startObservingRemoveGridRequest() {
        let name = NSNotification.Name(rawValue: Setting.removeGridNotificationName)
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil,
                                               using: { [weak self] notification in
            if let url = notification.object as? URL {
                self?.removeGrid(at: url)
            }
        })
    }
    
    /// helper function to add a header to storagePanel, this header has 2 function:
    /// 1. to inform users long press to delete
    /// 2. show a button to enable creating new empty file to save into
    private func setupStoragePanelHeader() {
        guard let storagePanel = tableView else {
            return
        }
    
        let headerHeight = storagePanel.frame.height * CGFloat(Setting.storagePanelHeaderHeightInPercentage)
        let storagePanelHeaderFrame = CGRect(x: storagePanel.frame.origin.x,
                                             y: storagePanel.frame.origin.y,
                                             width: storagePanel.frame.width,
                                             height: headerHeight)
        let headerView = UIView(frame: storagePanelHeaderFrame)
        headerView.isOpaque = false
        headerView.alpha = CGFloat(Setting.storagePanelHeaderAlpha)
        headerView.backgroundColor = UIColor.black
        
        storagePanel.tableHeaderView = headerView
        
        // add button to enalbe creating new empty plist
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0,
                                                width: headerView.frame.width,
                                                height: headerView.frame.height))
        buttonView.backgroundColor = UIColor.clear
        buttonView.setTitle("new", for: .normal)
        buttonView.addGestureRecognizer(UITapGestureRecognizer( target: self,
            action: #selector(popOutCreatNewWindowByTapping(_:))))

        headerView.addSubview(buttonView)
    }
    
    /// - returns: the number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// - returns: the number of rows in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let storedBubbleGridURLs = storageManager.loadBubbleGridFileURLs() else {
            return 0
        }
        return storedBubbleGridURLs.count
    }
    
    /// - returns: the cell at the given indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Setting.storagePanelCellIdentifier,
                                                 for: indexPath) as! StoragePanelCell
        cell.awakeFromNib()
        return cell
    }
    
    /// load bublbe grid and its name when cell will be displayed
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let playGridCell = cell as? StoragePanelCell else {
            return
        }
        guard let playGridURLList = storageManager.loadBubbleGridFileURLs() else {
            return
        }
        let index = indexPath.row
        let key = Setting.bubbleGridStorageKey
        if index < playGridURLList.count {
            let url = playGridURLList[index]
            guard let loadedDic = storageManager.load(from: url) else {
                return
            }
            guard let loadedBubbleGrid = loadedDic[key] as? BubbleGrid else {
                return
            }
            playGridCell.setUpBubbleGrid(to: loadedBubbleGrid)
            playGridCell.setURL(to: url)
            playGridCell.setUpNameLabelText(to: getURLName(of: url))
        }
    }
    
    /// helper method to alert the specified title and message together with
    /// show a button "ok" to dismiss the alert
    private func alertMessage(title: String? = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// helper method to ask the user to confirm the operation or cancel it otherwise
    /// if the user confirm the operation, it will be run
    private func confirmAndHandle(title: String? = "", message: String, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "confirm", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "no", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// save the current bubbleGrid into a file (in .save mode) or
    /// load the bubbleGrid from a file (in .load mode)
    /// by tapping the file
    /// there will be alert window for the confirmation of the operation
    @objc private func saveOrLoadByTapping(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            guard let storedBubbleGridURLs = storageManager.loadBubbleGridFileURLs() else {
                return
            }
            guard let storagePanel = tableView else {
                return
            }
            guard let designController = (parent as? BBSagaDesignController) else {
                return
            }
            let currentPoint = recognizer.location(in: storagePanel)
            guard let indexPath = storagePanel.indexPathForRow(at: currentPoint) else {
                return
            }
            let mode = storageManager.getCurrentMode()
            let selectedURL = storedBubbleGridURLs[indexPath.row]
            let key = Setting.bubbleGridStorageKey
            switch mode {
            case .load:
                guard let loadedDic = storageManager.load(from: selectedURL) else {
                    alertMessage(message: noContentMessage)
                    return
                }
                if let loadedBubbleGrid = loadedDic[key] as? BubbleGrid {
                    let message = confirmLoadQuestion +
                                    getURLName(of: selectedURL) +
                                    loadOverwrittenWarning
                    let handler: ((UIAlertAction) -> Void) = { _ in
                        designController.setBubbleGrid(to: loadedBubbleGrid)
                    }
                    confirmAndHandle(message: message, handler: handler)
                }
            case .save:
                let message = confirmSaveQuestion + getURLName(of: selectedURL)
                let handler: ((UIAlertAction) -> Void) = { [weak self] _ in
                    guard let currentBubbleGrid = designController.getCurrentBubbleGrid() else {
                        return
                    }
                    let contentDic = [key: currentBubbleGrid]
                    self?.storageManager.save(contentDic: contentDic,
                                             into: selectedURL)
                    self?.alertMessage(title: "",
                                      message: "save into " + (self?.getURLName(of: selectedURL))! +
                                            "\nsuccessfully")
                    storagePanel.reloadRows(at: [indexPath], with: .automatic)
                }
                confirmAndHandle(title: "", message: message, handler: handler)
            }
        default:
            return
        }
    }
    
    /// long pressing a file in the storagePanel will delete this file from the storage
    private func removeGrid(at selectedURL: URL) {
        guard let storagePanel = tableView else {
            return
        }
        
        let message = confirmRemoveQuestion + getURLName(of: selectedURL)
        let handler: ((UIAlertAction) -> Void) = { [weak self] _ in
            self?.storageManager.removePlist(at: selectedURL)
            storagePanel.reloadData()
        }
        confirmAndHandle(message: message, handler: handler)
    }
    
    /// after tapping "create new" button on the header 
    /// show this alert window
    @objc private func popOutCreatNewWindowByTapping(_ recognizer: UITapGestureRecognizer) {
        guard let storagePanel = tableView else {
            return
        }
        
        let alert = UIAlertController(title: "", message: "create new empty grid", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = self.inputNamePlaceholder
        }
        
        alert.addAction(UIAlertAction(title: "create", style: .default, handler: { _ in
            if let name = alert.textFields?[0].text {
                self.storageManager.createEmptyBubbleGridPlistFile(ofName: name)
                storagePanel.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// this is a function to be called by its parentController to change the mode of storage manager
    func setMode(to mode: StorageManagerMode) {
        storageManager.setMode(to: mode)
    }
    
    /// helper function to get the name without path and extension of a URL
    private func getURLName(of url: URL) -> String {
        return url.lastPathComponent.components(separatedBy: ".")[0]
    }
}












//
//  BBSagaViewController.swift
//  LevelDesigner
//
//  Created by 罗宇阳 on 23/1/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import UIKit

let bubbleGridDesigner: BubbleGridDesigner = BubbleGridDesigner()

class BBSagaDesignController: UIViewController {
    @IBOutlet var toolBar: UIView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var loadBtn: UIButton!
    
    @IBOutlet var blueBubbleBtn: UIButton!
    @IBOutlet var greenBubbleBtn: UIButton!
    @IBOutlet var orangeBubbleBtn: UIButton!
    @IBOutlet var redBubbleBtn: UIButton!
    @IBOutlet var lightningBubbleBtn: UIButton!
    @IBOutlet var starBubbleBtn: UIButton!
    @IBOutlet var bombBubbleBtn: UIButton!
    @IBOutlet var indestructibleBubbleBtn: UIButton!
    
    @IBOutlet var eraseBtn: UIButton!
    
    private var modeButtons: [UIButton] {
        return [blueBubbleBtn,
                greenBubbleBtn,
                orangeBubbleBtn,
                redBubbleBtn,
                lightningBubbleBtn,
                starBubbleBtn,
                bombBubbleBtn,
                indestructibleBubbleBtn,
                eraseBtn]
    }
    private var currentHighlightedButton: UIButton?
    
    var loadedBubbleGrid: BubbleGrid!
    var bubbleGridView: UICollectionView!
    var storagePanel: UITableView!
    var bubbleGridForDesignController: BubbleGridForDesignController!
    var storagePanelController: StoragePanelController!

    /// set the text color of status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpBubbleGrid()
        setUpStoragePanel()
        moveButtonsOutOfView()
    }
    
    /// helper function to add background image into current view
    private func setUpBackground() {
        let background = UIImageView(image: UIImage(named: Setting.backGroundImageName))
        background.frame = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        view.insertSubview(background, at: 0)  // insert at the most back
    }
    
    /// helper function to set up bubble grid
    private func setUpBubbleGrid() {
        let bubbleGridFrame = CGRect(x: 0, y: 0, width: view.frame.width,
                                     height: view.frame.height - toolBar.frame.height)
        bubbleGridView = UICollectionView(frame: bubbleGridFrame,
                                      collectionViewLayout: BubbleGridCellFlowLayout())
        bubbleGridForDesignController = BubbleGridForDesignController(collectionViewLayout: bubbleGridView.collectionViewLayout)
        bubbleGridView.register(BubbleGridCell.self,
                            forCellWithReuseIdentifier: Setting.bubbleGridCellIdentifier)
        
        bubbleGridForDesignController.collectionView = bubbleGridView
        
        view.insertSubview(bubbleGridView, at: 1)
        self.addChildViewController(bubbleGridForDesignController)
        bubbleGridForDesignController.setUpEmptyBubbleGrid()
        if let loadedBubbleGrid = loadedBubbleGrid {
            bubbleGridForDesignController.setBubbleGrid(to: loadedBubbleGrid)
        }
    }
    
    /// helper function to set up storage panel
    private func setUpStoragePanel() {
        let width = view.frame.width * Setting.storagePanelWidthInPercentage
        let height = view.frame.height * Setting.storagePanelHeightInPercentage
        let storagePanelFrame = CGRect(x: (view.frame.width - width) / 2,
                                       y: view.frame.height * Setting.storagePanelYPercentage,
                                       width: width,
                                       height: height)
        storagePanel = UITableView(frame: storagePanelFrame)
        storagePanelController = StoragePanelController()
        storagePanel.register(StoragePanelCell.self,
                              forCellReuseIdentifier: Setting.storagePanelCellIdentifier)
        storagePanelController.tableView = storagePanel
        
        storagePanel.isHidden = true
        storagePanel.separatorStyle = .none
        storagePanel.alpha = Setting.storagePanelAlpha
        
        view.addSubview(storagePanel)
        self.addChildViewController(storagePanelController)
        storagePanelController.setUpStoragePanel()
    }
    
    // move mode buttons out of the screen first, when view did appear, slide them in
    func moveButtonsOutOfView() {
        for target in modeButtons {
            target.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        }
    }
    
    /// Animation: slides mode selection buttons in
    override func viewDidAppear(_ animated: Bool) {
        var index: Double = 0
        for button in modeButtons.reversed() {
            Animation.leftSlideIn(button, delay: index * 0.08 + 0.18)
            index += 1
        }
    }
    
    /// helper function to highlight the input button
    private func highlightButton(_ thisButton: UIButton) {
        thisButton.layer.cornerRadius = thisButton.frame.width / 2
        thisButton.layer.borderColor = UIColor.white.cgColor
        thisButton.layer.borderWidth = 2.8
        Animation.sinkAndFloat(thisButton)
    }
    
    /// helper function to un-highlight the input button
    private func unhighlightButton(_ thisButton: UIButton) {
        thisButton.layer.borderWidth = 0
    }
    
    /// helper function to highlight the button being tapped
    /// if there are other buttons highlighted, un-highlight them
    private func highlightOnlyThisModeButton(_ thisButton: UIButton) {
        // un-highlight all buttons
        for button in modeButtons {
            unhighlightButton(button)
        }
        // highlight the specified button
        highlightButton(thisButton)
    }
    
    /// Selecting a bubble colour from the palette by 
    /// tapping the correspondingly coloured bubble in the palette (Single-tap gesture)
    @IBAction func bubblePressed(_ sender: UIButton) {
        guard let buttonLabel = sender.currentTitle else {
            return
        }
        guard let designMode = designModeOf(buttonLabel: buttonLabel) else {
            return
        }
        if sender === currentHighlightedButton {
            bubbleGridDesigner.setDesignMode(to: .cycling)
            unhighlightButton(sender)
            currentHighlightedButton = nil
        } else {
            bubbleGridDesigner.setDesignMode(to: designMode)
            highlightOnlyThisModeButton(sender)
            currentHighlightedButton = sender
        }
    }
    
    /// helper method to map the bubble button 
    /// to the corresponding design mode it represents
    private func designModeOf(buttonLabel: String) -> DesignMode? {
        switch buttonLabel {
        case "blueBubble":
            return DesignMode.filling(ColorBubble(ofColor: .blue))
        case "greenBubble":
            return DesignMode.filling(ColorBubble(ofColor: .green))
        case "orangeBubble":
            return DesignMode.filling(ColorBubble(ofColor: .orange))
        case "redBubble":
            return DesignMode.filling(ColorBubble(ofColor: .red))
        case "lightningBubble":
            return DesignMode.filling(PowerBubble(ofPower: .lightning))
        case "bombBubble":
            return DesignMode.filling(PowerBubble(ofPower: .bomb))
        case "starBubble":
            return DesignMode.filling(PowerBubble(ofPower: .star))
        case "indestructibleBubble":
            return DesignMode.filling(PowerBubble(ofPower: .indestructible))
        default: return nil
        }
    }
    
    /// Tapping the erase button will enter the erasing mode,
    /// in which user can delete existing bubbles in the grid by panning gesture
    @IBAction func erasePressed(_ sender: UIButton) {
        if sender === currentHighlightedButton {
            bubbleGridDesigner.setDesignMode(to: .cycling)
            unhighlightButton(sender)
            currentHighlightedButton = nil
        } else {
            bubbleGridDesigner.setDesignMode(to: .erasing)
            highlightOnlyThisModeButton(sender)
            currentHighlightedButton = sender
        }
    }
    
    /// the RESET button will clear all the bubbles from the grid
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        bubbleGridForDesignController.cleanAllCells()
    }
    
    /// after tapping Save button or Load buttn
    /// 1. change the mode of storage manager to .save and .load accordingly
    /// 2. display the storagePanel accordingly
    /// 3. change the color of Save and Load button to denote the current mode
    /// of the storage manager accordingly
    @IBAction func saveOrLoadButtonPressed(_ sender: UIButton) {
        let loadBtnColor = loadBtn.titleColor(for: UIControlState.normal)
        let saveBtnColor = saveBtn.titleColor(for: UIControlState.normal)
        let onColor = UIColor.white
        let offColor = UIColor.black
        var openStoragePanel = false

        if sender === saveBtn {
            storagePanelController.setMode(to: .save)
            if saveBtnColor == offColor {
                saveBtn.setTitleColor(onColor, for: UIControlState.normal)
                loadBtn.setTitleColor(offColor, for: UIControlState.normal)
                openStoragePanel = true
            } else {
                saveBtn.setTitleColor(offColor, for: UIControlState.normal)
                openStoragePanel = false
            }
        } else {
            storagePanelController.setMode(to: .load)
            if loadBtnColor == offColor {
                loadBtn.setTitleColor(onColor, for: UIControlState.normal)
                saveBtn.setTitleColor(offColor, for: UIControlState.normal)
                openStoragePanel = true
            } else {
                loadBtn.setTitleColor(offColor, for: UIControlState.normal)
                openStoragePanel = false
            }
        }
        
        if openStoragePanel {
            storagePanel.isHidden = false
            Animation.animateTableSlidingUpCells(storagePanel)
        } else {
            storagePanel.isHidden = true
        }
    }
    
    /// set the bubble grid to the given one
    /// and redraw the view of bubble grid
    func setBubbleGrid(to bubbleGrid: BubbleGrid) {
        if let bubbleGridForDesignController = bubbleGridForDesignController {
            bubbleGridForDesignController.setBubbleGrid(to: bubbleGrid)
        }
    }

    /// - returns: the current bubble grid, or nil if it does no exist
    func getCurrentBubbleGrid() -> BubbleGrid? {
        guard let bubbleGridForDesignController = bubbleGridForDesignController else {
            return nil
        }
        return bubbleGridForDesignController.currentBubbleGrid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playController = segue.destination as? GamePlayController {
            playController.loadedBubbleGrid = getCurrentBubbleGrid()?.replica()
            playController.backSegueIdentifier = Setting.unwindSegueToDeignerIdentifier
        }
    }
    
    @IBAction func unwindSegueToDesignerScene(segue: UIStoryboardSegue) {}
}













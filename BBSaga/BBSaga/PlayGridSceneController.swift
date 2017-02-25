//
//  PlayGridSceneController.swift
//  BBSaga
//
//  Created by luoyuyang on 20/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class PlayGridSceneController: UIViewController {
    private var playGridCollectionView: UICollectionView!
    private var playGridCollectionViewController: PlayGridCollectionController!
    @IBOutlet var bar: UIView!
    
    override func viewDidLoad() {
        setUpBackground()
        setUpGridsViewAndController()
        startObservingSegueToPlayerRequest()
    }
    
    private func setUpBackground() {
        let background = UIImageView(image: Setting.backgroundImage)
        background.alpha = Setting.selectionSceneBackgroundAlpha
        background.frame = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        view.insertSubview(background, at: 0)  // insert at the most back
    }
    
    private func startObservingSegueToPlayerRequest() {
        let name = NSNotification.Name(rawValue: Setting.segueToPlayerNotificationName)
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: { [weak self] notification in
            if let senderBubbleGridController = notification.object as? BubbleGridController {
                self?.performSegue(withIdentifier: Setting.segueToPlayerIdentifier, sender: senderBubbleGridController)
            }
        })
    }
    
    private func setUpGridsViewAndController() {
        let layout = getGridCollectionLayout()
        playGridCollectionViewController = PlayGridCollectionController(collectionViewLayout: layout)
        self.addChildViewController(playGridCollectionViewController)
        
        guard let playGridCollectionViewControllerCollectionView = playGridCollectionViewController.collectionView else {
            return
        }
        playGridCollectionView = playGridCollectionViewControllerCollectionView
        playGridCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - bar.frame.height)
        playGridCollectionView.register(PlayGridCell.self, forCellWithReuseIdentifier: Setting.playGridCellIdentifier)
        view.addSubview(playGridCollectionView)
    }
    
    private func getGridCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let ratio = Setting.gridCollectionItemSizeRatio
        layout.itemSize = CGSize(width: view.frame.size.width * ratio, height: view.frame.size.height * ratio)
        
        let verticalMargin = view.frame.size.height * Setting.gridCollectionVerticalMarginRatio
        let horizontalMargin = view.frame.size.width * Setting.gridCollectionHorizontalMarginRatio
        layout.sectionInset = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        
        return layout
    }
    
    /// Animation: grids fall into view
    override func viewDidAppear(_ animated: Bool) {
        Animation.animateCollectionFallingCells(playGridCollectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Setting.segueToPlayerIdentifier {
            guard let senderBubbleGridController = sender as? BubbleGridController else {
                return
            }
            if let playController = segue.destination as? GamePlayController {
                playController.loadedBubbleGrid = senderBubbleGridController.currentBubbleGrid.replica()
                playController.backSegueIdentifier = Setting.unwindSegueToSelectorIdentifier
            }
        }
    }
    
    @IBAction func unwindSegueToSelectionScene(segue: UIStoryboardSegue) {}
}







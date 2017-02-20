//
//  DesignGridSceneController.swift
//  LevelDesigner
//
//  Created by luoyuyang on 19/02/17.
//  Copyright © 2017年 nus.cs3217.a0147980u. All rights reserved.
//

import Foundation
import UIKit

class DesignGridSceneController: UIViewController {
    private var designGridCollectionView: UICollectionView!
    private var designGridCollectionViewController: DesignGridCollectionController!
    
    override func viewDidLoad() {
        setUpGridsViewAndController()
        startObservingSegueToDesignerRequest()
    }
    
    private func startObservingSegueToDesignerRequest() {
        let name = NSNotification.Name(rawValue: Setting.segueToDesignerNotificationName)
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: { notification in
            if let senderBubbleGridController = notification.object as? BubbleGridController {
                self.performSegue(withIdentifier: Setting.segueToDesignerIdentifier, sender: senderBubbleGridController)
            }
        })
    }
    
    private func setUpGridsViewAndController() {
        let layout = getGridCollectionLayout()
        designGridCollectionViewController = DesignGridCollectionController(collectionViewLayout: layout)
        self.addChildViewController(designGridCollectionViewController)
    
        guard let designGridCollectionViewControllerCollectionView = designGridCollectionViewController.collectionView else {
        return
        }
        designGridCollectionView = designGridCollectionViewControllerCollectionView
        designGridCollectionView.frame = view.frame
        designGridCollectionView.register(DesignGridCell.self, forCellWithReuseIdentifier: Setting.designGridCellIdentifier)
        view.addSubview(designGridCollectionView)
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
        Animation.animateCollectionFallingCells(designGridCollectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Setting.segueToDesignerIdentifier {
            guard let senderBubbleGridController = sender as? BubbleGridController else {
                return
            }
            if let designController = segue.destination as? BBSagaDesignController {
                designController.loadedBubbleGrid = senderBubbleGridController.currentBubbleGrid
            }
        }
    }
}

//
//  GamePlayController.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import UIKit
import PhysicsEngine

class GamePlayController: UIViewController {
    private(set) var bubbleGridView: UICollectionView!
    private(set) var bubbleGridController: BubbleGridForPlayController!
    var backSegueIdentifier = Setting.unwindSegueToSelectorIdentifier  // default
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var leftProjectileCountLabel: UILabel!
    var leftProjectileCount = 0
    @IBOutlet var scoreLabel: UILabel!
    var scoreThisShot = 0
    
    var aimingBeam: [UIView] = []
    
    let gameEngine = GameEngine(framePerSecond: Setting.framePerSecond)
    private(set) lazy var renderer: Renderer = { return self.gameEngine.renderer }()
    private(set) lazy var world: World = { return self.gameEngine.world }()
    
    var loadedBubbleGrid: BubbleGrid?
    private(set) var bubbleRadius: CGFloat = 0
    let bubbleProjectileSpeed = Setting.bubbleProjectileSpeed
    private(set) var bubbleShooterPosition = CGVector()
    private(set) var pendingBubble = ColorBubble()
    private(set) var pendingBubbleView = UIImageView()
    private(set) var nextBubble = ColorBubble()
    @IBOutlet var nextBubbleView: UIImageView!
    
    var positionsOfGridBubbles: [CGVector] = []
    
    var cannonView = UIImageView()
    var cannonBaseView = UIImageView()
    
    //Ending Scene
    @IBOutlet var endingView: UIView!
    @IBOutlet var finalScoreLabel: UILabel!
    @IBOutlet var endingViewBackBtn: UIButton!

    /// set the text color of status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpBubbleGrid()
        setUpBubbleShooter()
        setUpLightningObstacles()
        leftProjectileCountLabel.text = String(Setting.numProjectiles)
        leftProjectileCount = Setting.numProjectiles
        scoreLabel.text = String(0)
        endingView?.isHidden = true
        
        bindGestureRecognizer(to: view)
        addEventDetectors()
        world.addCollisionDetector(CollisionDetector())
        backBtn.addTarget(self, action: #selector(performBackSegue(_:)), for: .touchUpInside)
    }
    
    @objc private func performBackSegue(_ sender: UIButton) {
        performSegue(withIdentifier: backSegueIdentifier, sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameEngine.startGameLoop()
    }
    
    /// helper function to add background image into current view
    private func setUpBackground() {
        let background = UIImageView(image: Setting.playBackgroundImage)
        background.alpha = Setting.playBackgroundAlpha
        background.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        background.contentMode = .scaleAspectFill
        view.insertSubview(background, at: 0)  // insert at the most back
    }
    
    /// helper function to set up bubble grid
    private func setUpBubbleGrid() {
        let bubbleGridFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.8)
        bubbleGridView = UICollectionView(frame: bubbleGridFrame,
                                          collectionViewLayout: BubbleGridCellFlowLayout())
        bubbleGridController = BubbleGridForPlayController(collectionViewLayout: bubbleGridView.collectionViewLayout)
        bubbleGridView.register(BubbleGridCell.self,
                                forCellWithReuseIdentifier: Setting.bubbleGridCellIdentifier)
        
        bubbleGridController.collectionView = bubbleGridView
        
        view.insertSubview(bubbleGridView, at: 1)
        addChildViewController(bubbleGridController)
        
        bubbleGridController.setUpEmptyBubbleGrid()
        if let loadedBubbleGrid = loadedBubbleGrid {
            setUpLoadedBubbleGridModel(loadedBubbleGrid)
        }
    }
    
    /// helper function to set the bubbleGrid to the loadedBubbleGrid
    private func setUpLoadedBubbleGridModel(_ loadedBubbleGrid: BubbleGrid) {
        bubbleGridController.setBubbleGrid(to: loadedBubbleGrid)
        for row in 0 ..< loadedBubbleGrid.getNumRows() {
            for col in 0 ..< loadedBubbleGrid.getNumCellsAt(row: row) {
                if !loadedBubbleGrid.isCellEmptyAt(row: row, col: col) {
                    guard let point = getCell(at: IndexPath(row: col, section: row))?.center else {
                        return
                    }
                    let position = CGVector(point)
                    positionsOfGridBubbles.append(position)
                }
            }
        }
    }
    
    /// helper function to set up bubble shooter
    private func setUpBubbleShooter() {
        bubbleRadius = view.bounds.width / (2 * CGFloat(Setting.numCellsPerOddRow))
        bubbleShooterPosition = CGVector(dx: view.frame.width / 2, dy: view.frame.height - 1.2 * bubbleRadius)
        
        pendingBubble.setColor(nextColor())
        pendingBubbleView.image = Setting.imageOfBubble(pendingBubble)
        pendingBubbleView.frame.size = CGSize(width:  bubbleRadius, height: bubbleRadius)
        pendingBubbleView.center = bubbleShooterPosition.toCGPoint()
        view.addSubview(pendingBubbleView)
        
        nextBubble.setColor(nextColor())
        nextBubbleView.image = Setting.imageOfBubble(nextBubble)
        
        cannonView = UIImageView(frame: CGRect(x: view.bounds.width / 2 - Setting.cannonWidth / 2,
                                               y: view.bounds.height - Setting.cannonY,
                                               width: Setting.cannonWidth,
                                               height: Setting.cannonHeight))
        cannonView.image = Animation.cutSequenceImageIntoImages(named: Setting.cannonSpriteSheetName, numRows: Setting.cannonSpriteSheetNumRow, numCols: Setting.cannonSpriteSheetNumCol)[0]
        view.addSubview(cannonView)
        cannonBaseView = UIImageView(frame: CGRect(x: view.bounds.width / 2 - Setting.cannonBaseWidth / 2,
                                                   y: view.bounds.height - Setting.cannonBaseWidth,
                                                   width: Setting.cannonBaseWidth,
                                                   height: Setting.cannonBaseWidth))
        cannonBaseView.image = UIImage(named: Setting.cannonBaseSpriteSheetName)
        view.addSubview(cannonBaseView)
        
        let shiftY = cannonView.bounds.height * Setting.cannonAnchorRate
        cannonView.transform = CGAffineTransform(translationX: 0, y: shiftY)
        cannonView.layer.anchorPoint = Setting.cannonAnchorPoint
        cannonView.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let designController = segue.destination as? BBSagaDesignController {
            designController.moveButtonsOutOfView()
        }
    }
    
    func endGame() {
        gameEngine.terminateGameLoop()
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer)
            }
        }
        endingView?.layer.cornerRadius = endingView.bounds.width * Setting.cellCornerRadiusWidthRate
        endingView?.isHidden = false
        endingView.removeFromSuperview()
        view.addSubview(endingView)  // add to the top
        endingViewBackBtn?.addTarget(self, action: #selector(performBackSegue(_:)), for: .touchUpInside)

        guard let currentNumString = scoreLabel.text else {
            return
        }
        guard let currentNum = Int(currentNumString) else {
            return
        }
        for i in stride(from: 0, through: currentNum, by: Setting.scorePerBubble) {
            let stepDelay = Setting.endingSceneScoreIncreasingAnimationStepDelay
            delay(Double(i) / Double(Setting.scorePerBubble) * stepDelay) { [weak self] _ in
                self?.finalScoreLabel.text = String(i)
            }
        }
    }
    
    deinit {
        gameEngine.terminateGameLoop()
    }
}







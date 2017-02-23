//
//  GamePlayController.swift
//  BBSGameEngine
//
//  Created by 罗宇阳 on 4/2/17.
//  Copyright © 2017 nus.cs3217.a0147980u. All rights reserved.
//

import UIKit

class GamePlayController: UIViewController {
    private var bubbleGridView: UICollectionView!
    private var bubbleGridController: BubbleGridForPlayController!
    
    @IBOutlet var leftProjectileCountLabel: UILabel!
    
    private var aimingBeam: [UIView] = []
    
    private let gameEngine = GameEngine(framePerSecond: Setting.framePerSecond)
    private lazy var renderer: Renderer = { return self.gameEngine.renderer }()
    private lazy var world: World = { return self.gameEngine.world }()
    
    var loadedBubbleGrid: BubbleGrid?
    private var bubbleRadius: CGFloat = 0
    private let bubbleProjectileSpeed = Setting.bubbleProjectileSpeed
    private var bubbleShooterPosition = CGVector()
    private var pendingBubble = ColorBubble(ofColor: .blue)
    private var pendingBubbleView = UIImageView()
    
    private var positionsOfGridBubbles: [CGVector] = []
    
    /// set the text color of status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpBubbleGrid()
        setUpBubbleShooter()
        leftProjectileCountLabel.text = String(Setting.numProjectiles)
        
        bindGestureRecognizer(to: view)
        addEventDetectors()
        world.addCollisionDetector(CollisionDetector())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameEngine.startGameLoop()
    }

    /// helper function to add background image into current view
    private func setUpBackground() {
        let background = UIImageView(image: UIImage(named: "background.png"))
        background.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
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
        bubbleShooterPosition = CGVector(dx: view.frame.width / 2, dy: view.frame.height - 2 * bubbleRadius)
        
        if let color = BubbleColor(rawValue: Int.randomWithinRange(lower: 0, upper: 3)) {
            pendingBubble.setColor(color)
        }
        pendingBubbleView.image = Setting.imageOfBubble(pendingBubble)
        pendingBubbleView.frame.size = CGSize(width: 2 * bubbleRadius, height: 2 * bubbleRadius)
        pendingBubbleView.center = bubbleShooterPosition.toCGPoint()
        view.addSubview(pendingBubbleView)
    }

    /// helper function to bind gesture recognizers
    private func bindGestureRecognizer(to view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(shootByTapping(_:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(shootByPanning(_:))))
    }
    
    /// when players tap at the screen
    /// shoot a bubble projectile toward that direction
    @objc private func shootByTapping(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: view)
        calculateVelocityAndShootTo(point: point)
    }
    
    /// when players panning, show a bean to indicate the predicted trajectory
    /// when players lift off their fingers, shoot the ball toward that direction
    @objc private func shootByPanning(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            updateAimingBeam(point: recognizer.location(in: view))
        case .ended:
            calculateVelocityAndShootTo(point: recognizer.location(in: view))
            removeAimingBeam()
        default:
            break
        }
    }
    
    private func removeAimingBeam() {
        for view in aimingBeam {
            view.removeFromSuperview()
        }
        aimingBeam = []
    }
    
    private func updateAimingBeam(point: CGPoint) {
        removeAimingBeam()
        
        // draw new aiming beam
        var currentPosition = bubbleShooterPosition
        var v = CGVector(point) - bubbleShooterPosition
        v = Setting.aimingBeamStepLength * (v / v.norm())  // length for each step
        var hasCollideWithGridBubble = false
        for _ in 0 ... Setting.aimingBeamStepNum {  // number of steps
            if hasCollideWithGridBubble {
                break
            }
            currentPosition = currentPosition + v
            
            var frame = CGRect()
            frame.size = Setting.pathNodeSize
            let pathNode = UIImageView(frame: frame)
            pathNode.center = currentPosition.toCGPoint()
            pathNode.image = Setting.pathNodeImage
            aimingBeam.append(pathNode)
            view.addSubview(pathNode)
            
            // collide with side wall
            if currentPosition.dx <= bubbleRadius || currentPosition.dx + bubbleRadius >= view.bounds.width {
                v.dx = -v.dx
            }
            // collide with grid bubbles
            for position in positionsOfGridBubbles {
                if currentPosition.distance(to: position) <= 2 * bubbleRadius {
                    let headNode = aimingBeam.removeLast()
                    headNode.removeFromSuperview()
                    hasCollideWithGridBubble = true
                    break
                }
            }
        }
    }
    
    /// calculate the velocity of the bubble projectile
    /// based on the position players tap or finish panning
    /// then, shoot the ball
    private func calculateVelocityAndShootTo(point: CGPoint) {
        let v = CGVector(point) - bubbleShooterPosition
        let velocity = bubbleProjectileSpeed * (v / v.norm())
        if velocity.dy < Setting.minimumShootingVerticalComponent {
            shoot(bubble: Bubble(), velocity: velocity)
        }
    }
    
    /// shoot the bubble. this is done by:
    /// create a view to represent the projectile ball on the screen and attach it to view as a subview
    /// create a body to represent the projectile ball in the world (physical engine)
    /// add this pair to the renderer
    private func shoot(bubble: Bubble, velocity: CGVector) {
        guard let color = BubbleColor(rawValue: Int.randomWithinRange(lower: 0, upper: 3)) else {
            return
        }
        
        // create projectile bubble body
        let bubbleProjectile = BubbleProjectile(of: pendingBubble.replica(),
                                                radius: bubbleRadius)
        bubbleProjectile.position = bubbleShooterPosition
        bubbleProjectile.velocity = velocity
        
        // add the projectile as a target of eventDetectors
        for eventDetector in world.eventDetectors {
            eventDetector.addTarget(bubbleProjectile)
        }
        
        // add the projectile as a target of collisionDetectors
        for collisionDetector in world.collisionDetectors {
            collisionDetector.addTarget(bubbleProjectile)
        }
        
        // create uiview and add it as subview to view
        let bubbleProjectileView = UIImageView(frame: CGRect(x: bubbleShooterPosition.dx - bubbleRadius,
                                                             y: bubbleShooterPosition.dy - bubbleRadius,
                                                             width: 2 * bubbleRadius,
                                                             height: 2 * bubbleRadius))
        bubbleProjectileView.image = Setting.imageOfBubble(bubbleProjectile.getBubble())
        view.addSubview(bubbleProjectileView)
        
        // register projectile bubble into the world physical engine
        world.addBody(bubbleProjectile)
        // register projectile bubble body and uiview to renderer
        renderer.register(body: bubbleProjectile, view: bubbleProjectileView)
        
        // update current chooted bubble
        pendingBubble.setColor(color)
        pendingBubbleView.image = Setting.imageOfBubble(pendingBubble)
        
        countDownProjectilesLeft()
    }
    
    private func countDownProjectilesLeft() {
        guard let currentNumString = leftProjectileCountLabel.text else {
            return
        }
        guard let currentNum = Int(currentNumString) else {
            return
        }
        leftProjectileCountLabel.text = String(currentNum - 1)
    }
    
    /// add event-detectors to the world
    /// these events will be checked everty time the world update
    private func addEventDetectors() {
        world.addEventDetector(createVerticalBorderCollisionEventDetector())
        world.addEventDetector(createUpperBorderCollisionEventDetector())
        world.addEventDetector(createGridBubbleCollisionEventDetector())
        world.addEventDetector(createBottomBorderCollisionEventDetector())
    }
    
    /// check the collision between the projectile bubble and the left/right wall
    /// if collide, reverse the x-component of the velocity
    private func createVerticalBorderCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            return (target.position.dx <= weakSelf.bubbleRadius && target.velocity.dx < 0) ||  // left side wall
                (target.position.dx + weakSelf.bubbleRadius >= weakSelf.view.bounds.width && target.velocity.dx > 0)
        }
        let callback = { (target: RigidBody) in
            return target.velocity.dx = -target.velocity.dx
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// check the collision between the projectile bubble and the uppper wall
    /// if collide, find the closest empty cell and settle there
    /// then check whether there are 3 or more connected bubbles to be removed
    private func createUpperBorderCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            return target.position.dy <= weakSelf.bubbleRadius + CGFloat(Setting.statusBarHeight)
        }
        let callback = { [weak self] (target: RigidBody) in
            if let weakSelf = self {
                weakSelf.settleBubbleProjectileAndCheck(target)
            }
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// check the collision between the projectile bubble and the bottom wall
    /// if collide, remove this projectile from game
    /// that is, this projectile will be removed from physics engine and renderer
    /// and its corresponding view will be removed from its superview
    private func createBottomBorderCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            return target.position.dy >= weakSelf.view.bounds.height
        }
        let callback = { [weak self] (target: RigidBody) in
            if let weakSelf = self {
                weakSelf.gameEngine.removeRigidBody(target)
            }
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// check the collision between the projectil bubble with the bubble in the grid
    /// if collide, find the closest empty cell and settle there
    /// then check whether there are 3 or more connected bubbles to be removed
    private func createGridBubbleCollisionEventDetector() -> EventDetector {
        let detectEvent = { [weak self] (target: RigidBody) -> Bool in
            guard let weakSelf = self else {
                return false
            }
            for position in weakSelf.positionsOfGridBubbles {
                if target.position.distance(to: position) <= 2 * weakSelf.bubbleRadius {
                    return true
                }
            }
            return false
        }
        let callback = { [weak self] (target: RigidBody) in
            if let weakSelf = self {
                weakSelf.settleBubbleProjectileAndCheck(target)
            }
        }
        return EventDetector(detectEvent: detectEvent, callback: callback)
    }
    
    /// find the closest empty cell and settle there
    /// then check whether there are 3 or more connected bubbles to be removed
    private func settleBubbleProjectileAndCheck(_ bubbleProjectile: RigidBody) {
        guard let bubbleProjectile = bubbleProjectile as? BubbleProjectile else {
            return
        }
        gameEngine.removeRigidBody(bubbleProjectile)
        
        for position in positionsToConsiderWhenPrepareSettling(around: bubbleProjectile.position) {
            guard let indexPath = bubbleGridView.indexPathForItem(at: position.toCGPoint()) else {
                return
            }
            
            if bubbleGridController.currentBubbleGrid.isCellEmptyAt(row: indexPath.section,
                                                                         col: indexPath.row) {
                // settle into bubbleGrid
                bubbleGridController.currentBubbleGrid.setBubbleAt(row: indexPath.section,
                                                                        col: indexPath.row,
                                                                        to: bubbleProjectile.getBubble())
                bubbleGridView.reloadItems(at: [indexPath])
                if let point = getCell(at: indexPath)?.center {
                    let position = CGVector(point)
                    positionsOfGridBubbles.append(position)
                }
                
                // remove grid bubbles according to the rules
                removeAfterShootTo(indexPath)
                break
            }
        }
        if leftProjectileCountLabel.text == "0" {
            endGame()
        }
    }
    
    /// helper function that returns the current position
    /// and its 6 "neighbor" positions (vertices of the inscribed hexagon of the buble)
    private func positionsToConsiderWhenPrepareSettling(around position: CGVector) -> [CGVector] {
        return [
            position,
            position + CGVector(dx: bubbleRadius, dy: 0),
            position + CGVector(dx: bubbleRadius / 2, dy: sqrt(3) / 2 * bubbleRadius),
            position + CGVector(dx: -bubbleRadius / 2, dy: sqrt(3) / 2 * bubbleRadius),
            position + CGVector(dx: -bubbleRadius, dy: 0),
            position + CGVector(dx: -bubbleRadius / 2, dy: -sqrt(3) / 2 * bubbleRadius),
            position + CGVector(dx: bubbleRadius / 2, dy: -sqrt(3) / 2 * bubbleRadius)
        ]
    }
    
    /// after the bubble projectile settle at the specified indexPath
    /// remove more than 3 connected same-colored bubbles and
    /// then remove unattached bubbles
    /// - Parameter indexPath: the indexPath where the bubble projectile settle
    private func removeAfterShootTo(_ indexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        
        // remove more than 3 connected same-colored bubbles
        let connectedIndexPathsOfSameColor = bubbleGrid.connectedIndexPathsOfSameColor(from: indexPath)
        if connectedIndexPathsOfSameColor.count >= 3 {
            removeFromPositionsOfGridBubbles(indexPaths: connectedIndexPathsOfSameColor)
            bubbleGridController.removeConnectedSameColorBubblesWithAnimation(connectedIndexPathsOfSameColor)
        }
        
        // trigger lightning bubble
        for indexPath in getPowerBubbleIndexPaths(around: indexPath, ofPower: .lightning) {
            triggerLightningBubbleAt(indexPath)
        }
        
        // trigger bomb bubble
        for indexPath in getPowerBubbleIndexPaths(around: indexPath, ofPower: .bomb) {
            triggerBombBubbleAt(indexPath)
        }
        
        // trigger star bubble
        for starBubbleIndexPath in getPowerBubbleIndexPaths(around: indexPath, ofPower: .star) {
            triggerStarBubbleAt(starBubbleIndexPath, by: indexPath)
        }
        
        // remove unattached bubbles
        let unattachedIndexPaths = bubbleGrid.unattachedIndexPaths()
        removeFromPositionsOfGridBubbles(indexPaths: unattachedIndexPaths)
        bubbleGridController.removeUnattachedBubblesWithAnimation(unattachedIndexPaths)
    }
    
    /// return the index paths of the power bubble adjacent to the input index path
    private func getPowerBubbleIndexPaths(around indexPath: IndexPath, ofPower power: BubblePower) -> [IndexPath] {
        var returnedIndexPaths: [IndexPath] = []
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        for indexPath in bubbleGrid.adjacentUnemptyIndexPaths(to: indexPath) {
            let row = indexPath.section
            let col = indexPath.row
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: power) {
                returnedIndexPaths.append(indexPath)
            }
        }
        return returnedIndexPaths
    }
    
    /// helper function to trigger lightning bubble at the input index path
    private func triggerLightningBubbleAt(_ indexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        let indexPathsRemovedByLightningBubble = bubbleGrid.indexPathsRemovedByLightningBubble(at: indexPath)
        
        // get the index paths of chaining power bubbles
        var chainingLightningIndexPaths: [IndexPath] = []
        var chainingBombIndexPaths: [IndexPath] = []
        for indexPath in indexPathsRemovedByLightningBubble {
            let row = indexPath.section
            let col = indexPath.row
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .lightning) {
                chainingLightningIndexPaths.append(indexPath)
            }
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .bomb) {
                chainingBombIndexPaths.append(indexPath)
            }
        }
        
        // trigger current power bubbles
        removeFromPositionsOfGridBubbles(indexPaths: indexPathsRemovedByLightningBubble)
        bubbleGridController.removeLightningDestroyedBubblesWithAnimation(indexPathsRemovedByLightningBubble)
        
        // trigger chaining power bubbles
        delay(Setting.chainingDelay) {
            for indexPath in chainingLightningIndexPaths {
                self.triggerLightningBubbleAt(indexPath)
            }
            for indexPath in chainingBombIndexPaths {
                self.triggerBombBubbleAt(indexPath)
            }
        }
    }
    
    /// helper function to trigger bomb bubble at the input index path
    private func triggerBombBubbleAt(_ indexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        var indexPathsRemovedByBombBubble = bubbleGrid.adjacentUnemptyIndexPaths(to: indexPath)
        indexPathsRemovedByBombBubble.append(indexPath)
        
        // get the index paths of chaining power bubbles
        var chainingLightningIndexPaths: [IndexPath] = []
        var chainingBombIndexPaths: [IndexPath] = []
        for indexPath in indexPathsRemovedByBombBubble {
            let row = indexPath.section
            let col = indexPath.row
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .lightning) {
                chainingLightningIndexPaths.append(indexPath)
            }
            if bubbleGrid.getBubbleAt(row: row, col: col) == PowerBubble(ofPower: .bomb) {
                chainingBombIndexPaths.append(indexPath)
            }
        }
        
        // trigger current power bubbles
        removeFromPositionsOfGridBubbles(indexPaths: indexPathsRemovedByBombBubble)
        bubbleGridController.removeBombDestroyedBubblesWithAnimation(indexPathsRemovedByBombBubble)
        
        // trigger chaining power bubbles
        delay(Setting.chainingDelay) {
            for indexPath in chainingLightningIndexPaths {
                self.triggerLightningBubbleAt(indexPath)
            }
            for indexPath in chainingBombIndexPaths {
                self.triggerBombBubbleAt(indexPath)
            }
        }
    }
    
    /// helper function to trigger bomb bubble at the input index path
    private func triggerStarBubbleAt(_ starBubbleIndexPath: IndexPath, by projectileIndexPath: IndexPath) {
        let bubbleGrid = bubbleGridController.currentBubbleGrid
        var indexPathsRemovedByStarBubble = bubbleGrid.indexPathsOfSameColor(as: projectileIndexPath)
        indexPathsRemovedByStarBubble.append(starBubbleIndexPath)
        removeFromPositionsOfGridBubbles(indexPaths: indexPathsRemovedByStarBubble)
        bubbleGridController.removeStarDestroyedBubblesWithAnimation(indexPathsRemovedByStarBubble)
    }
    
    /// helper function to remove center of grid bubbles from positionsOfGridBubbles
    /// - Parameter indexPaths: the index paths of the grid bubbles removed
    private func removeFromPositionsOfGridBubbles(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let position = getCell(at: indexPath)?.center {
                positionsOfGridBubbles.removeEqualItems(item: CGVector(position))
            }
        }
    }
    
    /// helper function to get the cell at the specified indexPath
    private func getCell(at indexPath: IndexPath) -> BubbleGridCell? {
        if let cell = bubbleGridView?.dequeueReusableCell(
            withReuseIdentifier: Setting.bubbleGridCellIdentifier,for: indexPath) as? BubbleGridCell {
            return cell
        }
        return nil
    }
    
    private func endGame() {
        gameEngine.terminateGameLoop()
    }
    
    deinit {
        gameEngine.terminateGameLoop()
    }
}







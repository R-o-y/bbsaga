CS3217 Problem Set 5
==

[**Project Page**](https://r-o-y.github.io/bbsaga/)

**Name:** Luo Yuyang

**Matric No:** A0147980U

**Tutor:** Zheng Yi Tham

### Notes of the glossary:
> - in the following description, "level", "grid", "bubble grid" most likely refer to the same thing
> - my gameplay logic are in "GamePlayeController". GameEngine takes charge of the general game loop

### Rules of Your Game
> - the game start with the menu scene, there are 3 buttons, play button goes to the level selection scene, design button goes to the level design scene, setting button toggle displaying the setting panel. 
> In the setting panel, there is a toggle button (switch button), which enables players to decide whether to play the background music
> - the level selection scene displays all the preloaded levels as well as the levels designed by players.   
> It displays these levels in a table form with 2 columns, 
>   - tapping the level will proceed to the game play scene, 
>   - tapping the back button will go back to the menu scene
> - the design scene enable players to design custom grids.      
> **Note:** for the saving and loading of the bubble grid, players need to create a new empty level with the specified name, then save the grid into that empty level. These design is not natural but enables operation like copy-paste-move and provide more flexibility. In the future, when flexible operations like copy-and-paste are formally supported, I will replace this design with the natural one.
> - the game play scene is the scene where the user could play a certain level, this scene could be switched to from both design scene and level selection scene. 
> currently, the game will terminate when the limited number of bubbles are run out, and the final score will be added up and shown to players. There is no win-lose judgement currently
> players could also manually exit the game by "back" button.
> the details of gameplay rules such as "special power bubble" and "lightning obstacles" could be found in the expectation description of the test.

> In the future, game mechanism such as terminating the game when run out of time, or when all the bubbles on the grid are removed will be considered implementing. In that case, wining or losing judgement will be added. 


### Problem 1: Cannon Direction

> players can select the direction of cannon (also the direction of shooting bubble projectiles) using 2 gestures
> 1. tap gesture
> after the player tap at a position on the screen, the cannon will rotate towards that position, and the bubble projectile will shoot toward that positions 
> 2. pan gesture
> when the player place a finger on the screen and move a very short distance (if the player put the finger on the screen without moving it, it will not be considered as a pan gesture), the cannon will start tracking the position of the finger, that is, whenever the player move the finger, the cannon will rotate towards that position. Also an aiming beam will be shown and track the position of the finger, similar to the cannon.           
> when the player lift off the finger from the screen, the bubble projectile will be shot towards the position where the finger is lifted off (the same direction as the aiming beam and the cannon point to).
 
### Problem 2: Upcoming Bubbles

> the rule for the coming bubble: I only how 2 bubbles, one is the one that is pending to be shot by the player, the other is the next one. For the first 2 bubbles of the game, both colors will be generated according to the rule specified below, after that, every time the player shoot a bubble, the color of the pending bubble will be replaced by the next bubble, the color of the next bubble will be generated according to the rule specified below:
>          
> **rule**: there is a possibility that is set in the Setting.swift called "colorInGridPossibility". Every time the engine need to decide for the next bubble color, it will first find all the existing colors in the bubbleGrid. Then there are 2 cases that might happen:
> - case 1: the next bubble color is one of the existing colors in the bubbleGrid, if there is no existing color, then one of the all possible colors  (both uniform distribution)
> - case 2: the next bubble color is one of the colors that is not in the bubbleGrid, if all colors are in the bubbleGrid, then one of the all possible colors (both uniform distribution)           
>              
> the possibility of the first case happening is specified by "colorInGridPossibility" mentioned above
>        
> **justify**: if random color only from the existing color, then the game is easy, especially close to the end of the game; if random color from all possible colors, then close to the end of the game, finishing the game will be unreasonably long (for instance, you only have 1 colors left, but the new projectile might introduce a new color). Therefore, I set a parameter "colorInGridPossibility" to adjust, currently, it is set to 0.8, means close to the end of the game, there is still 20% possibility for the projectile to introduce a new color, which will make the ending of the game properly hard. Besides, in the future dev of this game, this parameter could be exposed to the players and players (also grid designer) can use this parameter to adjust the difficulty of the game


### Problem 3: Integration

> - **how my design support integrating the game engine:** the main objects dealt with by the game engine (physics engine and renderer) is RigidBody, I define a subclass of RigidBody called BubbleProjectile to represent the bubble projectile. This subclass has a Bubble property to indicate which type of bubble this projectile is. By doing this, I can use my game engine to do the updating view, collision detection, event detection and update physics property such as position and velocity to the bubble projectile. 
> I define a Shape property for RigidBody, currently circle and line segment are supported. so i can have rigid bodies of different shape. For instance, the lightning obstacles are also rigid body, but with line segment shape while bubble projectile has circle shape. This also allows me to detect collision between bubble projectiles and lightning obstacles using the physics engine.
> Render is done by let the Renderer keep track of the RigidBody-UIView pair, and update UIView property based on the RigidBody physics property updated by the physics engine. This is how the UIView representing the projectiles and lightning obstacles are represent 
> - **advantage, disadvantage, alternatives** 
>     - advan:  
>         - the physics engine is completely independent, it can be used in any game with the same rigid body physics law, same for the renderer.
>         - the physics engine is extensible. for instance, i add circle-segment collision detection in ps5, i can further add polygon-circle collision detection. this is because the class defined in physics is general enough
>     - disadv: 
>         - since my custom gameplay-logic is written in a single controller, the controller is long. i currently solve by divide the controller into several extension according to the functionality it implements (shoot bubbles, remove grid bubbles ...)
>         - the render job is done by directly modifying the corresponding UIView, such requirement for the UIViews is restrictive, while most formal renderers use underlying graphics api to "draw", which is more flexible.
>     - alternative: 
>         - alternative 1: put custom logic in game engine
>         I put custom game logic in the GamePlayController, so GamePlayController communication with physics engine and renderer directly while my game engine is general, it only keeps a game loop for physics engine to update and renderer to draw. However, alternative is to place custom game logic in GameEngine. I feed both ways are not that different. gameplay logic is to link between model and view (such as calculating score, and update the corresponding score label), this is exactly what controller does. a separate gameplay-logic engine is no different from a gameplay-logic delegate of the controller, or even no different from a gameplay-logic extension of the controller. Thus, I do not fell it is a must to write custom gameplay-game logic into the so-called "game engine". one of the benefit is that if write all the game logic inside a single controller, it will be very long. But, this could also be solved by using delegate or extensions 
>         - alternative 2: let bubbles in the grid and walls also be rigid body
>         currently, i did not has corresponding rigid body for grid bubbles and walls. the "collision detection" is done using a more general "event detection", which allow users to define the trigger condition by defining the closure themselves. the reason I did in this way is in ps4, i have not written the general collision detection between circles and lines, between dynamic bodies and static bodies, so in order to be general and extensible, i use event detector. the advantage of defining bubbles and walls to be rigid body is it makes the design more structural.  the disadvantage is that i might bring more computation burden. finally, in this game, there is no really need to make the wall and grid bubbles to be rigid body since the collision can be easily hard-coded and they are static. there is no need for physics engine and renderer to track them. however, if there shape are complex and vary a lot, or if they have other impact on the game rather than the collision that can be easily handled using event detector, such as influence the shadow rendering in 3D game, I will define them as rigid bodies.


### Problem 4.3

> - **implementation of power bubbles:** the power behaviors are done in 2 steps, first GamePlayController (controller) call BubbleGrid (model) to get all the index paths of the grid bubbles that should be removed by the power bubbles, then GamePlayController call BubbleGridViewController to remove the corresponding view of all those grid bubbles with animation by giving it these index paths, and also call audioPlayer to play the corresponding sound effects.
> - **implementation of chaining:** the chaining is done using recursion. As described above, GamePlayController will call BubbleGrid to get all the index paths of the gird bubbles to be removed in "triggerXXXSuperPower" method, after get this index paths, it will check whether there are also special power bubble in it, if so, then call "triggerXXXSuperPower" on those super power bubbles.
> - **best among alternatives?**
>     - as described above, an alternative can be putting game logic in "game engine", which i feel is no different from a game logic delegate or even an game logic extension of controller. and as explained above, i cannot claim one is better than the other
>     - using recursion to do the chaining is intuitive and understandable. which is the good point. 
>     - if there is a sleep/pause method, then using recursion can do the chaining delay easily. however, I have not found such methods in Swift
>     - using dispatch_after cannot implement the chaining delay for recursion.
>     - **the above are some discussion, but I cannot prove my implementation is the best among alternatives**

### Problem 7: Class Diagram

Please save your diagram as `class-diagram.png` in the root directory of the repository.

### Problem 8: Testing

> #### ------ Black-box testing ------
> #### test menu scene: (for the following description, tapping a button means tapping its image, tapping the label will not trigger the event currently)
> - *test Play button*
>     - expected: after tapping the Play button, the game should switch to grid-selection-scene (the scene to select a level to play) 
> - *test Design button*
>     - expected: after tapping the Design button, the game should switch to the level-design-scene
> - *test Setting button*    
>     - expected: after tapping the Setting button, 
>   if the setting panel is hidden before tapping, then it will be displayed
>   if the setting panel is displayed before tapping, then it will be hidden
> - *test background-music-toggle-button in Setting panel*
>     - expected: tap the toggle button will toggle whether to play the background music, 
>   when toggle off the background music, it will pause at that time point. When the background music is toggled on, it will continue from the time point it paused at last time.
> - *test background music*
>     - expected: there should be background music played if the toggle button is in "on" state. the background music shoot loop infinitely.
> #### test bubble grid designer scene:
> - *test designer main view*
>     - test changing mode by tapping bubble buttons or erase button
>         - expected: tapping an highlighted button will switch to cycle mode, tapping an un-highlighted button will switch the the selected mode
>     - test highlighting mode buttons by tapping it
>         - expected: tapping an button will toggle the highlight state
>     - test highlighting Save/Load button by tapping it
>         - expected: tapping Save/Load button will toggle highlighting state of the one tapped, if the other one is also highlighted, un-highlight it
>   - test displaying storage panel
>       - expected: if one of the Save/Load button is highlighted, storage panel should be displayed
>   - test cleaning all cells by tapping reset button
>       - expected: after tapping the reset button
> - *test bubble grid*
>     - test tapping gesture in filling/erasing/cycling mode
>         - expected: 
>             in filling mode: fill the cell with the bubble of the selected type
>             in erasing mode: the cell becomes empty
>             in cycling mode: if the cell is empty before tapping, then it should remain empty; if not empty, should cycle through in the order the same as the one shown in the palette
>     - test filling cells after choosing a color with pan gesture in filling mode
>         - expected: the cells panning over will be filled with the bubble of the selected color
>     - test erasing cells by long pressing in any mode
>         - expected: the cell that is long pressed becomes empty
> - test storage panel
>     - test creating new empty plist file to be saved into. 
>         - expected: the new level will be created and the grid inside it will be initialized to be an empty grid
>         **Special cases**:
>             - there should be no file created if the name given is empty
>             - if a duplicate name is given, the new empty one will overwrite the existing one
>             - the name only contains space, the empty file will still be created because it is a valid name
>     - test deleting a level
>         - expected: the file will be deleted from the storage and it will be removed from the storage panel
>     - test saving the current bubble grid into a level
>         - no matter whether the grid is empty, partially empty of full, it will be saved into the selected level when the level is selected by tapping
>     - test loading a bubble grid in the storage panel:
>         - expected: the loaded one will be displayed in the design grid and the original one in the grid will be discarded
> #### test level selector scene:   
> - *test displaying the correct grids*
>   - expected: both the preloaded levels as well as the levels designed by players should be displayed. These levels are displayed in a table with 2 columns.
> - *test tapping back button*
>   - expected: the game should switch to the menu scene
> - *test tapping a grid that is displayed (including the name label part)*
>   - expected: the game should switch to the game-play-scene, where the level (grid) is the one selected by tapping
> - *test grid-falling animation*
>   - expected: when the game switch to the level-selector-scene, either from the menu-scene or from the game-play-scene,  
>   the grid will falling down with elasticity
> #### test gameplay scene:
> - *test rule for the pending color*
>   - case: at the beginning of the game, that is, generating the pending bubble for the first time
>     - expected: the color of the pending bubble should be generated according to the rule specified in problem 2
>   - case: no the first time generating the pending bubble
>     - expected:  the color of the pending bubble should be replaced by the color of the next bubble when the current pending bubble is shot
> - *test rule for the next color*
>   - case: when the number of projectile left is > 0
>     - expected: the color of the next bubble should be generated according to the rule specified in problem 2
>   - case: when the number of projectile left is 0, that is, the pending bubble is the last projectile
>     - expected: there is no next bubble. the place where the next bubble is shown should be empty
> - *test bubble launching with tap gesture*
>     - expected: after the player tap a position, cannon will rotate toward that position, and bubble projectile will be shot towards that position. note if the angle of shooting is too small, that is, almost horizontal direction, then the bubble will not be shot
> - *test bubble launching with pan gesture*
>     - expected: when the player place the finger on the screen and move a bit to be recognized as a pan gesture, cannon will rotate to the position where the finger is placed and a aiming beam, which is a line of shurikens, will be displayed. After this, whenever the player move the finger, the direction of the cannon and the aiming beam will be updated. When the player lift off the finger, the aiming beam will disappear and the bubble projectile will be shot towards the position where the finger is lifted off. note if the angle of the shooting is too small, that is, almost horizontal direction, then the bubble will not be shot
> - *test bubble movement*
>     - expected: the bubble should move at a constant speed once it is launched
>			                the direction of the velocity will be changed by collision 
>			                but the magnitude will keep unchanged
> - *test bubble collision with the side wall*
>     - expected: that is, the vertical component of the velocity should keep unchanged 
>			                while the horizontal component of the velocity should become the opposite
> - *test bubble collision with the top wall*
>     - expected: the bubble should stop moving and snap to the grid cells according to the rule specified
> - *test bubble projectile collision with the bottom wall*
>     - expected: the bubble should disappear and never appear again
> - *test bubble projectile collision with the bubbles in the grid*
>     - expected: 
>         - collide with another bubble in the arena, not at the last row
>            expected: the bubble should stop moving and snap to the grid cells according to the rule specified
>        - collide with another bubble in the arena, but at the last row
>            expected: the bubble should disappear, it will not snap to the grid cell
> - *test projectile collision with the lightning obstacles*
>     - expected: the bubble will be "destroyed" by the lightning obstacles
> - *test the movement of the lightning obstacles*
>     - expected: there are 3 obstacles shown, the 2 on the 2 sides are static and rotate with a certain angles upwards
>     the other one is a dynamic one which keep moving left and right, its y position is randomly within a certain range
> - *test bubble snapping to grid cells*
>     - expected: **neighbor positions**: the vertices of the inscribed hexagon of the bubble
>        - after collide with a bubble in the arena, not at the last row
>            expected: the bubble should settle at the closest empty cells
>       - after collide with a bubble in the arena, but at the last row
>            expected: if there is an empty cell which can be reached by any of the neighbor positions
>                the bubble will settle at that cell
>                if not, the bubble will disappear, it will not snap to the grid cell
>        - shoot towards the gap between the leftmost or right most grid bubble on the even row and the sidewall
>            in this case, when the bubble projectile collides with grid bubble, its center may be in the gap, not in any cells, 
>            expected: if there is an empty cell which can be reached by any of the neighbor positions
>                the bubble will settle at that cell
> - *test removing connected bubbles*
>     - expected: if there are 3 connected bubbles of the same color, they will be removed
> - *test lightning power*
>     - expected: if the bubble projectile collide with a lightning bubble in the grid, the projectile, the lightning bubble itself and all bubbles in the same row will be removed with animation
> - *test bomb power*
>     - expected: if the bubble projectile collide with a bomb bubble in the grid, the projectile, the bomb bubble itself and all bubbles adjacent to the bomb bubble will be removed with animation
> - *test star power*
>     - expected: if the bubble projectile collide with a star bubble in the grid, the projectile, the star bubble itself and all bubbles in the gird of the same color will be removed 
> - *test chaining power*
>     - expected: the lightning bubble and the bomb bubble will chain their effect, that is, if there is any lightning or bomb bubble removed by another lightning or bomb bubble, its power will also be triggered. star bubble will not be chained
> - *test unattached bubbles*
>     - expected: after the corresponding removal by connected-bubble-of-the-same-color and power-bubble-with-chaining are all done, all bubbles that are unattached to the top wall will be removed with a fall down animation
> - *test animation*
>     - expected: shooting, 3-or-more-same-color-removal, lightning, bomb, unattached-bubbles-removal, collide with lightning obstacles all have corresponding animation
> - *test sound effect*
>     - expected: shooting, 3-or-more-same-color-removal, lightning, bomb, star, collide with lightning obstacles all have corresponding sound effects
> #### test ending scene: 
>   - test displayer final score
>     - expected: the ending scene should display the final score of this round
>   - test tapping back button
>     - tapping the back button should trigger the same event as tapping the back button in game-play-scene  
>     that is, it will make the game switch back to the previous scene (level-selector-scene or level-design-scene)
>     
> -------------------------------------
> #### ------ White-box testing ------
> White-box testing
> ##### designer
> * test BubbleGridController()
>        - setUpEmptyBubbleGridModel
>            - after the method finishes, the bubble2dArray property of currentBubbleGrid should be a 2d array
>            whose odd rows contain numCellsPerOddRow number of nil
>            whose even rows contain numCellsPerOddRow - 1 number of nil
>        - numOfSections(in collectionView)
>            - the return value should equal to numRows after setUpEmptyBubbleGridModel is called
>        - cleanAllCells()
>            - the bubble2dArray property of currentBubbleGrid should be a 2d array
>            whose odd rows contain numCellsPerOddRow number of nil
>            whose even rows contain numCellsPerOddRow - 1 number of nil              
> * test StorageManager
>        - loadBubbleGridURLs()
>            - the return values should be the list of urls of the files and directories at gridDesignDirURL
>        - createEmptyBubbleGridPlistFile(ofName name)
>            - case: name is an empty string
>                expected: there is no new file created at gridDesignDirURL, that is, .count will not change 
>            - case: name already appears in the return value of loadBubbleGridURLs()
>                expected: the new empty one should overwrite the existing one
>        - save(contentDic:, into fileURL:) and load(from fileURL)
>            save a dictionary and then load it, the result should be the same as the original
>    * test BubbleGrid (the following tests should be implemented as unit test using XCTAssert, becaue this is a simple ADT)
>        - setBubbleAt(row:, col:, to bubble:)
>            - case: valid row and col
>                expected: after the method is called, bubble2dArray[row][col] should == bubble, but !== bubble
>            - case: row or col out of bound
>                expected: no change as before the method is called
>        - appendBubble(_ newBubble:, to row:)
>            - case: valid row
>                expected after the method is called, the newBubble should be appended to bubble2dArray[row]
>            - case: row out of bound
>                expected: no change
>        - emptyCellAt(row:, col:)
>            - case: valid row and col
>                expected: after the method is called, bubble2dArray[row][col] == nil
>            - case; row or col out of bound
>                expected: no change
>        - appendArrayOfBubbles(_ bubbles:)
>            - the bubbles should be appeded to the end of bubble2dArray
>        - getBubbleAt(row:, col:)
>            - case: valid row and col
>                expected: return bubble2dArray[row][col]
>            - case: row or col out of bound
>                expected: assert false and receive error message
>        - geNumCellsAt(row:)
>            - case: valid row
>                expected: return bubble2dArray[row].count
>            - case; row out of bound
>                expected: assert false and receive error message
>        - isCellEmptyAt(row:, col:)
>            - case: valid row
>                expected: return whether bubble2dArray[row][col] equals nil or not
>            - case: row out of bound
>                expected: assert false and receive error message
>        - cleanAllCells()
>            - expected: all the entry of bubble2dArray should be set to nil
>        - replica()
>            - return a new BubbleGrid object which is the equal to current one (same bubble? at all entries)
> ##### game play
>    * test Int extension 
>        - test randomWithinRange:
>            expected: generate integers from lower bound (inclusive) to upper bound (inclusive) 
>                with equal possibilities
>    * test CGVector extension operation
>        - the result of the operation should be the same as the mathematical definition
>        - test divides a vector by scalar zero
>            expected: return zero vector
>    * test Array extension
>        - test removeEqualItems(item: Element)
>            expected: the method should remove all the items that is equal to the item given
>        - test removeEqualItems(item: Element) with an empty array
>            expected: the array should remain empty
>        - test getAllPairs()
>            expected: the method should return all pairs of elements in array, 
>                excluding pairs of element at the same index and pairs of reverse order
>    * test World
>        - rigidBodies array should contain all bubble projectiles currently moving 
>            when there is no bubble projectile moving, the rigidBodies array should be empty
>        - targets array in each event detector should contain all bubble projectiles currently moving
>            when there is no bubble projectile moving, the targets array should be empty
>        - targets array in each collision detector should be empty (it is implemented but not used yet)
>        - test removeBody(_ rigidBody: RigidBody)
>            expected: this method should remove the target from its rigidBodies array
>                Besides, it should also remove the target from its collision detectors and event detectors
>    * test Renderer
>        - bodyViewMappng array should contain all bubble projectiles and their corresponding view currently moving
>            when there is no bubble projectile moving, the bodyViewMappng array should eb empty
>        - register should add 
>    * test GamePlayController
>        - the positionsOfGridBubbles array should contains the centers of all the non-empty bubbleGridCells
>            if all the cells are emtpy, positionsOfGridBubbles array should be empty
>    * test BubbleGrid
>        - test connectedIndexPathsOfSameColor(from indexPath: IndexPath) -> [IndexPath]
>            expected: it should returns the index paths of
>                 all the connected bubble grid cells with bubble of the same color originated from the given index path 
>        - test unconnectedIndexPaths() -> [IndexPath]
>            expected: it should returns the index paths of 
>                all the unattached bubbles in the bubble grid
>    * test CircleShape
>        - test overlap(at myPosition: CGVector, with shape: Shape, at position: CGVector) -> Bool
>            expected: if shape (the other shape) is neither a CircleShape nor a SegmentShape, return false
>                else, return whether this circle overlaps with shape (the other shape, line segment or circle)
>                the center of this circle is myPosition + self.offset
>                the center of the other circle is position + shape.offset
>    * test SegmentShape
>        - test overlap
>            expected: if the other shape is not a circle, return false
>                else, return whether this line segment overlaps with the circle
>    * test GameEngine
>        - test removeRigidBody(_ target: RigidBody)
>            expected: this method should remove the target from its renderer and world (physics engine)
>    * test velocity after collision with the side wall
>        - expected: after the bubble collide with the side wall, the x component of the velocity should be the opposite
>        the y component of the velocity should remain no change
>    * test velocity after collision between bubbles

       
### Problem 9: The Bells & Whistles

> ##### List of extra features I implement:
> - Implement the bubble bursting animation using the sprite bubble-burst.png
> - Implement the lightning animation
> - Implement the bomb animation
> - Implement background music (with a toggle button) and sound effects
> - Adding game score
>   - every bubble removed worth the same score: 10. And the total score displayed will update every time there are bubbles removed. When the game ended (run out of projectiles), the final score will be shown in the ending scene 
> - Ending scene
>   - ending scene will show the total score of the player for this round, and provide a button to go back to the level selector scene
> - Cannon has limited number of shots in the game, after which the player loses
>   - there is no win or lose for this game, if shots are run out, then the game is over and total score will be calculated and ending scene will be displayed
> - Add trajectory animation and path to the cannon
>   - if players use pan gesture to shoot the bubble, trajectory will be displayed and update when players move their finger
> - Lightning obstacles and corresponding animation
>   - the bubble projectile will be "destroyed" by the lightning obstacles if there is a collision
>  lightning obstacles can: keep moving, rotate (keep rotating or fix a angle), have different lengths

### Problem 10: Final Reflection

> #### about MVC design (not including the MVC for game play)
> Through PS3 to PS5, I did not change my MVC design.
> for the MVC design, I think my design is generally fine. but there are one problem:
> - problem description: I have a controller (BBSagaDesignController) which has 2 child controllers (BubbleGridController and StoragePanel Controller), the 2 child controllers are separate in jobs, but they still have certain connection. For instance, when loading and saving storage panel controller need to communicate with bubble grid controller. but these 2 child controllers can only access each other through their shared parent controllers. such weird communication (child1 -> parent -> child2) is not a good design. 
> Besides, sometimes, the child controller needs to access the parent controller, such 2-direction association might not be a good design also. I should redesign to make these 3 controllers less coupling.
> #### about Game Engine design
> as described above, I think my physics engine is flexible and extensible and general enough, however, my renderer works in a restricted way (update representative UIView according to corresponding rigid body), which is however, sufficient for this project.
> Another problem is I put my game logic into a single controller, which makes the file very long, I think one of the solution is to assign different, separate functionalities to several delegates. The current solution I do is to divide the controller into several extensions, each taking charge of a single functionality. I think this is a workable but not best solution. I somehow write in a structural programming way rather than the OOP way. I could have designed more ""OOP-ly" 
> I think I am still not quite clear about the role of the controller because I am still not clear why custom gameplay logic should be separated from GamePlayController to put into game engine. Also, what is the role of game engine with game play logic, controller? model? or others
> #### To summarize: 
> the following points could be improved:
> - the child2-parent-child2 communication is not a good design
> - the child-parent parent-child 2-way association is not a good design
> - writing all the custom gameplay logic in a single controller is NOT A GOOD design. maybe try using delegate?
> - should separate out gameplay logic into "game engine"? (maybe check the game engine in the market?)

CS3217 Problem Set 5
==

**Name:** Luo Yuyang

**Matric No:** A0147980U

**Tutor:** Zheng Yi Tham

### Notes of the glossary:
> in the following description, "level", "grid", "bubble grid" most likely refer to the same thing

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
when the player lift off the finger from the screen, the bubble projectile will be shot towards the position where the finger is lifted off (the same direction as the aiming beam and the cannon point to).
 
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

Your answer here


### Problem 4.3

Your answer here


### Problem 7: Class Diagram

Please save your diagram as `class-diagram.png` in the root directory of the repository.

### Problem 8: Testing

> #### ------ Black-box testing ------
> #### test menu scene: (for the following descriptiion, tapping a button means tapping its image, tapping the label will not trigger the event currently)
> - *test Play button*
>   - expected: after tapping the Play button, the game should switch to grid-selection-scene (the scene to select a level to play) 
> - *test Design button*
>   - expected: after tapping the Design button, the game should switch to the level-design-scene
> - *test Setting button*    
>   - expected: after tapping the Setting button, 
>   if the setting panel is hidden before tapping, then it will be displayed
>   if the setting panel is displayed before tapping, then it will be hidden
> - *test background-music-toggle-button in Setting panel*
>   - expected: tap the toggle button will toggle whether to play the background music, 
>   when toggle off the background music, it will pause at that time point. When the background music is toggled on, it will continue from the time point it paused at last time.
> - *test background music*
>   - expected: there should be background music played if the toggle button is in "on" state. the background music shoot loop infinitely.
> #### test bubble grid designer scene:
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
> - *test shooting direction with tapping gesture*
> - *test shooting direction with panning gesture*
> - *test shooting sound effect*
> - *test aiming beam*
> #### test ending scene: 
>   - test displayer final score
>     - expected: the ending scene should display the final score of this round
>   - test tapping back button
>     - tapping the back button should trigger the same event as tapping the back button in game-play-scene  
>     that is, it will make the game switch back to the previous scene (level-selector-scene or level-design-scene)
>     
> -------------------------------------
> #### ------ White-box testing ------
> 
       
### Problem 9: The Bells & Whistles

> ##### List of extra features I implement:
> - Implement the bubble bursting animation using the sprite bubble-burst.png
> - Implement the lightning animation
> - Implement the bomb animation
> - Implement background music (with toggle button) and sound effects
> - Adding game score
>   - every bubble removed worth the same score: 10. And the total score displayed will update every time there are bubbles removed. When the game ended (run out of projectiles), the final score will be shown in the ending scene 
> - Ending scene
>   - ending scene will show the total score of the player for this round, and provide a button to go back to the level selector scene
> - Cannon has limited number of shots in the game, after which the player loses
>   - there is no win or lose for this game, if shots are run out, then the game is over and total score will be calculated and ending scene will be displayed
> - Add trajectory animation and path to the cannon
>   - if players use pan gesture to shoot the bubble, trajectory will be displayed and update when players move their finger
> - Lightning obstacles
>   - the bubble projectile will be "destroyed" by the lightning obstacles if there is a collision
>  lightning obstacles can: keep moving, rotate (keep rotating or fix a angle), have different lengths

### Problem 10: Final Reflection

Your answer here

import UIKit
import SpriteKit

class MiniGameViewController: UIViewController {
    
    // MARK: Properties
    // Will be assigned in the previous VC (ScenarioViewController).
    var gameIndex: Int = 0
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var gameScene: SKScene!
        let skView = view as! SKView
        
        // Determine which mini game to load.
        switch (gameIndex) {
            
        // Mine Sweeper
        case -1:
            let minesweeperGame = MinesweeperGameScene(size: view.bounds.size)
            minesweeperGame.viewController = self
            gameScene = minesweeperGame
        default:
            print("Unknown mini game.")
        }
        
        gameScene.scaleMode = .resizeFill
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
    }
    
    // Hide status bar.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Called by the mini game.
    func endGame() {
        performSegue(withIdentifier: "toResultScene", sender: self)
    }
    
    // MARK: Segues
    @IBAction func unwindToMiniGame(unwindSegue: UIStoryboardSegue) {
        // Reset mini game
    }
}

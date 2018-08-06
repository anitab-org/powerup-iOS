import UIKit
import SpriteKit

enum MiniGameIndex: Int {
    case unknown = 0
    case minesweeper = -1
    case sinkToSwim = -2
    case vocabMatching = -3
}

class MiniGameViewController: UIViewController,SegueHandler {
    enum SegueIdentifier: String {
        case toResultSceneView = "toResultScene"
    }
    
    // MARK: Properties
    var completedScenarioID: Int = -1
    
    // Keep a reference of the background image so that result scene could use it. (This is being assigned by ScenarioViewController).
    var scenarioBackgroundImage: UIImage? = nil
    var scenarioName: String = ""
    
    // Will be assigned in the previous VC (ScenarioViewController).
    var gameIndex: MiniGameIndex = .unknown
    
    // Score of the played minigame (will be used to update karma points)
    var score: Int = 0
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var gameScene: SKScene!
        let skView = view as! SKView
        
        // Determine which mini game to load.
        switch (gameIndex) {
            
        // Mine Sweeper
        case .minesweeper:
            let minesweeperGame = MinesweeperGameScene(size: view.bounds.size)
            minesweeperGame.viewController = self
            gameScene = minesweeperGame
            
        // Vocab Matching
        case .vocabMatching:
            let vocabMatchingGame = VocabMatchingGameScene(size: view.bounds.size)
            vocabMatchingGame.viewController = self
            gameScene = vocabMatchingGame
            
        // Sink to Swim Game
        case .sinkToSwim:
            let sinkToSwimGame = SinkToSwimGameScene(size: view.bounds.size)
            sinkToSwimGame.viewController = self
            gameScene = sinkToSwimGame
            
        default:
            print("Unknown mini game.")
        }
        
        gameScene.scaleMode = .resizeFill
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
    }
    
    // Hide status bar.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Called by the mini game.
    func endGame() {
        performSegueWithIdentifier(.toResultSceneView, sender: self)
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultsViewController {
            resultVC.completedScenarioID = completedScenarioID
            resultVC.completedScenarioName = scenarioName
            resultVC.karmaGain = 20 + score
        }
    }
    
    @IBAction func unwindToMiniGame(unwindSegue: UIStoryboardSegue) {
        // Reset mini game
    }
}

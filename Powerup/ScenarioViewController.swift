import UIKit

class ScenarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // current scenario, set by MapViewController
    var scenarioID: Int = 0
    var scenarioName: String = ""
    
    // The background image of the view, set by MapViewController.
    var backgroundImage: UIImage? = nil

    // Questions ([questionID : question]) for the scenario
    var questions = [Int:Question]()
    var currQuestionID: Int = -1
    var toMiniGameIndex: Int = 0
    
    // Answers for the question
    var answers = [Answer]()
    
    // MARK: Views
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scenarioNameLabel: UILabel!
    @IBOutlet weak var choicesTableView: UITableView!
    
    // Question Label and Choice Buttons
    @IBOutlet weak var questionLabel: UILabel!
    
    // ImageViews for avatar
    // These should be merged into a customized controller soon
    @IBOutlet weak var eyesView: UIImageView!
    @IBOutlet weak var hairView: UIImageView!
    @IBOutlet weak var faceView: UIImageView!
    @IBOutlet weak var clothesView: UIImageView!
    @IBOutlet weak var necklaceView: UIImageView!
    @IBOutlet weak var handbagView: UIImageView!
    @IBOutlet weak var glassesView: UIImageView!
    @IBOutlet weak var hatView: UIImageView!
    
    // MARK: Functions
    func resetQuestionAndChoices() {
        
        
        // Configure question description
        questionLabel.text = questions[currQuestionID]?.questionDescription
        
        // Fetch answers from database
        do {
            try answers = dataSource.getAnswers(of: currQuestionID)
        } catch _ {
            // Unwind back to map view if cound't fetch choices from database.
            let alert = UIAlertController(title: "Warning", message: "Error loading the choices. Please try again!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {action in self.performSegue(withIdentifier: "unwindToMap", sender: self)})
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        // No answers left, reveal "continue" button to go to result view controller.
        if answers.count == 0 {
            answers.append(Answer(answerID: -1, questionID: -1, answerDescription: "Continue", nextQuestionID: "$", points: 0))
        }
        
        // Reload the table.
        choicesTableView.reloadData()
    }
    
    // Configures the accessories of the avatar.
    func configureAvatar() {
        let avatar: Avatar!
        
        do {
            avatar = try dataSource.getAvatar()
        } catch _ {
            // Unwind back to map view if cound't fetch avatar from database.
            let alert = UIAlertController(title: "Warning", message: "Error loading the avatar. Please try again!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {action in self.performSegue(withIdentifier: "unwindToMap", sender: self)})
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    
        clothesView.image = avatar.clothes.image
        faceView.image = avatar.face.image
        hairView.image = avatar.hair.image
        eyesView.image = avatar.eyes.image
        handbagView.image = avatar.handbag?.image
        glassesView.image = avatar.glasses?.image
        hatView.image = avatar.hat?.image
        necklaceView.image = avatar.necklace?.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choicesTableView.delegate = self
        choicesTableView.dataSource = self
        
        // Configure table cells.
        // Set cell height according to the TableView height.
        choicesTableView.rowHeight = (choicesTableView.frame.size.height / 3).rounded()
        choicesTableView.contentInset = UIEdgeInsetsMake(0, -2, 0, -35)
        
        // TODO: Configure the image and name of the "Asker" avatar.
        
        // Configure scenario name.
        scenarioNameLabel.text = scenarioName
        
        // Configure background image.
        backgroundImageView.image = backgroundImage

        configureAvatar()
        
        initializeQuestions()
        
        resetQuestionAndChoices()
    }
    
    func initializeQuestions() {
        // Fetch questions from database
        do {
            questions = try dataSource.getQuestions(of: scenarioID)
        } catch _ {
            // Unwind back to map view if cound't fetch questions from database.
            let alert = UIAlertController(title: "Warning", message: "Error loading the scenario. Please try again!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {action in self.performSegue(withIdentifier: "unwindToMap", sender: self)})
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Configure the initial question (which has the smallest key)
        if let initQuestionID = (questions.min {a, b in a.key < b.key}?.key) {
            currQuestionID = initQuestionID
        }
    }
    
    // MARK: UITableViewDataSourceDelegate
    // How many cells are there.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    // Configure the cells (choices) of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = answers[indexPath.row].answerDescription
        return cell
    }
    
    // MARK: UITableViewDelegate
    // Selected a cell (choice).
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        
        // Check if the next questionID is a valid integer, if not, it's the end of the scnario (entering a mini game)
        let nextQuestionID = answers[selectedIndex].nextQuestionID
        if let nextQuestionIDInt = Int(nextQuestionID) {
            
            if nextQuestionIDInt > 0 {
                // Set the new question ID and reset the questions & choices
                currQuestionID = nextQuestionIDInt
                resetQuestionAndChoices()
                
            } else {
                // Negative nextQuestion indicates mini game transitions
                toMiniGameIndex = nextQuestionIDInt
                performSegue(withIdentifier: "toMiniGame", sender: self)
            }
            
        } else {
            // Perform push segue to result scene
            performSegue(withIdentifier: "toEndScene", sender: self)
        }
        
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare for MiniGameViewController
        if let miniGameVC = segue.destination as? MiniGameViewController {
            miniGameVC.gameIndex = MiniGameIndex(rawValue: toMiniGameIndex) ?? .unknown
            
            // Pass the background image to minigame view controller so that results view controller knows which background image to display.
            miniGameVC.scenarioBackgroundImage = backgroundImage
            miniGameVC.completedScenarioID = scenarioID
            miniGameVC.scenarioName = scenarioName
        } else if let resultsVC = segue.destination as? ResultsViewController {
            // Set the scenarioID.
            resultsVC.completedScenarioID = scenarioID
            resultsVC.completedScenarioName = scenarioName
        }
    }
    
    // Replay the scenario.
    @IBAction func unwindToScenario(unwindSegue: UIStoryboardSegue) {
        initializeQuestions()
        
        resetQuestionAndChoices()
    }
}

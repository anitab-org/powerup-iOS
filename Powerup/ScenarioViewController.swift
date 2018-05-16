import UIKit

class ScenarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopupEventPlayerDelegate, SegueHandler {
    enum SegueIdentifier: String {
        case unwindToMapView = "unwindToMap"
        case toMiniGameView = "toMiniGame"
        case toEndSceneView = "toEndScene"
    }
    
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    var popup : PopupEventPlayer?
    
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

            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingChoicesMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .default, handler: {action in self.performSegueWithIdentifier(.unwindToMapView, sender: self)})

            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        // No answers left, reveal "continue" button to go to result view controller.
        if answers.count == 0 {
            answers.append(Answer(answerID: -1, questionID: -1, answerDescription: "Continue", nextQuestionID: "$", points: 0, popupID: "#"))
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

            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingAvatarMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .default, handler: {action in self.performSegueWithIdentifier(.unwindToMapView, sender: self)})

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
        
        startSequence();
    }
    
    func initializeQuestions() {
        // Fetch questions from database
        do {
            questions = try dataSource.getQuestions(of: scenarioID)
        } catch _ {
            // Unwind back to map view if cound't fetch questions from database.

            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingScenarioMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .default, handler: {action in self.performSegueWithIdentifier(.unwindToMapView, sender: self)})

            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Configure the initial question (which has the smallest key)
        if let initQuestionID = (questions.min {a, b in a.key < b.key}?.key) {
            currQuestionID = initQuestionID
        }
    }
    
    // MARK: OOC Event Functions
    // handle starting sequence - opens as an overlay on top of the initial screen - called in viewDidLoad()
    func startSequence() {
        print("\nbegin opening sequence");
    }
    
    // handles calling events - func called in tableView didSelectRowAt indexPath
    func handlePopupEvent(idNumber: String) {
        // type check the idNumber String - if it's not an integer, ignore it
        print("\nhandlePopupEvent() with ID: "+idNumber)
        
        if let checkForInt = Int(idNumber) {
            // if it's an Int...
            if checkForInt > 0 {
                // if it's positive, show inline popup
                print("\nPositive int - show inline popup")
                
                // swift handles inferring that a new instance of the controllers class variable "popup" should be created
                // may need to handle differently in Android - perhaps creating local variables for each instance and storing them in a higher scope array
                // otherwise overlapping calls may conflict
                popup = PopupEventPlayer(delegate: self)
                self.view.addSubview(popup!)
            } else {
                // if it's negative, show ending sequence
                print("\nNegative int - show ending sequence")
            }
        } else {
            print("\nNot an int, no ooc event")
        }
    }
    
    // MARK: PopupEventPlayer Delegate Methods
    func popupDidFinish(sender: PopupEventPlayer) {
        popup = nil
        print("\nreleased popup")
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
        
        // pass the popupID string of the selected answer to handlePopupEvent function
        handlePopupEvent(idNumber: answers[selectedIndex].popupID)
        
        if let nextQuestionIDInt = Int(nextQuestionID) {
            
            if nextQuestionIDInt > 0 {
                // Set the new question ID and reset the questions & choices
                currQuestionID = nextQuestionIDInt
                resetQuestionAndChoices()
                
            } else {
                // Negative nextQuestion indicates mini game transitions
                toMiniGameIndex = nextQuestionIDInt
                performSegueWithIdentifier(.toMiniGameView, sender: self)
            }
            
        } else {
            // Perform push segue to result scene
            performSegueWithIdentifier(.toEndSceneView, sender: self)
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
    
    // Alert the user about possibly losing karma points upon migrating back to the map.
    @IBAction func homeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: confirmationTitleMessage, message: mapMigrationAlertMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okText, style: .default, handler: {action in self.performSegueWithIdentifier(.unwindToMapView, sender: self)})
        let cancelButton = UIAlertAction(title: cancelText, style: .cancel, handler: {action in self.dismiss(animated: true, completion: nil)})
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

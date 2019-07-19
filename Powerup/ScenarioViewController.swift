import UIKit

class ScenarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StorySequencePlayerDelegate, PopupEventPlayerDelegate, SegueHandler {

    enum SegueIdentifier: String {
        case unwindToMapView = "unwindToMap"
        case toMiniGameView = "toMiniGame"
        case toEndSceneView = "toEndScene"
    }

    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance

    // current scenario, set by MapViewController
    var scenarioID: Int = 0
    var scenarioName: String = ""

    // The background image of the view, set by MapViewController.
    var backgroundImage: UIImage? = nil

    // Questions ([questionID : question]) for the scenario
    var questions = [Int: Question]()
    var currQuestionID: Int = -1
    var toMiniGameIndex: Int = 0

    // Answers for the question
    var answers = [Answer]()
    var nextQuestionID = "$"

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
            let okButton = UIAlertAction(title: okText, style: .default, handler: { action in self.performSegueWithIdentifier(.unwindToMapView, sender: self) })

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
            let okButton = UIAlertAction(title: okText, style: .default, handler: { action in self.performSegueWithIdentifier(.unwindToMapView, sender: self) })

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
        choicesTableView.contentInset = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: -35)

        // TODO: Configure the image and name of the "Asker" avatar.

        // Configure scenario name.
        scenarioNameLabel.text = scenarioName

        // Configure background image.
        backgroundImageView.image = backgroundImage

        configureAvatar()

        initializeQuestions()

        resetQuestionAndChoices()

        startSequence()
    }

    func initializeQuestions() {
        // Fetch questions from database
        do {
            questions = try dataSource.getQuestions(of: scenarioID)
        } catch _ {
            // Unwind back to map view if cound't fetch questions from database.

            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingScenarioMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .default, handler: { action in self.performSegueWithIdentifier(.unwindToMapView, sender: self) })

            alert.addAction(okButton)

            self.present(alert, animated: true, completion: nil)

            return
        }

        // Configure the initial question (which has the smallest key)
        if let initQuestionID = (questions.min { a, b in a.key < b.key }?.key) {
            currQuestionID = initQuestionID
        }
    }

    // MARK: OOC Event Functions

    /**
     Check if the scenario has been previously completed.
     */
    func firstTime() -> Bool {
        do {
            let scenario: Scenario = try dataSource.getScenario(of: scenarioID)
            return !scenario.completed
        } catch _ {
            return true
        }
    }

    /**
     Handle starting sequences - opens as an overlay on top of the initial view. Checks if an intro sequence exists for the current scenarioID. Returns if not, otherwise creates an instance of StorySequencePlayer.

     Called in viewDidLoad().
     */
    func startSequence() {
        print("\nbegin opening sequence")

        guard let model = StorySequences().getStorySequence(scenario: scenarioID) else {
            print("Could not retrieve intro story sequence for scenario \(scenarioID).")
            return
        }

        let sequenceView: StorySequencePlayer = StorySequencePlayer(delegate: self, model: model, firstTime: firstTime())
        self.view.addSubview(sequenceView)
    }

    /**
     Handles calling popup events or outro sequences.

     - parameters:
        - popupID : String - the popupID property from the retrieved Answer

     The PopupEventPlayer class handles the entire popup lifecycle. This function only needs to creates a local instance of the class.
     */
    func handlePopupEvent(popupID: String) {
        // type check the idNumber String - if it's not an integer, ignore it
        if let popupID = Int(popupID) {
            // if it's an Int...
            if popupID > -1 {
                // if it's positive, show inline popup

                // go ahead and set up the next question
                handleNextQuestion()

                // get the correct model
                guard let model: PopupEvent = PopupEvents().getPopup(type: .scenario, collection: String(scenarioID), popupID: popupID) else {
                    print("Could not retrieve outro story sequence for scenario \(scenarioID) with popupID \(popupID).")
                    return
                }

                // create local instance of PopupEventPlayer class and add to view
                let event: PopupEventPlayer? = PopupEventPlayer(delegate: self, model: model)
                guard let popup = event else { return }
                popup.id = popupID
                self.view.addSubview(popup)

            } else {
                // if it's negative, show ending sequence
                startOutroSequence(popupID: popupID)
            }
        } else {
            // not an int, ignore ooc events
            handleNextQuestion()
        }
    }

    /**
     Handles calling outro sequences.

     - parameters:
        - popupID : Int - the popupID property from the retrieved Answer

     The PopupEventPlayer class handles the entire popup lifecycle. This function only needs to creates a local instance of the class.
     */
    func startOutroSequence(popupID: Int) {
        // outros have a negative id in the answer database, but positive in the story sequence dataset
        let popupID = abs(popupID)

        // get the correct outro sequence for the current scenario and answer
        guard let model = StorySequences().getStorySequence(scenario: scenarioID, outro: popupID) else {
            print("Could not retrieve outro story sequence for scenario \(scenarioID) with popupID \(popupID).")
            return
        }

        // create and start the sequence
        let sequenceView: StorySequencePlayer = StorySequencePlayer(delegate: self, model: model, firstTime: firstTime())

        // set a tag so we can differentiate outros and intros in the delegate method
        sequenceView.tag = 1
        self.view.addSubview(sequenceView)
    }

    // MARK: PopupEventPlayer Delegate Methods
    func popupDidShow(sender: PopupEventPlayer) {

    }

    func popupDidHide(sender: PopupEventPlayer) {

    }

    func popupWasTapped(sender: PopupEventPlayer) {

    }

    // MARK: StorySequencePlayer Delegate Methods
    func sequenceDidFinish(sender: StorySequencePlayer) {
        // outros were given a tag of 1 and needed to delay handleNextQuestion()
        if sender.tag == 1 {
            handleNextQuestion()
        }
    }

    func sequenceDidStart(sender: StorySequencePlayer) {

    }

    func sequenceWasSkipped(sender: StorySequencePlayer) {

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

        // store nextQuestionID - it might be used now, it might be used after a sequence
        nextQuestionID = answers[selectedIndex].nextQuestionID

        // pass the popupID string of the selected answer to handlePopupEvent function
        handlePopupEvent(popupID: answers[selectedIndex].popupID)
    }

    /**
     Because ending sequences are triggered by the popupID value, handleNextQuestion() is called from handlePopupEvent() or the StorySequencePlayer delegate method.
    */
    func handleNextQuestion() {
        // Check if the next questionID is a valid integer, if not, it's the end of the scnario (entering a mini game)
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
        let okButton = UIAlertAction(title: okText, style: .default, handler: { action in self.performSegueWithIdentifier(.unwindToMapView, sender: self) })
        let cancelButton = UIAlertAction(title: cancelText, style: .cancel, handler: { action in self.dismiss(animated: true, completion: nil) })

        alert.addAction(okButton)
        alert.addAction(cancelButton)

        self.present(alert, animated: true, completion: nil)
    }

}

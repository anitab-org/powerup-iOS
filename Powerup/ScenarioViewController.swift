import UIKit

class ScenarioViewController: UIViewController {
    
    //MARK: Properties
    
    // current scenario, set by the MapViewController
    var scenarioID: Int = 0

    // Questions ([questionID : question]) for the scenario
    var questions = [Int:Question]()
    var currQuestionID: Int = -1
    
    // Answers for the question
    var answers = [Answer]()
    
    //MARK: Views
    @IBOutlet weak var bgImage: UIImageView!
    
    // Question Label and Choice Buttons
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var choiceButtons: Array<UIButton>!
    
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
    
    func resetQuestionAndChoices() {
        // Hide question Label and all the Buttons for choices, will show them only if the query to Database is successful
        for choiceButton in choiceButtons {
            choiceButton.isHidden = true
        }
        
        // Configure question description
        questionLabel.text = questions[currQuestionID]?.questionDescription
        
        // Fetch answers from database
        answers = DatabaseAccessor.sharedInstance().getAnswers(of: currQuestionID)
        
        // No answers left, reveal "continue" button to go to mini game
        if answers.count == 0 {
            answers.append(Answer(answerID: -1, questionID: -1, answerDescription: "Continue", nextQuestionID: "$", points: 0))
        }
        
        // Configure answer buttons
        for (index, answer) in answers.enumerated() {
            let button = choiceButtons[index]
            
            // Configure title texts of buttons
            button.setTitle(answer.answerDescription, for: .normal)
            
            // Show buttons
            button.isHidden = false
        }
    }
    
    // Configures the accessories of the avatar.
    func configureAvatar() {
        let avatarConfig = DatabaseAccessor.sharedInstance().getAvatar()
        clothesView.image = UIImage(named: avatarConfig["Clothes"]!.1)
        faceView.image = UIImage(named: avatarConfig["Face"]!.1)
        hairView.image = UIImage(named: avatarConfig["Hair"]!.1)
        eyesView.image = UIImage(named: avatarConfig["Eyes"]!.1)
        
        // Optional accessories
        if let handbagName = avatarConfig["Handbag"]?.1 {
            handbagView.image = UIImage(named: handbagName)
        } else {
            handbagView.isHidden = true
        }
        
        if let glassesName = avatarConfig["Glasses"]?.1 {
            glassesView.image = UIImage(named: glassesName)
        } else {
            glassesView.isHidden = true
        }
        
        if let necklaceName = avatarConfig["Necklace"]?.1 {
            necklaceView.image = UIImage(named: necklaceName)
        } else {
            necklaceView.isHidden = true
        }
        
        if let hatName = avatarConfig["Hat"]?.1 {
            hatView.image = UIImage(named: hatName)
        } else {
            hatView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAvatar()
        
        // Fetch questions from database
        questions = DatabaseAccessor.sharedInstance().getQuestions(of: scenarioID)
        
        // Configure the initial question (which has the smallest key)
        if let initQuestionID = (questions.min {a, b in a.key < b.key}?.key) {
            currQuestionID = initQuestionID
        } else {
            print("Error initializing the first question.")
        }
        
        resetQuestionAndChoices()
        
        bgImage.image = UIImage(named: "endingscreen")
    }
    
    // MARK: Actions
    @IBAction func choiceSelected(_ sender: UIButton) {
        // Check which button is selected
        var selectedIndex = 0
        while sender != choiceButtons[selectedIndex] {
            selectedIndex += 1
        }
        
        // Check if the next questionID is a valid integer, if not, it's the end of the scnario (entering a mini game)
        if let nextQuestionID = Int(answers[selectedIndex].nextQuestionID) {
            // Set the new question ID and reset the questions & choices
            currQuestionID = nextQuestionID
            resetQuestionAndChoices()
        } else {
            // Perform modal segue to mini game scene
            performSegue(withIdentifier: "toMiniGame", sender: self)
        }
        
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare for MiniGameViewController
    }
    

}

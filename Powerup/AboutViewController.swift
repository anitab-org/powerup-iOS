import UIKit

class AboutViewController: UIViewController {

    // MARK: Action
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    @IBOutlet weak var questionFirst: UILabel!
    @IBOutlet weak var answerFirst: UILabel!
    @IBOutlet weak var questionSec: UILabel!
    @IBOutlet weak var answerSec: UILabel!
    @IBOutlet weak var questionThird: UILabel!
    @IBOutlet weak var answerThird: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        addPopup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         text(textFirst: aboutAnswerFirst, textSec: aboutAnswerSec, textThird: aboutAnswerThird)

    }

    // function for modification of about view taking string i/p from string and print to about view.
    func text(textFirst: String, textSec: String, textThird: String){
        
        questionFirst.text = "The Game"
        questionSec.text = "Why is PowerUp needed?"
        questionThird.text = "How does PowerUp helps teenagers?"
        
        // attributes for answers
        answerFirst.text! = textFirst
        answerSec.text! = textSec
        answerThird.text! = textThird
        
    }
    
    func addPopup() {
        let model = PopupEvent(topText: "Made with ♥",
                               botText: "by Systers Open Source",
                               imgName: nil,
                               slideSound: nil,
                               badgeSound: nil)
        let popup: PopupEventPlayer = PopupEventPlayer(model)
        self.view.addSubview(popup)
    }

}

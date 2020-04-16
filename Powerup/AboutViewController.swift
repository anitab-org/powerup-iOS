import UIKit

class AboutViewController: UIViewController {

    // MARK: Action
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    @IBOutlet weak var label1: UILabel!
 
    @IBOutlet weak var answerLabel1: UILabel!
    
    @IBOutlet weak var answerLabel2: UILabel!
    
    @IBOutlet weak var answerLabel3: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        addPopup()
       // text(desc1: aboutText, desc2: aboutText2, desc3: aboutText3)
        text(desc1: aboutText, desc2: aboutText2, desc3: aboutText3)
        
    }

    func text(desc1: String, desc2: String, desc3: String){
       label1.text! = "The Game"
        label1.textColor? = #colorLiteral(red: 0.3803921569, green: 0.6, blue: 0.6928837435, alpha: 1)
        label1.font = UIFont(name: "Arial", size: 22)
        label1.font = UIFont.boldSystemFont(ofSize: 22)
     
        answerLabel1.text! = desc1
        answerLabel1.textColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        answerLabel1.font = UIFont(name: "Arial", size: 15)
      
        answerLabel2.text! = desc2
        answerLabel2.textColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        answerLabel2.font = UIFont(name: "Arial", size: 15)
       
       answerLabel3.text! = desc3
        answerLabel3.textColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        answerLabel3.font = UIFont(name: "Arial", size: 15) 
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

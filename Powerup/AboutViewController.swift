import UIKit

class AboutViewController: UIViewController {

    // MARK: Action
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var aboutViewText: UITextView!

    
    override func viewDidAppear(_ animated: Bool) {
        addPopup()
        text(desc: aboutText)
        
    }

    func text(desc: String){
        aboutViewText.text! = desc
        aboutViewText.textColor? = #colorLiteral(red: 0.3803921569, green: 0.6, blue: 0.6928837435, alpha: 1)
        aboutViewText.safeAreaInsets.left
        aboutViewText.safeAreaInsets.right
        aboutViewText.safeAreaInsets.bottom
        aboutViewText.font = UIFont(name: "Arial", size: 20)
        
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

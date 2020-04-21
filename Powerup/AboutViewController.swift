import UIKit

class AboutViewController: UIViewController {

    // MARK: Action
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        addPopup()
    }

    override func viewDidLoad() {
           super.viewDidLoad()
        
     aboutText(text: textForAboutView)
    
    }
    
    func aboutText(text: String) {
            
            let attributedString = NSMutableAttributedString(string: textForAboutView)

            let attributes0: [NSAttributedString.Key : Any] = [
               .foregroundColor: UIColor(red: 74/255, green: 160/255, blue: 166/255, alpha: 1.0),
               .font: UIFont(name: "HelveticaNeue-Bold", size: 24)!
            ]
            attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: 8))

            let attributes2: [NSAttributedString.Key : Any] = [
               .foregroundColor: UIColor(red: 74/255, green: 160/255, blue: 166/255, alpha: 1.0),
               .font: UIFont(name: "HelveticaNeue", size: 20)!
            ]
            attributedString.addAttributes(attributes2, range: NSRange(location: 10, length: 578))

            let attributes4: [NSAttributedString.Key : Any] = [
               .foregroundColor: UIColor(red: 74/255, green: 160/255, blue: 166/255, alpha: 1.0),
               .font: UIFont(name: "HelveticaNeue-Bold", size: 24)!
            ]
            attributedString.addAttributes(attributes4, range: NSRange(location: 590, length: 23))

            let attributes6: [NSAttributedString.Key : Any] = [
               .foregroundColor: UIColor(red: 74/255, green: 160/255, blue: 166/255, alpha: 1.0),
               .font: UIFont(name: "HelveticaNeue", size: 20)!
            ]
            attributedString.addAttributes(attributes6, range: NSRange(location: 615, length: 884))

            let attributes8: [NSAttributedString.Key : Any] = [
               .foregroundColor: UIColor(red: 74/255, green: 160/255, blue: 166/255, alpha: 1.0),
               .font: UIFont(name: "HelveticaNeue-Bold", size: 24)!
            ]
            attributedString.addAttributes(attributes8, range: NSRange(location: 1501, length: 32))

            let attributes10: [NSAttributedString.Key : Any] = [
               .foregroundColor: UIColor(red: 74/255, green: 160/255, blue: 166/255, alpha: 1.0),
               .font: UIFont(name: "HelveticaNeue", size: 20)!
            ]
            attributedString.addAttributes(attributes10, range: NSRange(location: 1535, length: 508))
        
            textView.attributedText = attributedString

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


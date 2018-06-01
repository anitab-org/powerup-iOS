import UIKit

class AboutViewController: UIViewController, PopupEventPlayerDelegate {

    // MARK: Action
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        addPopup()
    }

    func addPopup() {
        let model = PopupEvent(topText: "Made with ♥",
                               botText: "by Systers Open Source",
                               imgName: nil,
                               doSound: false)
        let popup: PopupEventPlayer = PopupEventPlayer(delegate: self, model: model)
        self.view.addSubview(popup)
    }

    func popupDidFinish(sender: PopupEventPlayer) {
        sender.removeFromSuperview()
    }
}

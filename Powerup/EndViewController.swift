import UIKit

class EndViewController: UIViewController {

     var dataSource: DataSource = DatabaseAccessor.sharedInstance
     // MARK: Views

    @IBOutlet weak var karmaPointsLabel: UILabel!

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure score.
        do {
            let score = try dataSource.getScore()
            karmaPointsLabel.text = String(score.karmaPoints)
        } catch _ {
            // If the saving failed, show an alert dialogue.
            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingKarmaPoints, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
            self.present(alert, animated: true, completion: nil)

            return
        }
    }


}

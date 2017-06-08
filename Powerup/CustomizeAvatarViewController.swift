import UIKit

class CustomizeAvatarViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var customClothesView: UIImageView!
    @IBOutlet weak var customHairView: UIImageView!
    @IBOutlet weak var customFaceView: UIImageView!
    @IBOutlet weak var customEyesView: UIImageView!
    
    @IBOutlet weak var eyesExhibitionView: UIImageView!
    @IBOutlet weak var faceExhibitionView: UIImageView!
    @IBOutlet weak var hairExhibitionView: UIImageView!
    @IBOutlet weak var clothesExhibitionView: UIImageView!
    
    // MARK: Properties
    var chosenClothesIndex = 0
    var chosenFaceIndex = 0
    var chosenHairIndex = 0
    var chosenEyesIndex = 0
    
    var clothesImageNames = [String]()
    var faceImageNames = [String]()
    var hairImageNames = [String]()
    var eyesImageNames = [String]()

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch image names from database.
        clothesImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Clothes")
        faceImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Face")
        hairImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Hair")
        eyesImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Eyes")
        
        // Initialize the images of exhibition boxes and the avatar
        updateClothesImage()
        updateEyesImage()
        updateHairImage()
        updateFaceImage()
    }
    
    func updateClothesImage() {
        let imageName = clothesImageNames[chosenClothesIndex]
        clothesExhibitionView.image = UIImage(named: imageName)
        customClothesView.image = UIImage(named: imageName)
    }
    
    func updateEyesImage() {
        let imageName = eyesImageNames[chosenEyesIndex]
        eyesExhibitionView.image = UIImage(named: imageName)
        customEyesView.image = UIImage(named: imageName)
    }
    
    func updateHairImage() {
        let imageName = hairImageNames[chosenHairIndex]
        hairExhibitionView.image = UIImage(named: imageName)
        customHairView.image = UIImage(named: imageName)
    }
    
    func updateFaceImage() {
        let imageName = faceImageNames[chosenFaceIndex]
        faceExhibitionView.image = UIImage(named: imageName)
        customFaceView.image = UIImage(named: imageName)
    }
    
    // MARK: Actions
    @IBAction func eyesLeftButtonTouched(_ sender: UIButton) {
        let totalCount = eyesImageNames.count
        chosenEyesIndex = (chosenEyesIndex + totalCount - 1) % totalCount
        
        updateEyesImage()
    }
    
    @IBAction func eyesRightButtonTouched(_ sender: UIButton) {
        let totalCount = eyesImageNames.count
        chosenEyesIndex = (chosenEyesIndex + 1) % totalCount
        
        updateEyesImage()
    }
    
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        let totalCount = hairImageNames.count
        chosenHairIndex = (chosenHairIndex + totalCount - 1) % totalCount
        
        updateHairImage()
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        let totalCount = hairImageNames.count
        chosenHairIndex = (chosenHairIndex + 1) % totalCount
        
        updateHairImage()
    }
    
    @IBAction func faceLeftButtonTouched(_ sender: UIButton) {
        let totalCount = faceImageNames.count
        chosenFaceIndex = (chosenFaceIndex + totalCount - 1) % totalCount
        
        updateFaceImage()
    }
    
    @IBAction func faceRightButtonTouched(_ sender: UIButton) {
        let totalCount = faceImageNames.count
        chosenFaceIndex = (chosenFaceIndex + 1) % totalCount
        
        updateFaceImage()
    }
    
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        let totalCount = clothesImageNames.count
        chosenClothesIndex = (chosenClothesIndex + totalCount - 1) % totalCount
        
        updateClothesImage()
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        let totalCount = clothesImageNames.count
        chosenClothesIndex = (chosenClothesIndex + 1) % totalCount
        
        updateClothesImage()
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save the current configuration to database.
        guard DatabaseAccessor.sharedInstance().createAvatar(faceIndex: chosenFaceIndex, clothesIndex: chosenClothesIndex, hairIndex: chosenHairIndex, eyesIndex: chosenEyesIndex) else {
            print("Failed saving avatar accessories to database.")
            return
        }
        
        // Dismiss the modal VC
        self.dismiss(animated: true, completion: nil)
    }

}

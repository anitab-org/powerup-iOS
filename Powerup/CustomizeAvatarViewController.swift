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

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the images of exhibition boxes and the avatar
        updateClothesImage()
        updateEyesImage()
        updateHairImage()
        updateFaceImage()
    }
    
    func updateClothesImage() {
        let imageName = Customizables.clothes[chosenClothesIndex]
        clothesExhibitionView.image = UIImage(named: imageName)
        customClothesView.image = UIImage(named: imageName)
    }
    
    func updateEyesImage() {
        let imageName = Customizables.eyes[chosenEyesIndex]
        eyesExhibitionView.image = UIImage(named: imageName)
        customEyesView.image = UIImage(named: imageName)
    }
    
    func updateHairImage() {
        let imageName = Customizables.hairs[chosenHairIndex]
        hairExhibitionView.image = UIImage(named: imageName)
        customHairView.image = UIImage(named: imageName)
    }
    
    func updateFaceImage() {
        let imageName = Customizables.faces[chosenFaceIndex]
        faceExhibitionView.image = UIImage(named: imageName)
        customFaceView.image = UIImage(named: imageName)
    }
    
    // MARK: Actions
    @IBAction func eyesLeftButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.eyes.count
        chosenEyesIndex = (chosenEyesIndex + totalCount - 1) % totalCount
        
        updateEyesImage()
    }
    
    @IBAction func eyesRightButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.eyes.count
        chosenEyesIndex = (chosenEyesIndex + 1) % totalCount
        
        updateEyesImage()
    }
    
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.hairs.count
        chosenHairIndex = (chosenHairIndex + totalCount - 1) % totalCount
        
        updateHairImage()
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.hairs.count
        chosenHairIndex = (chosenHairIndex + 1) % totalCount
        
        updateHairImage()
    }
    
    @IBAction func faceLeftButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.faces.count
        chosenFaceIndex = (chosenFaceIndex + totalCount - 1) % totalCount
        
        updateFaceImage()
    }
    
    @IBAction func faceRightButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.faces.count
        chosenFaceIndex = (chosenFaceIndex + 1) % totalCount
        
        updateFaceImage()
    }
    
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.clothes.count
        chosenClothesIndex = (chosenClothesIndex + totalCount - 1) % totalCount
        
        updateClothesImage()
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        let totalCount = Customizables.clothes.count
        chosenClothesIndex = (chosenClothesIndex + 1) % totalCount
        
        updateClothesImage()
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save the current configuration to UserDefaults (Should be changed after Firebase integration)
        let configuration = [
            "eyes": chosenEyesIndex,
            "hair": chosenHairIndex,
            "clothes": chosenClothesIndex,
            "face": chosenFaceIndex,
        ]
        UserDefaults.standard.set(configuration, forKey: Customizables.avatarKey)
        
        // Dismiss the modal VC
        self.dismiss(animated: true, completion: nil)
    }

}

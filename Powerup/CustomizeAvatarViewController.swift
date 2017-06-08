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
    var avatar = Avatar()
    
    var chosenClothesIndex = 0
    var chosenEyesIndex = 0
    var chosenHairIndex = 0
    var chosenFaceIndex = 0
    
    // Get arrays of accessories.
    let clothes = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Clothes")
    let faces = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Face")
    let hairs = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Hair")
    let eyes = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Eyes")

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
        avatar.clothes = clothes[chosenClothesIndex]
        
        let clothesImage = avatar.clothes.image
        clothesExhibitionView.image = clothesImage
        customClothesView.image = clothesImage
    }
    
    func updateEyesImage() {
        avatar.eyes = eyes[chosenEyesIndex]
        
        let eyesImage = avatar.eyes.image
        eyesExhibitionView.image = eyesImage
        customEyesView.image = eyesImage
    }
    
    func updateHairImage() {
        avatar.hair = hairs[chosenHairIndex]
        
        let hairImage = avatar.hair.image
        hairExhibitionView.image = hairImage
        customHairView.image = hairImage
    }
    
    func updateFaceImage() {
        avatar.face = faces[chosenFaceIndex]
        
        let faceImage = avatar.face.image
        faceExhibitionView.image = faceImage
        customFaceView.image = faceImage
    }
    
    // MARK: Actions
    @IBAction func eyesLeftButtonTouched(_ sender: UIButton) {
        let totalCount = eyes.count
        chosenEyesIndex = (chosenEyesIndex + totalCount - 1) % totalCount
        
        updateEyesImage()
    }
    
    @IBAction func eyesRightButtonTouched(_ sender: UIButton) {
        let totalCount = eyes.count
        chosenEyesIndex = (chosenEyesIndex + 1) % totalCount
        
        updateEyesImage()
    }
    
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        let totalCount = hairs.count
        chosenHairIndex = (chosenHairIndex + totalCount - 1) % totalCount
        
        updateHairImage()
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        let totalCount = hairs.count
        chosenHairIndex = (chosenHairIndex + 1) % totalCount
        
        updateHairImage()
    }
    
    @IBAction func faceLeftButtonTouched(_ sender: UIButton) {
        let totalCount = faces.count
        chosenFaceIndex = (chosenFaceIndex + totalCount - 1) % totalCount
        
        updateFaceImage()
    }
    
    @IBAction func faceRightButtonTouched(_ sender: UIButton) {
        let totalCount = faces.count
        chosenFaceIndex = (chosenFaceIndex + 1) % totalCount
        
        updateFaceImage()
    }
    
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        let totalCount = clothes.count
        chosenClothesIndex = (chosenClothesIndex + totalCount - 1) % totalCount
        
        updateClothesImage()
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        let totalCount = clothes.count
        chosenClothesIndex = (chosenClothesIndex + 1) % totalCount
        
        updateClothesImage()
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save the current configuration to database.
        guard DatabaseAccessor.sharedInstance().createAvatar(avatar) else {
            print("Failed saving avatar accessories to database.")
            return
        }
        
        // Dismiss the modal VC
        self.dismiss(animated: true, completion: nil)
    }

}

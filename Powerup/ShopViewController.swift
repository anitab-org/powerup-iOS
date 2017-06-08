import UIKit

class ShopViewController: UIViewController {

    // MARK: Properties
    // The indices of exhibition accessories.
    var chosenBagIndex = 0
    var chosenGlassesIndex = 0
    var chosenHatIndex = 0
    var chosenNecklaceIndex = 0
    var chosenHairIndex = 0
    var chosenClothesIndex = 0
    
    // The indices of the accessories on the avatar.
    var boughtBagIndex: Int? = nil
    var boughtGlassesIndex: Int? = nil
    var boughtHatIndex: Int? = nil
    var boughtNecklaceIndex: Int? = nil
    var boughtHairIndex = 0
    var boughtClothesIndex = 0
    var boughtEyesIndex = 0
    var boughtFaceIndex = 0
    
    
    var bagImageNames = [String]()
    var glassesImageNames = [String]()
    var hatImageNames = [String]()
    var necklaceImageNames = [String]()
    var hairImageNames = [String]()
    var clothesImageNames = [String]()
    
    // MARK: Views
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var handbagLabel: UILabel!
    @IBOutlet weak var handbagPaidLabel: UILabel!
    @IBOutlet weak var glassesLabel: UILabel!
    @IBOutlet weak var glassesPaidLabel: UILabel!
    @IBOutlet weak var hatLabel: UILabel!
    @IBOutlet weak var hatPaidLabel: UILabel!
    @IBOutlet weak var necklaceLabel: UILabel!
    @IBOutlet weak var necklacePaidLabel: UILabel!
    @IBOutlet weak var hairPaidLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var clothesPaidLabel: UILabel!
    @IBOutlet weak var clothesLabel: UILabel!
    
    @IBOutlet weak var exhibitionHandbag: UIImageView!
    @IBOutlet weak var exhibitionGlasses: UIImageView!
    @IBOutlet weak var exhibitionHat: UIImageView!
    @IBOutlet weak var exhibitionNecklace: UIImageView!
    @IBOutlet weak var exhibitionHair: UIImageView!
    @IBOutlet weak var exhibitionClothes: UIImageView!

    @IBOutlet weak var avatarEyesView: UIImageView!
    @IBOutlet weak var avatarHairView: UIImageView!
    @IBOutlet weak var avatarFaceView: UIImageView!
    @IBOutlet weak var avatarClothesView: UIImageView!
    @IBOutlet weak var avatarHandbagView: UIImageView!
    @IBOutlet weak var avatarGlassesView: UIImageView!
    @IBOutlet weak var avatarHatView: UIImageView!
    @IBOutlet weak var avatarNecklaceView: UIImageView!
    
    // MARK: Functions
    func configureAvatar() {
        let avatarConfig = DatabaseAccessor.sharedInstance().getAvatar()
        
        // Clothes
        let (clothesIndex, clothesName) = avatarConfig["Clothes"]!
        avatarClothesView.image = UIImage(named: clothesName)
        chosenClothesIndex = clothesIndex
        boughtClothesIndex = clothesIndex
        
        // Face
        let (faceIndex, faceName) = avatarConfig["Face"]!
        avatarFaceView.image = UIImage(named: faceName)
        boughtFaceIndex = faceIndex
        
        // Hair
        let (hairIndex, hairName) = avatarConfig["Hair"]!
        avatarHairView.image = UIImage(named: hairName)
        chosenHairIndex = hairIndex
        boughtHairIndex = hairIndex
        
        // Eyes
        let (eyesIndex, eyesName) = avatarConfig["Eyes"]!
        avatarEyesView.image = UIImage(named: eyesName)
        boughtEyesIndex = eyesIndex
        
        // Optional accessories
        // Handbag
        if let (handbagIndex, handbagName) = avatarConfig["Handbag"] {
            avatarHandbagView.image = UIImage(named: handbagName)
            chosenBagIndex = handbagIndex
            boughtBagIndex = handbagIndex
        } else {
            avatarHandbagView.image = nil
        }
        
        // Glasses
        if let (glassesIndex, glassesName) = avatarConfig["Glasses"] {
            avatarGlassesView.image = UIImage(named: glassesName)
            chosenGlassesIndex = glassesIndex
            boughtGlassesIndex = glassesIndex
        } else {
            avatarGlassesView.image = nil
        }
        
        // Necklace
        if let (necklaceIndex, necklaceName) = avatarConfig["Necklace"] {
            avatarNecklaceView.image = UIImage(named: necklaceName)
            chosenNecklaceIndex = necklaceIndex
            boughtNecklaceIndex = necklaceIndex
        } else {
            avatarNecklaceView.image = nil
        }
        
        // Hat
        if let (hatIndex, hatName) = avatarConfig["Hat"] {
            avatarHatView.image = UIImage(named: hatName)
            chosenHatIndex = hatIndex
            boughtHatIndex = hatIndex
        } else {
            avatarHatView.image = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAvatar()
        
        // Fetch accessory names for database.
        bagImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Handbag")
        glassesImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Glasses")
        hatImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Hat")
        necklaceImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Necklace")
        hairImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Hair")
        clothesImageNames = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryName: "Clothes")
        
        // Configure exhibition image.
        exhibitionHandbag.image = UIImage(named: bagImageNames[chosenBagIndex])
        exhibitionGlasses.image = UIImage(named: glassesImageNames[chosenGlassesIndex])
        exhibitionHat.image = UIImage(named: hatImageNames[chosenHatIndex])
        exhibitionNecklace.image = UIImage(named: necklaceImageNames[chosenHatIndex])
        exhibitionHair.image = UIImage(named: hairImageNames[chosenHairIndex])
        exhibitionClothes.image = UIImage(named: clothesImageNames[chosenClothesIndex])
    }

    // MARK: Actions
    // Handbag
    @IBAction func handbagLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = bagImageNames.count
        chosenBagIndex = (chosenBagIndex + totalCount - 1) % totalCount
        
        // Update exhibition image
        exhibitionHandbag.image = UIImage(named: bagImageNames[chosenBagIndex])
    }
    
    @IBAction func handbagRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = bagImageNames.count
        chosenBagIndex = (chosenBagIndex + 1) % totalCount
        
        // Update exhibition image
        exhibitionHandbag.image = UIImage(named: bagImageNames[chosenBagIndex])
    }
    
    @IBAction func handbagBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        boughtBagIndex = chosenBagIndex
        
        // Update avatar
        avatarHandbagView.image = UIImage(named: bagImageNames[chosenBagIndex])
    }
    
    // Glasses
    @IBAction func glassesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glassesImageNames.count
        chosenGlassesIndex = (chosenGlassesIndex + totalCount - 1) % totalCount
        
        // Update glasses image
        exhibitionGlasses.image = UIImage(named: glassesImageNames[chosenGlassesIndex])
    }
    
    @IBAction func glassesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glassesImageNames.count
        chosenGlassesIndex = (chosenGlassesIndex + 1) % totalCount
        
        // Update glasses image
        exhibitionGlasses.image = UIImage(named: glassesImageNames[chosenGlassesIndex])
    }
    
    @IBAction func glassesBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        boughtGlassesIndex = chosenGlassesIndex
        
        // Update avatar
        avatarGlassesView.image = UIImage(named: glassesImageNames[chosenGlassesIndex])
    }
    
    // Hat
    @IBAction func hatLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hatImageNames.count
        chosenHatIndex = (chosenHatIndex + totalCount - 1) % totalCount
        
        // Update hat image
        exhibitionHat.image = UIImage(named: hatImageNames[chosenHatIndex])
    }
    
    @IBAction func hatRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hatImageNames.count
        chosenHatIndex = (chosenHatIndex + 1) % totalCount
        
        // Update hat image
        exhibitionHat.image = UIImage(named: hatImageNames[chosenHatIndex])
    }
    
    @IBAction func hatBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        boughtHatIndex = chosenHatIndex
        
        // Update avatar
        avatarHatView.image = UIImage(named: hatImageNames[chosenHatIndex])
    }
    
    // Necklace
    @IBAction func necklaceLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaceImageNames.count
        chosenNecklaceIndex = (chosenNecklaceIndex + totalCount - 1) % totalCount
        
        // Update necklace image
        exhibitionNecklace.image = UIImage(named: necklaceImageNames[chosenNecklaceIndex])
    }
    
    @IBAction func necklaceRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaceImageNames.count
        chosenNecklaceIndex = (chosenNecklaceIndex + 1) % totalCount
        
        // Update necklace image
        exhibitionNecklace.image = UIImage(named: necklaceImageNames[chosenNecklaceIndex])
    }
    
    @IBAction func necklaceBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        boughtNecklaceIndex = chosenNecklaceIndex
        
        // Update avatar
        avatarNecklaceView.image = UIImage(named: necklaceImageNames[chosenNecklaceIndex])
    }
    
    // Hair
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairImageNames.count
        chosenHairIndex = (chosenHairIndex + totalCount - 1) % totalCount
        
        // Update hair image
        exhibitionHair.image = UIImage(named: hairImageNames[chosenHairIndex])
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairImageNames.count
        chosenHairIndex = (chosenHairIndex + 1) % totalCount
        
        // Update hair image
        exhibitionHair.image = UIImage(named: hairImageNames[chosenHairIndex])
    }
    
    @IBAction func hairBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        boughtHairIndex = chosenHairIndex
        
        // Update avatar
        avatarHairView.image = UIImage(named: hairImageNames[chosenHairIndex])
    }
    
    // Clothes
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothesImageNames.count
        chosenClothesIndex = (chosenClothesIndex + totalCount - 1) % totalCount
        
        // Update clothes
        exhibitionClothes.image = UIImage(named: clothesImageNames[chosenClothesIndex])
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothesImageNames.count
        chosenClothesIndex = (chosenClothesIndex + 1) % totalCount
        
        // Update clothes
        exhibitionClothes.image = UIImage(named: clothesImageNames[chosenClothesIndex])
    }
    
    @IBAction func clothesBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karm points
        
        boughtClothesIndex = chosenClothesIndex
        
        // Update avatar
        avatarClothesView.image = UIImage(named: clothesImageNames[chosenClothesIndex])
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save configuration to database.
        guard DatabaseAccessor.sharedInstance().saveAvatar(faceIndex: boughtFaceIndex, clothesIndex: boughtClothesIndex, hairIndex: boughtHairIndex, eyesIndex: boughtEyesIndex, necklaceIndex: boughtNecklaceIndex, glassesIndex: boughtGlassesIndex, handbagIndex: boughtBagIndex, hatIndex: boughtHatIndex) else {
            print("Failed saving bought items to database.")
            return
        }
        
        //Dismiss this VC
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        // Quit without saving
        self.dismiss(animated: true, completion: nil)
    }
}

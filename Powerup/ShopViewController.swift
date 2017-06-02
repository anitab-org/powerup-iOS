import UIKit

class ShopViewController: UIViewController {

    // MARK: Properties
    var chosenBagIndex = 0
    var chosenGlassesIndex = 0
    var chosenHatIndex = 0
    var chosenNecklaceIndex = 0
    var chosenHairIndex = 0
    var chosenClothesIndex = 0
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize avatar images
        Customizables.applyCustomizables(clothes: avatarClothesView, face: avatarFaceView, hair: avatarHairView, eyes: avatarEyesView, handBag: avatarHandbagView, glasses: avatarGlassesView, necklace: avatarNecklaceView, hat: avatarHatView)
        
        // Initialize exhibition images
        exhibitionHandbag.image = UIImage(named: Customizables.handbags[chosenBagIndex])
        exhibitionGlasses.image = UIImage(named: Customizables.glasses[chosenGlassesIndex])
        exhibitionHat.image = UIImage(named: Customizables.hats[chosenHatIndex])
        exhibitionNecklace.image = UIImage(named: Customizables.necklace[chosenHatIndex])
        exhibitionHair.image = UIImage(named: Customizables.hairs[chosenHairIndex])
        exhibitionClothes.image = UIImage(named: Customizables.clothes[chosenClothesIndex])
    }

    // MARK: Actions
    // Handbag
    @IBAction func handbagLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.handbags.count
        chosenBagIndex = (chosenBagIndex + totalCount - 1) % totalCount
        
        // Update exhibition image
        exhibitionHandbag.image = UIImage(named: Customizables.handbags[chosenBagIndex])
    }
    
    @IBAction func handbagRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.handbags.count
        chosenBagIndex = (chosenBagIndex + 1) % totalCount
        
        // Update exhibition image
        exhibitionHandbag.image = UIImage(named: Customizables.handbags[chosenBagIndex])
    }
    
    @IBAction func handbagBuyButtonTouched(_ sender: UIButton) {
        // Reduce Karma points
        
        // Update avatar
        avatarHandbagView.image = UIImage(named: Customizables.handbags[chosenBagIndex])
    }
    
    // Glasses
    @IBAction func glassesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.glasses.count
        chosenGlassesIndex = (chosenGlassesIndex + totalCount - 1) % totalCount
        
        // Update glasses image
        exhibitionGlasses.image = UIImage(named: Customizables.glasses[chosenGlassesIndex])
    }
    
    @IBAction func glassesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.glasses.count
        chosenGlassesIndex = (chosenGlassesIndex + 1) % totalCount
        
        // Update glasses image
        exhibitionGlasses.image = UIImage(named: Customizables.glasses[chosenGlassesIndex])
    }
    
    @IBAction func glassesBuyButtonTouched(_ sender: UIButton) {
        // Reduce Karma points
        
        // Update avatar
        avatarGlassesView.image = UIImage(named: Customizables.glasses[chosenGlassesIndex])
    }
    
    // Hat
    @IBAction func hatLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.hats.count
        chosenHatIndex = (chosenHatIndex + totalCount - 1) % totalCount
        
        // Update hat image
        exhibitionHat.image = UIImage(named: Customizables.hats[chosenHatIndex])
    }
    
    @IBAction func hatRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.hats.count
        chosenHatIndex = (chosenHatIndex + 1) % totalCount
        
        // Update hat image
        exhibitionHat.image = UIImage(named: Customizables.hats[chosenHatIndex])
    }
    
    @IBAction func hatBuyButtonTouched(_ sender: UIButton) {
        // Reduce Karma points
        
        // Update avatar
        avatarHatView.image = UIImage(named: Customizables.hats[chosenHatIndex])
    }
    
    // Necklace
    @IBAction func necklaceLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.necklace.count
        chosenNecklaceIndex = (chosenNecklaceIndex + totalCount - 1) % totalCount
        
        // Update necklace image
        exhibitionNecklace.image = UIImage(named: Customizables.necklace[chosenNecklaceIndex])
    }
    
    @IBAction func necklaceRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.necklace.count
        chosenNecklaceIndex = (chosenNecklaceIndex + 1) % totalCount
        
        // Update necklace image
        exhibitionNecklace.image = UIImage(named: Customizables.necklace[chosenNecklaceIndex])
    }
    
    @IBAction func necklaceBuyButtonTouched(_ sender: UIButton) {
        // Reduce Karma points
        
        // Update avatar
        avatarNecklaceView.image = UIImage(named: Customizables.necklace[chosenNecklaceIndex])
    }
    
    // Hair
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.hairs.count
        chosenHairIndex = (chosenHairIndex + totalCount - 1) % totalCount
        
        // Update hair image
        exhibitionHair.image = UIImage(named: Customizables.hairs[chosenHairIndex])
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.hairs.count
        chosenHairIndex = (chosenHairIndex + 1) % totalCount
        
        // Update hair image
        exhibitionHair.image = UIImage(named: Customizables.hairs[chosenHairIndex])
    }
    
    @IBAction func hairBuyButtonTouched(_ sender: UIButton) {
        // Reduce Karma points
        
        // Update avatar
        avatarHairView.image = UIImage(named: Customizables.hairs[chosenHairIndex])
    }
    
    // Clothes
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.clothes.count
        chosenClothesIndex = (chosenClothesIndex + totalCount - 1) % totalCount
        
        // Update clothes
        exhibitionClothes.image = UIImage(named: Customizables.clothes[chosenClothesIndex])
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = Customizables.clothes.count
        chosenClothesIndex = (chosenClothesIndex + 1) % totalCount
        
        // Update clothes
        exhibitionClothes.image = UIImage(named: Customizables.clothes[chosenClothesIndex])
    }
    
    @IBAction func clothesBuyButtonTouched(_ sender: UIButton) {
        // Reduce Karm points
        
        // Update avatar
        avatarClothesView.image = UIImage(named: Customizables.clothes[chosenClothesIndex])
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save and quit
        let dictionaryKey = Customizables.avatarKey
        
        if var currConfig = UserDefaults.standard.dictionary(forKey: dictionaryKey) {
            // Configure
            currConfig["handbag"] = chosenBagIndex
            currConfig["glasses"] = chosenGlassesIndex
            currConfig["hat"] = chosenHatIndex
            currConfig["necklace"] = chosenNecklaceIndex
            currConfig["hair"] = chosenHairIndex
            currConfig["clothes"] = chosenClothesIndex
            
            // Save
            UserDefaults.standard.set(currConfig, forKey: dictionaryKey)
        } else {
            print("Error saving avatar data")
        }
        
        //Dismiss this VC
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        // Quit without saving
        self.dismiss(animated: true, completion: nil)
    }
}

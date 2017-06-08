import UIKit

class ShopViewController: UIViewController {

    // MARK: Properties
    // The indices of exhibition accessories.
    var exhibitionBagIndex = 0
    var exhibitionGlassesIndex = 0
    var exhibitionHatIndex = 0
    var exhibitionNecklaceIndex = 0
    var exhibitionHairIndex = 0
    var exhibitionClothesIndex = 0
    
    // The displayed avatar.
    var avatar = DatabaseAccessor.sharedInstance().getAvatar()
    
    // Array of accessories.
    let handbags = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Handbag")
    let glasses = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Glasses")
    let hats = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Hat")
    let necklaces = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Necklace")
    let hairs = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Hair")
    let clothes = DatabaseAccessor.sharedInstance().getAccessoryArray(accessoryType: "Clothes")
    
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
        
        // Configure Image Views of Avatar Accessories.
        avatarClothesView.image = avatar.clothes.image
        avatarFaceView.image = avatar.face.image
        avatarEyesView.image = avatar.eyes.image
        avatarHairView.image = avatar.hair.image
        avatarHandbagView.image = avatar.handbag?.image
        avatarGlassesView.image = avatar.glasses?.image
        avatarNecklaceView.image = avatar.necklace?.image
        avatarHatView.image = avatar.hat?.image
        
        // Configure exhibition image.
        exhibitionHandbag.image = handbags[exhibitionBagIndex].image
        exhibitionGlasses.image = glasses[exhibitionGlassesIndex].image
        exhibitionHat.image = hats[exhibitionHatIndex].image
        exhibitionNecklace.image = necklaces[exhibitionNecklaceIndex].image
        exhibitionHair.image = hairs[exhibitionHairIndex].image
        exhibitionClothes.image = clothes[exhibitionClothesIndex].image
    }

    // MARK: Actions
    // Handbag
    @IBAction func handbagLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = handbags.count
        exhibitionBagIndex = (exhibitionBagIndex + totalCount - 1) % totalCount
        
        // Update exhibition image
        exhibitionHandbag.image = handbags[exhibitionBagIndex].image
    }
    
    @IBAction func handbagRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = handbags.count
        exhibitionBagIndex = (exhibitionBagIndex + 1) % totalCount
        
        // Update exhibition image
        exhibitionHandbag.image = handbags[exhibitionBagIndex].image
    }
    
    @IBAction func handbagBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        // Update avatar
        avatar.handbag = handbags[exhibitionBagIndex]
        avatarHandbagView.image = avatar.handbag!.image
    }
    
    // Glasses
    @IBAction func glassesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glasses.count
        exhibitionGlassesIndex = (exhibitionGlassesIndex + totalCount - 1) % totalCount
        
        // Update glasses image
        exhibitionGlasses.image = glasses[exhibitionGlassesIndex].image
    }
    
    @IBAction func glassesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glasses.count
        exhibitionGlassesIndex = (exhibitionGlassesIndex + 1) % totalCount
        
        // Update glasses image
        exhibitionGlasses.image = glasses[exhibitionGlassesIndex].image
    }
    
    @IBAction func glassesBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        
        // Update avatar
        avatar.glasses = glasses[exhibitionGlassesIndex]
        avatarGlassesView.image = avatar.glasses!.image
    }
    
    // Hat
    @IBAction func hatLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hats.count
        exhibitionHatIndex = (exhibitionHatIndex + totalCount - 1) % totalCount
        
        // Update hat image
        exhibitionHat.image = hats[exhibitionHatIndex].image
    }
    
    @IBAction func hatRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hats.count
        exhibitionHatIndex = (exhibitionHatIndex + 1) % totalCount
        
        // Update hat image
        exhibitionHat.image = hats[exhibitionHatIndex].image
    }
    
    @IBAction func hatBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        // Update avatar
        avatar.hat = hats[exhibitionHatIndex]
        avatarHatView.image = avatar.hat!.image
    }
    
    // Necklace
    @IBAction func necklaceLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaces.count
        exhibitionNecklaceIndex = (exhibitionNecklaceIndex + totalCount - 1) % totalCount
        
        // Update necklace image
        exhibitionNecklace.image = necklaces[exhibitionNecklaceIndex].image
    }
    
    @IBAction func necklaceRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaces.count
        exhibitionNecklaceIndex = (exhibitionNecklaceIndex + 1) % totalCount
        
        // Update necklace image
        exhibitionNecklace.image = necklaces[exhibitionNecklaceIndex].image
    }
    
    @IBAction func necklaceBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        // Update avatar
        avatar.necklace = necklaces[exhibitionNecklaceIndex]
        avatarNecklaceView.image = avatar.necklace!.image
    }
    
    // Hair
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairs.count
        exhibitionHairIndex = (exhibitionHairIndex + totalCount - 1) % totalCount
        
        // Update hair image
        exhibitionHair.image = hairs[exhibitionHairIndex].image
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairs.count
        exhibitionHairIndex = (exhibitionHairIndex + 1) % totalCount
        
        // Update hair image
        exhibitionHair.image = hairs[exhibitionHairIndex].image
    }
    
    @IBAction func hairBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karma points
        
        // Update avatar
        avatar.hair = hairs[exhibitionHairIndex]
        avatarHairView.image = avatar.hair.image
    }
    
    // Clothes
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothes.count
        exhibitionClothesIndex = (exhibitionClothesIndex + totalCount - 1) % totalCount
        
        // Update clothes
        exhibitionClothes.image = clothes[exhibitionClothesIndex].image
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothes.count
        exhibitionClothesIndex = (exhibitionClothesIndex + 1) % totalCount
        
        // Update clothes
        exhibitionClothes.image = clothes[exhibitionClothesIndex].image
    }
    
    @IBAction func clothesBuyButtonTouched(_ sender: UIButton) {
        // TODO: Reduce Karm points
        
        // Update avatar
        avatar.clothes = clothes[exhibitionClothesIndex]
        avatarClothesView.image = avatar.clothes.image
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        // Save configuration to database.
        guard DatabaseAccessor.sharedInstance().saveAvatar(avatar) else {
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

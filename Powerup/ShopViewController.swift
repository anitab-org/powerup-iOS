import UIKit

class ShopViewController: UIViewController {
    
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // The indices of exhibition accessories.
    var exhibitionBagIndex = 0
    var exhibitionGlassesIndex = 0
    var exhibitionHatIndex = 0
    var exhibitionNecklaceIndex = 0
    var exhibitionHairIndex = 0
    var exhibitionClothesIndex = 0
    
    // The total cost of the accessories worn (excluding the purchased ones).
    var totalCost = 0
    
    // The score of the avatar.
    var score: Score!
    
    // The displayed avatar.
    var avatar: Avatar!
    
    // For reverting.
    var originalAvatar: Avatar!
    
    // Array of accessories.
    var handbags: [Accessory]!
    var glasses: [Accessory]!
    var hats: [Accessory]!
    var necklaces: [Accessory]!
    var hairs: [Accessory]!
    var clothes: [Accessory]!
    
    // MARK: Views
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    @IBOutlet weak var handbagPaidLabel: UILabel!
    @IBOutlet weak var glassesPaidLabel: UILabel!
    @IBOutlet weak var hatPaidLabel: UILabel!
    @IBOutlet weak var necklacePaidLabel: UILabel!
    @IBOutlet weak var hairPaidLabel: UILabel!
    @IBOutlet weak var clothesPaidLabel: UILabel!
    
    @IBOutlet weak var exhibitionHandbag: UIImageView!
    @IBOutlet weak var exhibitionGlasses: UIImageView!
    @IBOutlet weak var exhibitionHat: UIImageView!
    @IBOutlet weak var exhibitionNecklace: UIImageView!
    @IBOutlet weak var exhibitionHair: UIImageView!
    @IBOutlet weak var exhibitionClothes: UIImageView!
    
    @IBOutlet weak var handbagPriceLabel: UILabel!
    @IBOutlet weak var hatPriceLabel: UILabel!
    @IBOutlet weak var glassesPriceLabel: UILabel!
    @IBOutlet weak var necklacePriceLabel: UILabel!
    @IBOutlet weak var hairPriceLabel: UILabel!
    @IBOutlet weak var clothesPriceLabel: UILabel!
    
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
        
        // Fetch the accessory arrays from the database.
        handbags = dataSource.getAccessoryArray(accessoryType: .handbag)
        glasses = dataSource.getAccessoryArray(accessoryType: .glasses)
        hats = dataSource.getAccessoryArray(accessoryType: .hat)
        necklaces = dataSource.getAccessoryArray(accessoryType: .necklace)
        hairs = dataSource.getAccessoryArray(accessoryType: .hair)
        clothes = dataSource.getAccessoryArray(accessoryType: .clothes)
        
        // Fetch avatar and score from database.
        do {
            score = try dataSource.getScore()
            avatar = try dataSource.getAvatar()
        } catch _ {
            let alert = UIAlertController(title: "Warning", message: "Error fetching avatar and score data, please retry this action. If that doesn't help, try restarting or reinstalling the app.", preferredStyle: .alert)
            
            // Exit shop when ok button is pressed.
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)})
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Save the original avatar for reverting.
        originalAvatar = avatar
        
        // Set Karma points
        pointsLabel.text = String(score.karmaPoints)
        
        // Configure Image Views of Avatar Accessories.
        avatarClothesView.image = avatar.clothes.image
        avatarFaceView.image = avatar.face.image
        avatarEyesView.image = avatar.eyes.image
        avatarHairView.image = avatar.hair.image
        avatarHandbagView.image = avatar.handbag?.image
        avatarGlassesView.image = avatar.glasses?.image
        avatarNecklaceView.image = avatar.necklace?.image
        avatarHatView.image = avatar.hat?.image
        
        // Configure exhibition image and paid label.
        updateHandbagExhibition()
        updateHatExhibition()
        updateGlassesExhibition()
        updateNecklaceExhibition()
        updateHairExhibition()
        updateClothesExhibition()
    }
    
    func updateHandbagExhibition() {
        let handbag = handbags[exhibitionBagIndex]
        exhibitionHandbag.image = handbag.image
        handbagPaidLabel.isHidden = !handbag.purchased
        handbagPriceLabel.text = "\(handbag.points)$"
    }
    
    func updateGlassesExhibition() {
        let glass = glasses[exhibitionGlassesIndex]
        exhibitionGlasses.image = glass.image
        glassesPaidLabel.isHidden = !glass.purchased
        glassesPriceLabel.text = "\(glass.points)$"
    }
    
    func updateHatExhibition() {
        let hat = hats[exhibitionHatIndex]
        exhibitionHat.image = hat.image
        hatPaidLabel.isHidden = !hat.purchased
        hatPriceLabel.text = "\(hat.points)$"
    }
    
    func updateNecklaceExhibition() {
        let necklace = necklaces[exhibitionNecklaceIndex]
        exhibitionNecklace.image = necklace.image
        necklacePaidLabel.isHidden = !necklace.purchased
        necklacePriceLabel.text = "\(necklace.points)$"
    }
    
    func updateHairExhibition() {
        let hair = hairs[exhibitionHairIndex]
        exhibitionHair.image = hair.image
        hairPaidLabel.isHidden = !hair.purchased
        hairPriceLabel.text = "\(hair.points)$"
    }
    
    func updateClothesExhibition() {
        let cloth = clothes[exhibitionClothesIndex]
        exhibitionClothes.image = cloth.image
        clothesPaidLabel.isHidden = !cloth.purchased
        clothesPriceLabel.text = "\(cloth.points)$"
    }
    
    func reducePointsAndSaveBoughtToDatabase(accessory: Accessory) throws {
        let newScore = try dataSource.getScore() - Score(karmaPoints: accessory.points)
        
        // Update points label.
        pointsLabel.text = String(newScore.karmaPoints)
        
        // Reduce points.
        try dataSource.saveScore(score: newScore)
        
        // Set as purchased.
        try dataSource.boughtAccessory(accessory: accessory)
    }
    
    func haveEnoughPointsToBuy(accessoryPrice: Int) throws -> Bool {
        
        // Show alert dialog if players are trying to buy items they can't afford.
        if try dataSource.getScore().karmaPoints < accessoryPrice {
            let alertDialog = UIAlertController(title: "Oops!", message: "You don't have enough points to buy that!", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Alright", style: .default))
            self.present(alertDialog, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func presentBuyingErrorDiaologue() {
        let alert = UIAlertController(title: "Warning", message: "Error purchasing item, please retry this action. If that doesn't help, try restarting or reinstalling the app.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateTotalCostLabel() {
        totalCostLabel.text = "Total Cost: \(totalCost)$"
    }

    // MARK: Actions
    // Handbag
    @IBAction func handbagLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = handbags.count
        exhibitionBagIndex = (exhibitionBagIndex + totalCount - 1) % totalCount
        
        updateHandbagExhibition()
    }
    
    @IBAction func handbagRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = handbags.count
        exhibitionBagIndex = (exhibitionBagIndex + 1) % totalCount
        
        updateHandbagExhibition()
    }
    
    @IBAction func handbagBuyButtonTouched(_ sender: UIButton) {
        
        let handbagChosen = handbags[exhibitionBagIndex]
        
        // Check if already worn.
        if avatar.handbag != nil && handbagChosen.id == avatar.handbag!.id {
            
            // If already worn, unwear it.
            avatar.handbag = nil
            avatarHandbagView.image = nil
            
            // Deduct the price from the total cost if it isn't purchased yet.
            if !handbagChosen.purchased {
                totalCost -= handbagChosen.points
            }
            
        } else {
            // Not worn yet.
            
            // Deduct the price of previous worn accessory from the total cost if it isn't purchased.
            if avatar.handbag != nil && !avatar.handbag!.purchased {
                totalCost -= avatar.handbag!.points
            }
            
            // Wear it.
            avatar.handbag = handbagChosen
            avatarHandbagView.image = handbagChosen.image
            
            // Add the price to the total cost if it isn't purchased yet.
            if !handbagChosen.purchased {
                totalCost += handbagChosen.points
            }
        }
        
        updateTotalCostLabel()
    }
    
    // Glasses
    @IBAction func glassesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glasses.count
        exhibitionGlassesIndex = (exhibitionGlassesIndex + totalCount - 1) % totalCount
        
        updateGlassesExhibition()
    }
    
    @IBAction func glassesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = glasses.count
        exhibitionGlassesIndex = (exhibitionGlassesIndex + 1) % totalCount
        
        updateGlassesExhibition()
    }
    
    @IBAction func glassesBuyButtonTouched(_ sender: UIButton) {
        
        let glassesChosen = glasses[exhibitionGlassesIndex]
        
        // Check if already worn.
        if avatar.glasses != nil && glassesChosen.id == avatar.glasses!.id {
            
            // If already worn, unwear it.
            avatar.glasses = nil
            avatarGlassesView.image = nil
            
            // Deduct the price from the total cost if it isn't purchased yet.
            if !glassesChosen.purchased {
                totalCost -= glassesChosen.points
            }
            
        } else {
            // Not worn yet.
            
            // Deduct the price of previous worn accessory from the total cost if it isn't purchased.
            if avatar.glasses != nil && !avatar.glasses!.purchased {
                totalCost -= avatar.glasses!.points
            }
            
            // Wear it.
            avatar.glasses = glassesChosen
            avatarGlassesView.image = glassesChosen.image
            
            // Add the price to the total cost if it isn't purchased yet.
            if !glassesChosen.purchased {
                totalCost += glassesChosen.points
            }
        }
        
        updateTotalCostLabel()
    }
    
    // Hat
    @IBAction func hatLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hats.count
        exhibitionHatIndex = (exhibitionHatIndex + totalCount - 1) % totalCount
        
        updateHatExhibition()
    }
    
    @IBAction func hatRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hats.count
        exhibitionHatIndex = (exhibitionHatIndex + 1) % totalCount
        
        updateHatExhibition()
    }
    
    @IBAction func hatBuyButtonTouched(_ sender: UIButton) {
        
        let hatChosen = hats[exhibitionHatIndex]
        
        // Check if already worn.
        if avatar.hat != nil && hatChosen.id == avatar.hat!.id {
            
            // If already worn, unwear it.
            avatar.hat = nil
            avatarHatView.image = nil
            
            // Deduct the price from the total cost if it isn't purchased yet.
            if !hatChosen.purchased {
                totalCost -= hatChosen.points
            }
            
        } else {
            // Not worn yet.
            
            // Deduct the price of previous worn accessory from the total cost if it isn't purchased.
            if avatar.hat != nil && !avatar.hat!.purchased {
                totalCost -= avatar.hat!.points
            }
            
            // Wear it.
            avatar.hat = hatChosen
            avatarHatView.image = hatChosen.image
            
            // Add the price to the total cost if it isn't purchased yet.
            if !hatChosen.purchased {
                totalCost += hatChosen.points
            }
        }
        
        updateTotalCostLabel()
        
    }
    
    // Necklace
    @IBAction func necklaceLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaces.count
        exhibitionNecklaceIndex = (exhibitionNecklaceIndex + totalCount - 1) % totalCount
        
        updateNecklaceExhibition()
    }
    
    @IBAction func necklaceRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = necklaces.count
        exhibitionNecklaceIndex = (exhibitionNecklaceIndex + 1) % totalCount
        
        updateNecklaceExhibition()
    }
    
    @IBAction func necklaceBuyButtonTouched(_ sender: UIButton) {
        
        let necklaceChosen = necklaces[exhibitionNecklaceIndex]
        
        // Check if already worn.
        if avatar.necklace != nil && necklaceChosen.id == avatar.necklace!.id {
            
            // If already worn, unwear it.
            avatar.necklace = nil
            avatarNecklaceView.image = nil
            
            // Deduct the price from the total cost if it isn't purchased yet.
            if !necklaceChosen.purchased {
                totalCost -= necklaceChosen.points
            }
            
        } else {
            // Not worn yet.
            
            // Deduct the price of previous worn accessory from the total cost if it isn't purchased.
            if avatar.necklace != nil && !avatar.necklace!.purchased {
                totalCost -= avatar.necklace!.points
            }
            
            // Wear it.
            avatar.necklace = necklaceChosen
            avatarNecklaceView.image = necklaceChosen.image
            
            // Add the price to the total cost if it isn't purchased yet.
            if !necklaceChosen.purchased {
                totalCost += necklaceChosen.points
            }
        }
        
        updateTotalCostLabel()
        
    }
    
    // Hair
    @IBAction func hairLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairs.count
        exhibitionHairIndex = (exhibitionHairIndex + totalCount - 1) % totalCount
        
        updateHairExhibition()
    }
    
    @IBAction func hairRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = hairs.count
        exhibitionHairIndex = (exhibitionHairIndex + 1) % totalCount
        
        updateHairExhibition()
    }
    
    @IBAction func hairBuyButtonTouched(_ sender: UIButton) {
        
        let hairChosen = hairs[exhibitionHairIndex]
        
        // (Hair can't be unworn)
            
        // Deduct the price of previous worn accessory from the total cost if it isn't purchased yet.
        totalCost -= avatar.hair.purchased ? 0 : avatar.hair.points
            
        // Wear it.
        avatar.hair = hairChosen
        avatarHairView.image = hairChosen.image
            
        // Add the price to the total cost if it isn't purchased yet.
        if !hairChosen.purchased {
            totalCost += hairChosen.points
        }
        
        updateTotalCostLabel()
    }
    
    // Clothes
    @IBAction func clothesLeftButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothes.count
        exhibitionClothesIndex = (exhibitionClothesIndex + totalCount - 1) % totalCount
        
        updateClothesExhibition()
    }
    
    @IBAction func clothesRightButtonTouched(_ sender: UIButton) {
        // Update index
        let totalCount = clothes.count
        exhibitionClothesIndex = (exhibitionClothesIndex + 1) % totalCount
        
        updateClothesExhibition()
    }
    
    @IBAction func clothesBuyButtonTouched(_ sender: UIButton) {
        
        let clothesChosen = clothes[exhibitionClothesIndex]
        
        // (Clothes can't be unworn)
        
        // Deduct the price of previous worn accessory from the total cost if it isn't purchased yet.
        totalCost -= avatar.clothes.purchased ? 0 : avatar.clothes.points
        
        // Wear it.
        avatar.clothes = clothesChosen
        avatarClothesView.image = clothesChosen.image
        
        // Add the price to the total cost if it isn't purchased yet.
        if !clothesChosen.purchased {
            totalCost += clothesChosen.points
        }
        
        updateTotalCostLabel()
    }
    
    @IBAction func purchaseButtonTouched(_ sender: UIButton) {
        
        if totalCost > score.karmaPoints {
            
            // Karma points not enough.
            let notEnoughAlert = UIAlertController(title: "Oops!", message: "You don't have enough Karma points to purchase this outfit!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Alright", style: .default)
            notEnoughAlert.addAction(okButton)
            present(notEnoughAlert, animated: true, completion: nil)
            
            return
        }
        
        // Alert the player that the purchase couldn't be reverted.
        let cannotRevertAlert = UIAlertController(title: "Warning", message: "Are you sure you want to purchase these items? You will be spending $\(totalCost) and the purchase can't be reverted.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Maybe not", style: .cancel)
        let purchaseButton = UIAlertAction(title: "Purchase", style: .default, handler: {action in
            
            // Save the purchased data into the database.
            do {
                // Set the accessories as purchased.
                // Required accessories.
                try DatabaseAccessor.sharedInstance.boughtAccessory(accessory: self.avatar.clothes)
                try DatabaseAccessor.sharedInstance.boughtAccessory(accessory: self.avatar.hair)
                
                // Optional accessories.
                if let hat = self.avatar.hat {
                    try DatabaseAccessor.sharedInstance.boughtAccessory(accessory: hat)
                }
                
                if let necklace = self.avatar.necklace {
                    try DatabaseAccessor.sharedInstance.boughtAccessory(accessory: necklace)
                }
                
                if let glass = self.avatar.glasses {
                    try DatabaseAccessor.sharedInstance.boughtAccessory(accessory: glass)
                }
                
                if let handbag = self.avatar.handbag {
                    try DatabaseAccessor.sharedInstance.boughtAccessory(accessory: handbag)
                }
                
                // Reduce Karma Points.
                self.score.karmaPoints -= self.totalCost
                try DatabaseAccessor.sharedInstance.saveScore(score: self.score)
                
                // Save the avatar.
                try DatabaseAccessor.sharedInstance.saveAvatar(self.avatar)
                
            } catch _ {
                let failedAlert = UIAlertController(title: "Oops!", message: "Error saving your purchase, please retry this action. If that doesn't help, try restarting or reinstalling the app.", preferredStyle: .alert)
                failedAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(failedAlert, animated: true, completion: nil)
                
                return
            }
            
            // Purchase successful.
            let successfulDiologue = UIAlertController(title: "Yay!", message: "The purchase is successful!", preferredStyle: .alert)
            
            // Dismiss the VC (Transition to Map View) when Confirm Button is pressed.
            let confirmButton = UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)})
            
            successfulDiologue.addAction(confirmButton)
            self.present(successfulDiologue, animated: true, completion: nil)
        })
        
        cannotRevertAlert.addAction(cancelButton)
        cannotRevertAlert.addAction(purchaseButton)
        present(cannotRevertAlert, animated: true, completion: nil)
    }
    
    @IBAction func revertButtonTouched(_ sender: UIButton) {
        let alertDialogue = UIAlertController(title: "Warning", message: "Sure you want to revert the previous avatar? Your selections will be discarded.", preferredStyle: .alert)
        let maybeNotButton = UIAlertAction(title: "Maybe Not", style: .cancel)
        let revertButton = UIAlertAction(title: "Revert", style: .destructive, handler: {(action) in
            
            // Reset the avatar to the original one.
            self.avatar = self.originalAvatar
            
            // Update the images.
            self.avatarHandbagView.image = self.avatar.handbag?.image
            self.avatarHatView.image = self.avatar.hat?.image
            self.avatarGlassesView.image = self.avatar.glasses?.image
            self.avatarNecklaceView.image = self.avatar.necklace?.image
            self.avatarClothesView.image = self.avatar.clothes.image
            self.avatarHairView.image = self.avatar.hair.image
            
            // Reset total cost.
            self.totalCost = 0
            self.updateTotalCostLabel()
        })
        alertDialogue.addAction(maybeNotButton)
        alertDialogue.addAction(revertButton)
        present(alertDialogue, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        // Quit without saving
        self.dismiss(animated: true, completion: nil)
    }
}

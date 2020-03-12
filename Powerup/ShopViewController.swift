import UIKit

class ShopViewController: UIViewController {
    // MARK: Constants
    let displayBoxCount = 6
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // The index of the first exhibition accessory.
    var firstAccessoryIndex = 0
    
    // The score of the avatar.
    var score: Score!
    
    // The displayed avatar.
    var avatar: Avatar!
    
    // Array of accessories.
    var hairs: [Accessory]!
    var clothes: [Accessory]!
    
    // Handbags, Glasses, Hats, Necklaces.
    var accessories: [Accessory]!
    
    // Currently displaying array.
    var currDisplayingArray: [Accessory]!
    
    // MARK: Views
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var avatarEyesView: UIImageView!
    @IBOutlet weak var avatarHairView: UIImageView!
    @IBOutlet weak var avatarFaceView: UIImageView!
    @IBOutlet weak var avatarClothesView: UIImageView!
    @IBOutlet weak var avatarHandbagView: UIImageView!
    @IBOutlet weak var avatarGlassesView: UIImageView!
    @IBOutlet weak var avatarHatView: UIImageView!
    @IBOutlet weak var avatarNecklaceView: UIImageView!
    
    // Display Boxes
    @IBOutlet var displayBoxes: Array<UIImageView>!
    @IBOutlet var priceLabels: Array<UILabel>!
    @IBOutlet var buttonTexts: Array<UILabel>!
    @IBOutlet var purchaseButtons: Array<UIButton>!
    @IBOutlet var purchasedCheckmark: Array<UIImageView>!
    @IBOutlet var displayImages: Array<UIImageView>!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch avatar and score from database.
        do {
            score = try dataSource.getScore()
            avatar = try dataSource.getAvatar()
        } catch _ {
            let alert = UIAlertController(title: warningTitleMessage, message: errorFetchingAvatarMessage, preferredStyle: .alert)
            
            // Exit shop when ok button is pressed.
            let okButton = UIAlertAction(title: okText, style: .default, handler: {action in self.dismiss(animated: true, completion: nil)})
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Set Karma points
        pointsLabel.text = String(score.karmaPoints)
        
        updateAvatarImageView()
        
        // Configure the exhibition box for hairs (default).
        hairCategoryChosen(UIButton())
        
    }
    
    // Update the display boxes by a certain type of accessory and a start index.
    func updateExhibition() {
        // Hide prev button if startIndex is 0.
        if firstAccessoryIndex == 0 {
            prevButton.isHidden = true
        } else {
            prevButton.isHidden = false
        }
        
        // Hide next button if no more elements are left to show.
        if firstAccessoryIndex + displayBoxCount >= currDisplayingArray.count {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        
        // Loop through each display box and configure it.
        for boxIndex in 0..<displayBoxCount {
            // Not enough accessories.
            if (firstAccessoryIndex + boxIndex) >= currDisplayingArray.count {
                for remainingIndex in boxIndex..<displayBoxCount {
                    // Hide the box.
                    displayBoxes[remainingIndex].image = UIImage()
                    
                    // Hide the price label
                    priceLabels[remainingIndex].text = ""
                    
                    // Hide check mark.
                    purchasedCheckmark[remainingIndex].isHidden = true
                    
                    // Hide display image.
                    displayImages[remainingIndex].image = nil
                    
                    // Hide button text.
                    buttonTexts[remainingIndex].text = ""
                    
                    // Disable buttons.
                    purchaseButtons[remainingIndex].isEnabled = false
                }
                
                break
            }
            
            let currItem = currDisplayingArray[boxIndex + firstAccessoryIndex]
            
            // Configure the display image.
            displayImages[boxIndex].image = currItem.displayImage
            
            // Enable buttons.
            purchaseButtons[boxIndex].isEnabled = true
            
            // Change button text according to "item bought".
            buttonTexts[boxIndex].text = currItem.purchased ? "SELECT" : "BUY"
            
            // Special changes for selected item
            let isItemSelected: Bool = avatar.getAccessoryByType(currItem.type) != nil && currItem.id == avatar.getAccessoryByType(currItem.type)!.id
            purchasedCheckmark[boxIndex].isHidden = !isItemSelected
            if(isItemSelected == true) {
                buttonTexts[boxIndex].text = "CHOSEN"
            }
            
            // Configure the price label.
            priceLabels[boxIndex].text = currItem.purchased ? "-" : String(currItem.points)
            
            // If the item isn't bought and it is unaffordable, grey out the box.
            if !currItem.purchased && currItem.points > score.karmaPoints {
                displayBoxes[boxIndex].image = UIImage(named: greyOutBoxImageName)
                buttonTexts[boxIndex].text = ""
            } else {
                displayBoxes[boxIndex].image = UIImage(named: boxImageName)
            }
        }
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
    
    func haveEnoughPointsToBuy(accessoryPrice: Int) -> Bool {
        
        // Show alert dialog if players are trying to buy items they can't afford.
        if score.karmaPoints < accessoryPrice {
            let alertDialog = UIAlertController(title: oopsTitleMessage, message: notEnoughPointsMessage, preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: okText, style: .default))
            self.present(alertDialog, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func presentBuyingErrorDiaologue() {
        let alert = UIAlertController(title: warningTitleMessage, message: errorPurchasingMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okText, style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateAvatarImageView() {
        avatarHairView.image = avatar.hair.image
        avatarFaceView.image = avatar.face.image
        avatarEyesView.image = avatar.eyes.image
        avatarClothesView.image = avatar.clothes.image
        avatarNecklaceView.image = avatar.necklace?.image
        avatarGlassesView.image = avatar.glasses?.image
        avatarHandbagView.image = avatar.handbag?.image
        avatarHatView.image = avatar.hat?.image
    }
    
    // MARK: Actions
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        firstAccessoryIndex += displayBoxCount
        updateExhibition()
    }
    
    @IBAction func prevButtonTouched(_ sender: UIButton) {
        firstAccessoryIndex -= displayBoxCount
        updateExhibition()
    }
    
    // Touched the "buy" button of a display box.
    @IBAction func purchaseItem(_ sender: UIButton) {
        //flag used to not update exhibiiton in case of cancelled purchase
        var toUpdateExhibition = true
        // Get the index of the purchased item by the tag of UIButton.
        let boxIndex = sender.tag
        
        let itemChosen = currDisplayingArray[boxIndex + firstAccessoryIndex]
        
        // Check if already worn.
        if avatar.getAccessoryByType(itemChosen.type) != nil && itemChosen.id == avatar.getAccessoryByType(itemChosen.type)!.id {
            // If already worn, unwear it.
            avatar.setAccessoryByType(itemChosen.type, accessory: nil)
            updateAvatarImageView()
        } else {
            // Not worn yet.
            
            // Buy the accessory if it isn't purchased yet.
            if !itemChosen.purchased {
                if haveEnoughPointsToBuy(accessoryPrice: itemChosen.points) {
                    toUpdateExhibition = false
                    // Save the current item in case the user wants to revert.
                    let currentItem = self.avatar.getAccessoryByType(itemChosen.type)
                    
                    // Show the user a preview of the item.
                    self.avatar.setAccessoryByType(itemChosen.type, accessory: itemChosen)
                    self.updateAvatarImageView()
                    
                    // Set the preview label's text to "Preview".
                    previewLabel.text = previewLabelText
                    
                    // If have enough points, buy the item.
                    // Alert the player that the purchase couldn't be reverted.
                    
                    let cannotRevertAlert = UIAlertController(title: confirmationTitleMessage, message: "You will be spending \(itemChosen.points) Karma Points!", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: cancelText, style: .cancel, handler: {action in
                        // Revert to whatever accessory the user had before.
                        self.avatar.setAccessoryByType(itemChosen.type, accessory: currentItem)
                        self.updateAvatarImageView()
                        
                        // Get rid of the preview text.
                        self.previewLabel.text = ""
                    })
                    let purchaseButton = UIAlertAction(title: purchaseButtonText, style: .default, handler: {action in
                        
                        // Save the purchased data into the database.
                        do {
                            // Set the accessories as purchased.
                            try self.dataSource.boughtAccessory(accessory: itemChosen)
                            
                            // Reduce Karma Points.
                            self.score.karmaPoints -= itemChosen.points
                            try self.dataSource.saveScore(score: self.score)
                        } catch _ {
                            let failedAlert = UIAlertController(title: oopsTitleMessage, message: errorSavingPurchaseMessage, preferredStyle: .alert)
                            failedAlert.addAction(UIAlertAction(title: okText, style: .default))
                            self.present(failedAlert, animated: true, completion: nil)
                            
                            return
                        }
                        
                        //Purchase Successful
                        
                        self.currDisplayingArray[boxIndex + self.firstAccessoryIndex].purchased = true
                        
                        // Update point label
                        self.pointsLabel.text = String(self.score.karmaPoints)
                        
                        // Wear it.
                        self.avatar.setAccessoryByType(itemChosen.type, accessory: itemChosen)
                        self.updateAvatarImageView()
                        
                        // Show purchase successful dialogue.
                        let successfulDiologue = UIAlertController(title: yayTitleMessage, message: successFullPurchaseMessage, preferredStyle: .alert)
                        successfulDiologue.addAction(UIAlertAction(title: okText, style: .default, handler: { (UIAlertAction) in
                            self.updateExhibition()
                        }))
                        self.present(successfulDiologue, animated: true, completion: nil)
                        
                        // Get rid of the preview text.
                        self.previewLabel.text = ""
                    })
                    
                    cannotRevertAlert.addAction(cancelButton)
                    cannotRevertAlert.addAction(purchaseButton)
                    present(cannotRevertAlert, animated: true, completion: nil)
                }
            } else {
                // Already purchased, wear it.
                avatar.setAccessoryByType(itemChosen.type, accessory: itemChosen)
                updateAvatarImageView()
            }
        }
        if(toUpdateExhibition == true) {
            updateExhibition()
        }
    }
    
    @IBAction func hairCategoryChosen(_ sender: UIButton) {
        //fetch hair database details
        hairs = dataSource.getAccessoryArray(accessoryType: .hair)
        //settings
        currDisplayingArray = hairs
        firstAccessoryIndex = 0
        updateExhibition()
    }
    
    @IBAction func clothesCategoryChosen(_ sender: UIButton) {
        //fetch clothes database details
        clothes = dataSource.getAccessoryArray(accessoryType: .clothes)
        //settings
        currDisplayingArray = clothes
        firstAccessoryIndex = 0
        updateExhibition()
    }
    
    @IBAction func accessoryCategoryChosen(_ sender: UIButton) {
        //fetch accessories database details
        accessories = dataSource.getAccessoryArray(accessoryType: .handbag)
        accessories.append(contentsOf: dataSource.getAccessoryArray(accessoryType: .glasses))
        accessories.append(contentsOf: dataSource.getAccessoryArray(accessoryType: .hat))
        accessories.append(contentsOf: dataSource.getAccessoryArray(accessoryType: .necklace))
        //settings
        currDisplayingArray = accessories
        firstAccessoryIndex = 0
        updateExhibition()
    }
    
    @IBAction func homeButtonTouched(_ sender: UIButton) {
        // Save and quit.
        do {
            // Save the avatar.
            try self.dataSource.saveAvatar(self.avatar)
        } catch _ {
            let failedAlert = UIAlertController(title: oopsTitleMessage, message: errorFetchingAvatarMessage, preferredStyle: .alert)
            failedAlert.addAction(UIAlertAction(title: okText, style: .default))
            self.present(failedAlert, animated: true, completion: nil)
            
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

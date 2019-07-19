import XCTest
@testable import Powerup

class ShopViewControllerTests: XCTestCase {
    
    var shopViewController: ShopViewController!
    
    var mockData: MockSource!
    
    // Mock data for testing.
    class MockSource: DataSource {
        var createdAvatar: Avatar? = nil
        
        var accessories: [AccessoryType:[Accessory]]
        
        init(accessories: [AccessoryType:[Accessory]]) {
            self.accessories = accessories
        }
        
        override func getAccessoryArray(accessoryType: AccessoryType) -> [Accessory] {
            return accessories[accessoryType]!
        }
    }
    
    override func setUp() {
        shopViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Shop View Controller") as! ShopViewController
        shopViewController.loadView()
        super.setUp()
    }
    
    override func tearDown() {
        shopViewController = nil
        
        super.tearDown()
    }
 
    /** Test whether the user has enough points to buy an item or not. */
    func testHaveEnoughPointsToBuy() {
        // Given
        let database = DatabaseAccessor.sharedInstance
        do {
            try database.initializeDatabase()
        } catch _ {
            fatalError("Can't initialize database.")
        }
        let score = Score(karmaPoints: 40, healing: 0, strength: 0, telepathy: 0, invisibility: 0)
        do {
            try database.saveScore(score: score)
        } catch _ {
            fatalError("Error saving score to database.")
        }
        shopViewController.dataSource = database
        
        // When
        shopViewController.viewDidLoad()
        shopViewController.score = score
        
        // Then
        // The user cannot buy an item for 50 karma points if she only has 40.
        XCTAssertFalse(shopViewController.haveEnoughPointsToBuy(accessoryPrice: 50))
        // The user can buy an item for 20 karma points.
        XCTAssertTrue(shopViewController.haveEnoughPointsToBuy(accessoryPrice: 20))
    }
    
    /** Test that the correct avatar appears in the view initially. */
    func testInitialAvatarImageView() {
        // Given
        // Create a generic avatar.
        let avatar = Avatar(avatarID: 0, face: Accessory(type: .face), eyes: Accessory(type: .eyes), hair: Accessory(type: .hair), clothes: Accessory(type: .clothes), necklace: Accessory(type: .necklace), glasses: Accessory(type: .glasses), handbag: Accessory(type: .handbag), hat: Accessory(type: .hat))
        
        // When
        shopViewController.loadView()
        
        // Then
        XCTAssertEqual(shopViewController.avatarHairView.image, avatar.hair.image)
        XCTAssertEqual(shopViewController.avatarFaceView.image, avatar.face.image)
        XCTAssertEqual(shopViewController.avatarEyesView.image, avatar.eyes.image)
        XCTAssertEqual(shopViewController.avatarClothesView.image, avatar.clothes.image)
        XCTAssertEqual(shopViewController.avatarNecklaceView.image, avatar.necklace?.image)
        XCTAssertEqual(shopViewController.avatarGlassesView.image, avatar.glasses?.image)
        XCTAssertEqual(shopViewController.avatarHandbagView.image, avatar.handbag?.image)
        XCTAssertEqual(shopViewController.avatarHatView.image, avatar.hat?.image)
    }
    
    func testUpdateExhibition() {
        // Given
        // Mock the accessory data.
        let clothes = [
            Accessory(type: .clothes, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .clothes, id: 2, imageName: "", points: 0, purchased: true),
            Accessory(type: .clothes, id: 3, imageName: "", points: 0, purchased: true)
        ]
        
        let hairs = [
            Accessory(type: .hair, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .hair, id: 2, imageName: "", points: 5, purchased: false)
        ]
        
        let handbags = [
            Accessory(type: .handbag, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .handbag, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        let glasses = [
            Accessory(type: .glasses, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .glasses, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        let hats = [
            Accessory(type: .hat, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .hat, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        let necklaces = [
            Accessory(type: .necklace, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .necklace, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        var accessoryTable = [AccessoryType:[Accessory]]()
        accessoryTable[AccessoryType.clothes] = clothes
        accessoryTable[AccessoryType.hair] = hairs
        accessoryTable[AccessoryType.handbag] = handbags
        accessoryTable[AccessoryType.glasses] = glasses
        accessoryTable[AccessoryType.hat] = hats
        accessoryTable[AccessoryType.necklace] = necklaces
        
        // Insert the mocked data to the VC.
        mockData = MockSource(accessories: accessoryTable)
        shopViewController.dataSource = mockData
        
        // When
        shopViewController.viewDidLoad()
        
        // Then (Check that the arrays are successfully initialized.)
        XCTAssertEqual(shopViewController.clothes.count, clothes.count)
        XCTAssertEqual(shopViewController.hairs.count, hairs.count)
        
        for boxIndex in 0..<shopViewController.displayBoxCount {
            if boxIndex == 0 {
                // The first hair has already been purchased.
                XCTAssertTrue(shopViewController.purchaseButtons[boxIndex].isEnabled)
                XCTAssertFalse(shopViewController.purchasedCheckmark[boxIndex].isHidden)
                XCTAssertEqual(shopViewController.buttonTexts[boxIndex].text, "SELECT")
                XCTAssertEqual(shopViewController.priceLabels[boxIndex].text, "-")
            } else if boxIndex == 1 {
                // The second hair has not been purchased
                XCTAssertTrue(shopViewController.purchaseButtons[boxIndex].isEnabled)
                XCTAssertTrue(shopViewController.purchasedCheckmark[boxIndex].isHidden)
                XCTAssertEqual(shopViewController.priceLabels[boxIndex].text, String(5))
            } else {
                // Since there are no other hairs, the other boxes should be unavailable.
                XCTAssertEqual(shopViewController.displayBoxes[boxIndex].image!.pngData(), UIImage().pngData())
                XCTAssertEqual(shopViewController.priceLabels[boxIndex].text, "")
                XCTAssertTrue(shopViewController.purchasedCheckmark[boxIndex].isHidden)
                XCTAssertEqual(shopViewController.displayImages[boxIndex].image, nil)
                XCTAssertEqual(shopViewController.buttonTexts[boxIndex].text, "")
                XCTAssertFalse(shopViewController.purchaseButtons[boxIndex].isEnabled)
            }
        }
    }
}

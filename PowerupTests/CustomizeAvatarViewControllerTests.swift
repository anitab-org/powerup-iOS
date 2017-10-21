import XCTest
@testable import Powerup

class CustomizeAvatarViewControllerTests: XCTestCase {
    
    var customizeAvatarViewController: CustomizeAvatarViewController!
    
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
        
        override func createAvatar(_ avatar: Avatar) {
            createdAvatar = avatar
        }
    }
    
    override func setUp() {
        customizeAvatarViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Customize Avatar View Controller") as! CustomizeAvatarViewController
        customizeAvatarViewController.loadView()
        
        super.setUp()
    }
    
    override func tearDown() {
        customizeAvatarViewController = nil
        
        super.tearDown()
    }
    
    /**
      - Test that the accessories are shown correctly when pressing the left & right buttons.
    */
    func testAccessoryExhibitions() {
        // Given
        // Mock the accessory data.
        let clothes = [
            Accessory(type: .clothes, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .clothes, id: 2, imageName: "", points: 0, purchased: true),
            Accessory(type: .clothes, id: 3, imageName: "", points: 0, purchased: true)
        ]
        
        let faces = [
            Accessory(type: .face, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .face, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        let eyes = [
            Accessory(type: .eyes, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .eyes, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        let hairs = [
            Accessory(type: .hair, id: 1, imageName: "", points: 0, purchased: true),
            Accessory(type: .hair, id: 2, imageName: "", points: 0, purchased: true)
        ]
        
        var accessoryTable = [AccessoryType:[Accessory]]()
        accessoryTable[AccessoryType.clothes] = clothes
        accessoryTable[AccessoryType.face] = faces
        accessoryTable[AccessoryType.eyes] = eyes
        accessoryTable[AccessoryType.hair] = hairs
        
        // Insert the mocked data to the VC.
        mockData = MockSource(accessories: accessoryTable)
        customizeAvatarViewController.dataSource = mockData
        
        // When (Initialize arrays.)
        customizeAvatarViewController.initializeAccessoryArrays()
        
        // Then (Check that the arrays are successfully initialized.)
        XCTAssertEqual(customizeAvatarViewController.clothes.count, clothes.count)
        XCTAssertEqual(customizeAvatarViewController.faces.count, faces.count)
        XCTAssertEqual(customizeAvatarViewController.eyes.count, eyes.count)
        XCTAssertEqual(customizeAvatarViewController.hairs.count, hairs.count)
        
        // When
        
        // Press clothes button: Left, Left, Right
        customizeAvatarViewController.clothesLeftButtonTouched(UIButton())
        customizeAvatarViewController.clothesLeftButtonTouched(UIButton())
        customizeAvatarViewController.clothesRightButtonTouched(UIButton())
        
        // Press faces button: Right, Right, Left
        customizeAvatarViewController.faceRightButtonTouched(UIButton())
        customizeAvatarViewController.faceRightButtonTouched(UIButton())
        customizeAvatarViewController.faceLeftButtonTouched(UIButton())
        
        // Press eyes button: Right, Left
        customizeAvatarViewController.eyesRightButtonTouched(UIButton())
        customizeAvatarViewController.eyesLeftButtonTouched(UIButton())
        
        // Press hairs button: Left, Right
        customizeAvatarViewController.hairLeftButtonTouched(UIButton())
        customizeAvatarViewController.hairRightButtonTouched(UIButton())
        
        // Press continue button (save avatar).
        XCTAssertTrue(customizeAvatarViewController.saveAvatar())
        
        // Then (Check if the correct accessory id is configured and saved).
        XCTAssertEqual(mockData.createdAvatar!.clothes.id, 3)
        XCTAssertEqual(mockData.createdAvatar!.face.id, 2)
        XCTAssertEqual(mockData.createdAvatar!.eyes.id, 1)
        XCTAssertEqual(mockData.createdAvatar!.hair.id, 1)
    }
}

import XCTest
@testable import Powerup

class MapViewControllerTests: XCTestCase {
    
    var mapViewController: MapViewController!
    
    override func setUp() {
        mapViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "2") as! MapViewController
        mapViewController.loadView()
        super.setUp()
    }
    
    override func tearDown() {
        mapViewController = nil
        
        super.tearDown()
    }
    
    /** Test that the button on the map is inaccessible for each locked scenario. */
    func testInitialMap() {
        // Given
        let database = DatabaseAccessor.sharedInstance
        mapViewController.dataSource = database
        
        // When
        mapViewController.viewDidLoad()
        
        // Then
        do {
            for (index, button) in mapViewController.scenarioButtons.enumerated() {
                var currScenario = try database.getScenario(of: button.tag)
                currScenario.unlocked = false
                try database.saveScenario(currScenario)
                mapViewController.unlockScenarios()
                XCTAssertTrue(button.isHidden)
                XCTAssertTrue(mapViewController.scenarioImages[index].isHidden)
            }
        } catch _ {
            fatalError()
        }
    }
    
    /** After unlocking a scenario, test that the button on the map is accessible. */
    func testUnlockScenarios() {
        // Given
        let database = DatabaseAccessor.sharedInstance
        mapViewController.dataSource = database
        
        do {
            for (index, button) in mapViewController.scenarioButtons.enumerated() {
                var currScenario = try database.getScenario(of: button.tag)
                currScenario.unlocked = true
                try database.saveScenario(currScenario)
                
                // When
                mapViewController.unlockScenarios()
                
                // Then
                XCTAssertFalse(button.isHidden)
                XCTAssertFalse(mapViewController.scenarioImages[index].isHidden)
                
            }
        } catch _ {
            fatalError("Can't get scenario")
        }
 
    }
}

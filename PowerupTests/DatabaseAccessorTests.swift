import XCTest
@testable import Powerup

class DatabaseAccessorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
      - Test if the shared instance of the singleton class is properly initialized.
    */
    func testInstanceExists() {
        XCTAssertNotNil(DatabaseAccessor.sharedInstance)
    }
    
}

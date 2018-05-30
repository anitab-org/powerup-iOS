import XCTest

@testable import Powerup

class StorySequencePlayerTests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
     This automates testing StorySequencePlayer and StorySequenceModel:

     - start a new game
     - navigate to the map view
     - check for an intro sequence for the home scenario
     - if it exists, navigate to the home scenario, else skip (but pass) this test
     - step through the sequence, manually waiting to ensure each step is ready for interaction
     - once finished, assert that the player is released

     This test assumes there is a home intro. It should be changed to unlock and test a different sequence if one does not exist at some point.
    */
    func testHomeScenario() {

        // open app, start new game, navigate to map view
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).element(boundBy: 1).tap()
        app.alerts["Are you sure?"].buttons["Create New Avatar"].tap()
        app.buttons["continue button"].tap()
        app.buttons["continue button"].tap()

        // retrieve home scenario intro model, if it exists, continue, else pass this test and move on
        guard let steps: Dictionary<Int, StorySequence.Step> = StorySequences().intros[5]?.steps else { return }

        // assert we're on the map view controller and the home scenario button exists, then tap it
        let homeScenarioButton = element.children(matching: .button).element(boundBy: 2)
        let homeScenarioButtonExists = homeScenarioButton.waitForExistence(timeout: 5)
        XCTAssert(homeScenarioButtonExists)
        homeScenarioButton.tap()

        // assert the scenario view controller loaded and the player launched
        let player = app.otherElements["story-sequence-player"]
        let playerExists = player.waitForExistence(timeout: 5)
        XCTAssert(playerExists)

        // step through the sequence, manually waiting long enough for each step to idle
        for _ in 0..<steps.count {
            wait(for: 1)
            player.tap()
        }

        let playerReleased = !player.exists
        XCTAssert(playerReleased)
    }

}

extension XCTestCase {

    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
}


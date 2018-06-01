import XCTest

@testable import Powerup

class StorySequencePlayerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     Testing stepping through a StoryPlayerSequence intro.

     - start a new game and navigate to the map view
     - check for and retrieve the intro sequence for the home scenario
     - navigate to home scenario
     - step through the sequence, manually waiting to ensure each step is ready for interaction
     - once finished, check that the player is dismissed

     This test assumes there is a home intro. It should be changed to unlock and test a different sequence if one does not exist at some point.
    */
    func testSSPStepThrough() {
        // open app, start new game, navigate to map view
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).element(boundBy: 1).tap()
        app.alerts["Are you sure?"].buttons["Create New Avatar"].tap()
        app.buttons["continue button"].tap()
        app.buttons["continue button"].tap()

        // check for and retrieve the number of steps in the home intro sequence
        let steps: Int? = StorySequences().intros[5]?.steps.count
        let modelExists: Bool = steps != nil
        XCTAssert(modelExists)

        // assert we're on the map view controller and the home scenario button exists, then tap it
        let homeScenarioButton = element.children(matching: .button).element(boundBy: 2)
        let homeScenarioButtonExists = homeScenarioButton.waitForExistence(timeout: 5)
        XCTAssert(homeScenarioButtonExists)
        homeScenarioButton.tap()

        // assert the scenario view controller loaded and the player launched
        let player = app.otherElements[StorySequencePlayer.accessibilityIdentifiers.storySequencePlayer.rawValue]
        let playerExists = player.waitForExistence(timeout: 5)
        XCTAssert(playerExists)

        // step through the sequence, manually waiting long enough for each step to idle
        for _ in 0..<steps! {
            wait(for: 1.5)
            player.tap()
        }

        // assert that the player has been removed from the superview
        let playerDismissed = !player.exists
        XCTAssert(playerDismissed)
    }

    /**
     Test skipping a story sequence.

     - start a new game
     - navigate to the map view
     - check for an intro sequence for the home scenario
     - navigate to the home scenario
     - open the skip warning view
     - cancel the skip and check the skip warning is dismissed
     - open the skip warning again
     - confirm the skip and check that the player is dismissed

     This test assumes there is a home intro. It should be changed to unlock and test a different sequence if one does not exist at some point.
     */
    func testSSPSkip() {

        // open app, start new game, navigate to map view
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).element(boundBy: 1).tap()
        app.alerts["Are you sure?"].buttons["Create New Avatar"].tap()
        app.buttons["continue button"].tap()
        app.buttons["continue button"].tap()

        // make sure home scenario has an intro to test
        let model: StorySequence? = StorySequences().intros[5]
        let modelExists: Bool = model != nil
        XCTAssert(modelExists)

        // assert we're on the map view controller and the home scenario button exists, then tap it
        let homeScenarioButton = element.children(matching: .button).element(boundBy: 2)
        let homeScenarioButtonExists = homeScenarioButton.waitForExistence(timeout: 5)
        XCTAssert(homeScenarioButtonExists)
        homeScenarioButton.tap()

        // assert the scenario view controller loaded and the player launched
        let player = app.otherElements[StorySequencePlayer.accessibilityIdentifiers.storySequencePlayer.rawValue]
        let playerExists = player.waitForExistence(timeout: 5)
        XCTAssert(playerExists)

        // long press on the player
        wait(for: 1.5)
        player.press(forDuration: 1.0)

        // assert the skip view loads and the no button exists
        let no = app.buttons[StorySequencePlayer.accessibilityIdentifiers.skipWarningNo.rawValue]
        let noExists = no.waitForExistence(timeout: 5)
        XCTAssert(noExists)

        // dismiss the skip warning and assert it is removed from superview
        no.tap()
        let noDismissed = !no.exists
        XCTAssert(noDismissed)

        // long press on the player
        wait(for: 1.5)
        player.press(forDuration: 1.0)

        // assert the skip view loads and the yes button exists
        let yes = app.buttons[StorySequencePlayer.accessibilityIdentifiers.skipWarningYes.rawValue]
        let yesExists = yes.waitForExistence(timeout: 5)
        XCTAssert(yesExists)

        // skip the rest of the sequence and assert that the player has been removed from the superview
        yes.tap()
        let playerDismissed = !player.exists
        XCTAssert(playerDismissed)
    }

}

// a manual wait function - the automated idle check "taps" too often to step through the sequence properly
// this ensures we wait long enough for the scene change to take place
extension XCTestCase {

    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration)
    }

}

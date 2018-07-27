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

     - Author: Cadence Holmes 2018

     - start a new game and navigate to the map view
     - check for and retrieve the intro sequence for the home scenario
     - navigate to home scenario
     - step through the sequence, manually waiting to ensure each step is ready for interaction
     - once finished, check that the player is dismissed

     This test assumes there is a home intro. It should be changed to unlock and test a different sequence if one does not exist at some point.

     Dataset validation is performed in Unit Testing.
    */
    func testSSPStepThrough() {

        // open app, start new game, navigate to map view
        let app = XCUIApplication()

        let startButton = app.buttons["startvc-new-game-button"]
        startButton.tap()

        // this checks for a new game alert - won't display if the game is a fresh install
        let alert = app.alerts["Are you sure?"].buttons["Create New Avatar"]
        if alert.exists {
            alert.tap()
        }

        // two contine buttons to exit the character creation
        func checkContinueButtons() {
            let continueButton = app.buttons["continue button"]
            continueButton.tap()
        }

        checkContinueButtons()
        checkContinueButtons()

        // get the data from the test bundle
        var testStorySequences = StorySequences()
        testStorySequences.bundle = Bundle(for: StorySequencePlayerTests.self)

        // check for and retrieve the number of steps in the home intro sequence
        let steps: Int? = testStorySequences.getStorySequence(scenario: 5)?.steps.count
        let modelExists: Bool = steps != nil
        XCTAssert(modelExists)

        // assert we're on the map view controller and the home scenario button exists, then tap it
        let homeScenarioButton = app.buttons["mapvc-home-scenario-button"]
        let homeScenarioButtonExists = homeScenarioButton.waitForExistence(timeout: 5)
        XCTAssert(homeScenarioButtonExists)
        homeScenarioButton.tap()

        // assert the scenario view controller loaded and the player launched
        let player = app.otherElements[StorySequencePlayer.AccessibilityIdentifiers.storySequencePlayer.rawValue]
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

        let startButton = app.buttons["startvc-new-game-button"]
        startButton.tap()

        // this checks for a new game alert - won't display if the game is a fresh install
        let alert = app.alerts["Are you sure?"].buttons["Create New Avatar"]
        if alert.exists {
            alert.tap()
        }

        // two contine buttons to exit the character creation
        func checkContinueButtons() {
            let continueButton = app.buttons["continue button"]
            continueButton.tap()
        }

        checkContinueButtons()
        checkContinueButtons()

        // get the data from the test bundle
        var testStorySequences = StorySequences()
        testStorySequences.bundle = Bundle(for: StorySequencePlayerTests.self)

        // make sure home scenario has an intro to test
        let model: StorySequence? = testStorySequences.getStorySequence(scenario: 5)
        let modelExists: Bool = model != nil
        XCTAssert(modelExists)

        // assert we're on the map view controller and the home scenario button exists, then tap it
        let homeScenarioButton = app.buttons["mapvc-home-scenario-button"]
        let homeScenarioButtonExists = homeScenarioButton.waitForExistence(timeout: 5)
        XCTAssert(homeScenarioButtonExists)
        homeScenarioButton.tap()

        // assert the scenario view controller loaded and the player launched
        let player = app.otherElements[StorySequencePlayer.AccessibilityIdentifiers.storySequencePlayer.rawValue]
        let playerExists = player.waitForExistence(timeout: 5)
        XCTAssert(playerExists)

        // long press on the player
        wait(for: 1.5)
        player.press(forDuration: 1.0)

        // assert the skip view loads and the no button exists
        let no = app.buttons[StorySequencePlayer.AccessibilityIdentifiers.skipWarningNo.rawValue]
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
        let yes = app.buttons[StorySequencePlayer.AccessibilityIdentifiers.skipWarningYes.rawValue]
        let yesExists = yes.waitForExistence(timeout: 5)
        XCTAssert(yesExists)

        // skip the rest of the sequence and assert that the player has been removed from the superview
        yes.tap()
        let playerDismissed = !player.exists
        XCTAssert(playerDismissed)

    }

}

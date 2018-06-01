import XCTest

class PopupEventPlayerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     Test PopupEventPlayer interactions.

     - test automatic dismissal
         - get the expected durations from the PopupEventPlayer declaration
         - go to the About page where a popup should be presented automatically
         - wait for the popup duration and automatic dismissal
         - check that the popup has been dismissed and removed from the view

     - test manual dismissal
         - go to the About page where a popup should be presented automatically
         - tap on the popup
         - wait for the animation duration
         - check that the popup has been dismissed and removed from the view
     */
    func testPopupEventPlayer() {

        // get the duration of a popup from the class
        let p = PopupEventPlayer(delegate: nil, model: nil)
        let popupDuration: Double = p.popupDuration
        let popupAnimDuration: Double = p.slideAnimDuration

        // open the app and tap on the about button
        let app = XCUIApplication()
        let aboutButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
        aboutButton.tap()

        // check that the popup loads as expected
        let popup = app.otherElements[PopupEventPlayer.AccessibilityIdentifiers.popupEventPlayer.rawValue]
        let exists: Bool = popup.waitForExistence(timeout: 5)
        XCTAssert(exists)

        // wait for the duration of the popup, and check that it is automatically dismissed
        wait(for: popupDuration + 1)
        let dismissed = !popup.exists
        XCTAssert(dismissed)

        // navigate back to home, and back to about page
        let homeButtonButton = app.buttons["home button"]
        homeButtonButton.tap()
        aboutButton.tap()

        // check that the popup again loads as expected
        let existsAgain: Bool = popup.waitForExistence(timeout: 5)
        XCTAssert(existsAgain)

        // tap on the popup, wait for the animation to finish, and check it is dismissed
        popup.tap()
        wait(for: popupAnimDuration + 1)
        let dismissedAgain = !popup.exists
        XCTAssert(dismissedAgain)
    }

}

// a manual wait function to be able to check that a popup is dismissed automatically
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

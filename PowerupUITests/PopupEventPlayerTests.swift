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

     - Author: Cadence Holmes 2018

     This test assumes there is a popup on the About page. It should be changed to locate a different popup if one does not exist in the future.

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

     Dataset validation is performed in Unit Testing.
     */
    func testPopupEventPlayer() {

        // get the duration of a popup from the class
        let p = PopupEventPlayer(delegate: nil, model: nil)
        let popupDuration: Double = p.popupDuration
        let popupAnimDuration: Double = p.slideAnimDuration

        // open the app and tap on the about button
        let app = XCUIApplication()
        let aboutButton = app.buttons["startvc-about-button"]
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

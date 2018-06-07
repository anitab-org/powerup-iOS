import XCTest

@testable import Powerup

/**
 Mock datasource - see PopupEvents.swift
 */
struct MockPopupEvents {
    let popups: Dictionary<Int, Dictionary<Int, PopupEvent>>

    let topString = "test top text"
    let botString = "test bottom text"
    let imageName = "minesweeper_abstinence_heart"

    init() {
        popups = [
            1: [
                // all fields with sound
                1: PopupEvent(topText: topString,
                              botText: botString,
                              imgName: imageName,
                              doSound: true),
                // all fields no sound
                2: PopupEvent(topText: topString,
                              botText: botString,
                              imgName: imageName,
                              doSound: false),
                // no image no sound
                3: PopupEvent(topText: topString,
                              botText: botString,
                              imgName: nil,
                              doSound: nil),
                // empty popups are still presented
                4: PopupEvent(topText: nil,
                              botText: nil,
                              imgName: nil,
                              doSound: nil)
            ]
        ]
    }
}

class PopupEventPlayerUnitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     Mock and test specific model cases.
     */
    func testPopupCases() {

        // retrieve popups from the datasource
        let p: Dictionary<Int, PopupEvent>? = MockPopupEvents().popups[1]
        XCTAssert(p != nil)
        let popups = p!

        // PopupEventPlayer won't try to make sound until it is added to a superview
        let view = UIView(frame: CGRect.zero)

        for i in 1..<5 {
            let model = popups[i]!
            let popup = PopupEventPlayer(delegate: nil, model: model)
            // don't actually play sound for the test
            popup.forceSilent = true
            view.addSubview(popup)

            // check that the presented popup has the expected properties
            let hasTopText = popup.mainLabel.text == MockPopupEvents().topString
            let hasBotText = popup.subLabel.text == MockPopupEvents().botString
            let hasImage = popup.imageView.image == UIImage(named: MockPopupEvents().imageName)

            // PopupEventPlayer always has an instance of SoundPlayer but, once added to a superview,
            // if it should play sound it should have a soundPlayer.player and it should be playing
            // else soundPlayer.player should be nil
            let player = popup.soundPlayer?.player
            let hasSound = (player != nil) ? player?.isPlaying : false

            switch i {
            case 1:
                // all fields with sound
                XCTAssert(hasTopText)
                XCTAssert(hasBotText)
                XCTAssert(hasImage)
                XCTAssert(hasSound!)
            case 2:
                // all fields no sound
                XCTAssert(hasTopText)
                XCTAssert(hasBotText)
                XCTAssert(hasImage)
                XCTAssertFalse(hasSound!)
            case 3:
                // no image no sound
                XCTAssert(hasTopText)
                XCTAssert(hasBotText)
                XCTAssertFalse(hasImage)
                XCTAssertFalse(hasSound!)
            case 4:
                // empty popups are still presented
                XCTAssertFalse(hasTopText)
                XCTAssertFalse(hasBotText)
                XCTAssertFalse(hasImage)
                XCTAssertFalse(hasSound!)
            default:
                XCTFail("Index out of range")
            }
        }

    }

    /**
     Test all actual popups described in PopupEvents to ensure there are no errors in the dataset, especially if it ends up being generated from database tables, which would be a better cross-platform goal.
     */
    func testAllRealPopups() {

        // PopupEventPlayer won't try to make sound until it is added to a superview
        let view = UIView(frame: CGRect.zero)

        // get the real datasource
        let popupEvents = PopupEvents()

        // setup a mirror so we can loop through its properties, which organize popups into collections
        let mirror = Mirror(reflecting: popupEvents)

        // loop through all major collections, which must be dictionaries of dictionaries
        for child in mirror.children {
            let majCol = child.value as? Dictionary<Int, Dictionary<Int, PopupEvent>>
            guard let majorCollections = majCol else { return }

            // loop through each collection of models, which must be dictionaries of PopupEvent()
            for key in majorCollections.keys {
                let minorCollection: Dictionary<Int, PopupEvent> = majorCollections[key]!

                // loop through all models, which must be a PopupEvent()
                for key in minorCollection.keys {
                    let model: PopupEvent = minorCollection[key]!

                    // create an instance of PopupEventPlayer and add it to the view
                    let popup = PopupEventPlayer(delegate: nil, model: model)

                    // don't blow up your speakers or computer or ears, so force volume to 0
                    popup.forceSilent = true
                    view.addSubview(popup)

                    // test that the popup has the expected strings where they belong
                    XCTAssert(popup.mainLabel.text == model.topText)
                    XCTAssert(popup.subLabel.text == model.botText)

                    // if the model should have an image, test that it's the one we expect, else test that the image is nil
                    let hasImage = (model.imgName != nil) ? (popup.imageView.image == UIImage(named: model.imgName!)) : (popup.imageView.image == nil)
                    XCTAssert(hasImage)

                    // see if there's sound playing, and test that against the expectation (even though volume is 0)
//                    let player = popup.soundPlayer?.player
//                    let hasSound = (player != nil) ? player?.isPlaying : false
//                    XCTAssert(hasSound == model.doSound)
                }
            }
        }

    }

}

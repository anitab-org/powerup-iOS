import XCTest

@testable import Powerup

class StorySequencePlayerUnitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     Test all steps described in StorySequences to ensure there are no errors in the dataset, especially if it ends up being generated from database tables, which would be a better cross-platform goal.

        - check that all media assets exist
        - check that position and animation strings match an enum case
          (this one is kind of redundant while it's still hardcoded using the enum cases, but this logic is to test once the values are being populated from an external table)
     */
    /*
    func testDataSet() {

        // for checking values against enum cases
        func checkPosCases(position: String) -> Bool {
            for pos in StorySequence.ImagePosition.cases {
                if position == pos.rawValue {
                    return true
                }
            }
            return false

        }

        // for checking values against enum cases
        func checkAniCases(position: String) -> Bool {
            for pos in StorySequence.ImageAnimation.cases {
                if position == pos.rawValue {
                    return true
                }
            }
            return false

        }

        // get the real datasource
        let storySequences = StorySequences()

        // setup a mirror so we can loop through its properties, which organize sequences into collections
        let mirror = Mirror(reflecting: storySequences)

        // loop through all collections, which must be dictionaries of StorySequence()
        for child in mirror.children {
            let coll = child.value as? Dictionary<Int, StorySequence>
            guard let collections = coll else { return }

            // loop through all models which must be a StorySequence()
            for key in collections.keys {
                let sequence: StorySequence! = collections[key]
                let steps = sequence.steps
                let fileName: String? = sequence.music

                // if there should be music, check that the file exists
                let musicCheck = (fileName != nil) ? (NSDataAsset(name: fileName!) != nil) : true
                XCTAssert(musicCheck)

                for key in steps.keys {
                    let step: StorySequence.Step! = steps[key]
                    let lftEvent: StorySequence.Event! = step.lftEvent
                    let rgtEvent: StorySequence.Event! = step.rgtEvent

                    // check each side independently
                    if lftEvent != nil {
                        // if there should be an image, check that the file exists
                        let lftImageCheck = (lftEvent.image != nil) ? (UIImage(named: lftEvent.image!) != nil) : true
                        XCTAssert(lftImageCheck)

                        // check that position strings match an enum case
                        let lftPosCheck = (lftEvent.position != nil) ? checkPosCases(position: lftEvent.position!.rawValue) : true
                        XCTAssert(lftPosCheck)

                        // check that animation strings match an enum case
                        let lftAniCheck = (lftEvent.imgAnim != nil) ? checkAniCases(position: lftEvent.imgAnim!.rawValue) : true
                        XCTAssert(lftAniCheck)
                    }

                    if rgtEvent != nil {
                        let rgtImageCheck = (rgtEvent.image != nil) ? (UIImage(named: rgtEvent.image!) != nil) : true
                        XCTAssert(rgtImageCheck)

                        let rgtPosCheck = (rgtEvent.position != nil) ? checkPosCases(position: rgtEvent.position!.rawValue) : true
                        XCTAssert(rgtPosCheck)

                        let rgtAniCheck = (rgtEvent.imgAnim != nil) ? checkAniCases(position: rgtEvent.imgAnim!.rawValue) : true
                        XCTAssert(rgtAniCheck)
                    }
                }
            }
        }

    }
    */
}

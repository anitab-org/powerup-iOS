/**
 Struct containing a dictionary of `StorySequence.Step`. Also describes `StorySequence.Step` and `StorySequence.Event`.

 - Author: Cadence Holmes 2018
 */
struct StorySequence {
    var steps: Dictionary<Int, Step>,
        music: String?

    /*
     Currently, the following structs are not being directly used by any related classes since the strings are being added to the Swift dataset via json. But they should be updated as new media/options are added to the app for a couple reasons:

     - StorySequencePlayer could be used with a dataset other than those in StorySequences.json, and these structs help ensure the data is viable.
     - This is a convenient place to organize the relevant media files for reference when keeping this model and the PowerUp Story Designer web tool in sync.
    */

    /**
     Struct containing music files for StorySequences.

     Add new music media files to this collection as necessary.

     ** Any changes to this struct need to be reflected in the PowerUp Story Designer web app.
     */
    struct Sounds {
        let scenarioMusic = [
            5: (intro: "home_intro_music_placeholder",
                goodEnding: "home_good_ending_example")
        ]
    }

    /**
     Struct containing descriptions of each character and the different types of images available.

     As new scenes are added, this static data should be updated. Each character should be represented as a descriptive constant, and should reference a tuple describing the images and referencing their file name.

     ** Image files for StorySequencePlayer should be in the following format:
     "CharacterName^Version"

     The carot ^ is necessary for StorySequencePlayer. The first half (CharacterName) must be the same for all images of the same character. The second half (Version) should be descriptive, such as mood.

     ** Any changes to this struct need to be reflected in the PowerUp Story Designer web app.
     */
    struct Images {
        let testChar = (normal: "test_chibi^normal",
                        happy: "test_chibi^happy",
                        smiling: "test_chibi^smiling",
                        talking: "test_chibi^talking",
                        lecturing: "test_chibi^lecturing",
                        sad: "test_chibi^sad",
                        scared: "test_chibi^scared",
                        upset: "test_chibi^upset",
                        dazed: "test_chibi^dazed",
                        whatever: "test_chibi^whatever",
                        tired: "test_chibi^tired")

        let testChar2 = (normal: "test2_chibi^normal",
                         happy: "test2_chibi^happy",
                         smiling: "test2_chibi^smiling",
                         talking: "test2_chibi^talking",
                         lecturing: "test2_chibi^lecturing",
                         sad: "test2_chibi^sad",
                         scared: "test2_chibi^scared",
                         upset: "test2_chibi^upset",
                         dazed: "test2_chibi^dazed",
                         whatever: "test2_chibi^whatever",
                         tired: "test2_chibi^tired")

        let testChar3 = (normal: "testChar3",
                         empty: "")

        let misc = (dataExample: "test_data_example",
                    empty: "")
    }

    /**
     These are the possible positions for an image. StorySequencePlayer interprets these cases per left and right.

     Near describes the image being close to the edge of the screen, and far describes the image being close to the middle of the screen. Mid is the middle of those positions.

     ** This enum typically won't need to change or be updated, but if any are made, make sure to also reflect those changes in the PowerUp Story Designer web app.
     */
    enum ImagePosition: String {
        // this array is so we can loop through the enum during unit testing
        static let cases = [
            hidden,
            near,
            mid,
            far
        ]
        case hidden = "hidden"
        case near = "near"
        case mid = "mid"
        case far = "far"
    }

    /**
     These are the possible animations for StorySequenceEvents. As new animations are created and added in StorySequencePlayer.swift and Animate.swift, this collection should be updated.

     ** Any changes to this struct need to be reflected in the PowerUp Story Designer web app.
     */
    enum ImageAnimation: String {
        // this array is so we can loop through the enum during unit testing
        static let cases = [
            shake,
            tiltLeft,
            tiltRight,
            jiggle,
            flip
        ]
        case shake = "shake"
        case tiltLeft = "tiltLeft"
        case tiltRight = "tiltRight"
        case jiggle = "jiggle"
        case flip = "flip"
    }

    /**
     Struct containing two `StorySequence.Event` representing the left and right sides of the `StorySequencePlayer`.
     */
    struct Step {
        var lftEvent: Event?,
            rgtEvent: Event?

        init(lftEvent: Event?, rgtEvent: Event?) {
            self.lftEvent = lftEvent
            self.rgtEvent = rgtEvent
        }
    }

    /**
     Struct describing a single event with text, image, image position, and image animation type.
     */
    struct Event {
        var text: String?,
            image: String?,
            position: ImagePosition?,
            imgAnim: ImageAnimation?

        init (txt: String?, img: String?, pos: ImagePosition?, ani: ImageAnimation?) {
            self.text = txt
            self.image = img
            self.position = pos
            self.imgAnim = ani
        }
    }

    init(music: String?, _ steps: Dictionary<Int, Step>) {
        self.steps = steps
        self.music = music
    }

}

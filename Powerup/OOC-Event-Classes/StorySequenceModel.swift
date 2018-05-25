import UIKit

/**
 Struct containing a dictionary of `StorySequence.Step`. Also describes `StorySequence.Step` and `StorySequence.Event`.
 - Author: Cadence Holmes
 */
struct StorySequence {
    var steps: Dictionary<Int, Step>

    /**
     Struct containing descriptions of each character and the different types of images available.

     As new scenes are added, this static data should be updated. Each character should be represented as a descriptive constant, and should reference a tuple describing the images and referencing their file name.

     Thanks to autocompletion, this makes it much easier to create and maintain StorySequence models rather than using just strings.
     */
    struct Images {
        let testChar = (normal: "test_chibi_normal",
                        happy: "test_chibi_happy",
                        smiling: "test_chibi_smiling",
                        talking: "test_chibi_talking",
                        lecturing: "test_chibi_lecturing",
                        sad: "test_chibi_sad",
                        scared: "test_chibi_scared",
                        upset: "test_chibi_upset",
                        dazed: "test_chibi_dazed",
                        whatever: "test_chibi_whatever",
                        tired: "test_chibi_tired")

        let testChar2 = (normal: "test2_chibi_normal",
                         happy: "test2_chibi_happy",
                         smiling: "test2_chibi_smiling",
                         talking: "test2_chibi_talking",
                         lecturing: "test2_chibi_lecturing",
                         sad: "test2_chibi_sad",
                         scared: "test2_chibi_scared",
                         upset: "test2_chibi_upset",
                         dazed: "test2_chibi_dazed",
                         whatever: "test2_chibi_whatever",
                         tired: "test2_chibi_tired")

        let misc = (dataExample: "test_data_example",
                    empty: "")
    }

    struct Sounds {
        let files = [
            5: (intro: "home_intro_music_placeholder",
                goodEnding: "home_good_ending_example")
        ]
    }

    enum ImagePosition {
        case hidden
        case near
        case mid
        case far
    }

    enum ImageAnimation {
        case shake
        case tiltLeft
        case tiltRight
        case jiggle
        case flip
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

    init(_ steps: Dictionary<Int, Step>) {
        self.steps = steps
    }

}

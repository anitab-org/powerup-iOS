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
        let testChar = (normal: "test_image_normal",
                        sad: "test_image_sad",
                        scared: "test_image_scared",
                        talking: "test_image_talking",
                        upset: "test_image_upset")

        let testChar2 = (normal: "test_image2_normal",
                         sad: "test_image2_sad",
                         scared: "test_image2_scared",
                         talking: "test_image2_talking",
                         upset: "test_image2_upset")
        
        let misc = (dataExample: "test_data_example",
                    empty: "")
    }

    struct Sounds {
        let files = [
            5: (intro: "home_intro_music_placeholder",
                goodEnding: "home_good_ending_example")
        ]
    }

    enum StorySequenceImagePosition {
        case hidden
        case near
        case mid
        case far
    }

    enum StorySequenceImageAnimation {

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
            position: StorySequenceImagePosition?,
            imgAnim: StorySequenceImageAnimation?

        init (txt: String?, img: String?, pos: StorySequenceImagePosition?, ani: StorySequenceImageAnimation?) {
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

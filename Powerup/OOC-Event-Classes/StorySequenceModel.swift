import UIKit

/**
 Struct containing a dictionary of `StorySequence.Step`. Also describes `StorySequence.Step` and `StorySequence.Event`.
 - Author: Cadence Holmes
 */
struct StorySequence {
    var steps: Dictionary<Int, Step>

    /**
     Struct containing descriptions of each character and the different types of images available.
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
    }

    enum StorySequenceImagePosition {
        case hidden
        case near
        case mid
        case far
        case dismiss
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
     Struct describing a single event with text, image, and image position.
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

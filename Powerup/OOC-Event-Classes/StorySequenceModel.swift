import UIKit

/**
 Struct containing a dictionary of `StorySequence.Step`. Describes `StorySequence.Step` and `StorySequence.Event`.
 - Author: Cadence Holmes
 */
struct StorySequence {
    var steps: Dictionary<Int, Step>

    enum StorySequenceImagePosition {
        case hidden
        case start
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

        init (lftEvent: Event?, rgtEvent: Event?) {
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

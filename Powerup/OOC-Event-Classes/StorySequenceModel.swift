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

    /**
     Struct containing two `StorySequence.Event` representing the left and right sides of the `StorySequencePlayer`.
     */
    struct Step {
        var lEvent: Event?,
            rEvent: Event?

        init (lEvent: Event?, rEvent: Event?) {
            self.lEvent = lEvent
            self.rEvent = rEvent
        }
    }

    /**
     Struct describing a single event with text, image, and image position.
     */
    struct Event {
        var text: String?,
            image: String?,
            position: StorySequenceImagePosition?

        init (txt: String?, img: String?, pos: StorySequenceImagePosition?) {
            self.text = txt
            self.image = img
            self.position = pos
        }
    }

    init(_ steps: Dictionary<Int, Step>) {
        self.steps = steps
    }
}

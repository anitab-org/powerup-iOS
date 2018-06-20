/**
 Struct containing music files for easy access
 */
struct Sounds {
    let scenarioMusic = [
        5: (intro: "home_intro_music_placeholder",
            goodEnding: "home_good_ending_example")
    ]
}

/**
 Struct containing a dictionary of `StorySequence.Step`. Also describes `StorySequence.Step` and `StorySequence.Event`.
 - Author: Cadence Holmes
 */
struct StorySequence {
    var steps: Dictionary<Int, Step>,
        music: String?

    /**
     Struct containing descriptions of each character and the different types of images available.

     As new scenes are added, this static data should be updated. Each character should be represented as a descriptive constant, and should reference a tuple describing the images and referencing their file name.

     Thanks to autocompletion, this makes it much easier to create and maintain StorySequence models rather than using just strings.
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

    enum ImagePosition: String {
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

    enum ImageAnimation: String {
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

/**
 Stuct describing all collections of story sequences. Defined in StorySequence.swift. Called in ScenarioViewController.startSequence()

 Important: Contains references to instances of StorySequence defined in StorySequence.swift

 Each key is the ScenarioID, the value is a StorySequence.
 */
struct StorySequences {
    let intros: Dictionary<Int, StorySequence>
    let outros: Dictionary<Int, Dictionary<Int, StorySequence>>

    init() {
        intros = [
            5: home
        ]

        outros = [
            5: [
                1: homeOutro
            ]
        ]
    }
}

// MARK: Scenario 5 - Home
// define each story sequence as a private let, named descriptively
// a StorySequence is a dictionary of StorySequenceStep, keys must be Int and serve to make the collection more readable as well as giving better access to starting a sequence in the middle
// a StorySequenceStep describes two StorySequenceEvent, a left event and a right event.
// A StorySequenceEvent describes the text, image, and image position.
// if any properties are left nil, there will be no change from the previous step
// you can nil the entire event as well (for no change from the previous step)
// calling .dismiss in the pos property hides *and* releases the image from the imageView
private let pos = StorySequence.ImagePosition.self
private let ani = StorySequence.ImageAnimation.self
private let testChar = StorySequence.Images().testChar
private let testChar2 = StorySequence.Images().testChar2
private let misc = StorySequence.Images().misc
private let home: StorySequence = StorySequence(music: Sounds().scenarioMusic[5]?.intro, [
    0: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Hey, this is an intro sequence!",
                                                        img: testChar.happy,
                                                        pos: pos.near,
                                                        ani: ani.shake),
                          rgtEvent: nil
    ),
    1: StorySequence.Step(lftEvent: nil,
                          rgtEvent: StorySequence.Event(txt: "You can change the images in each step, and each side is independent.",
                                                        img: testChar2.normal,
                                                        pos: pos.near,
                                                        ani: ani.tiltLeft)
    ),
    2: StorySequence.Step(lftEvent: StorySequence.Event(txt: "The images can move to different positions.",
                                                        img: nil,
                                                        pos: pos.mid,
                                                        ani: ani.tiltRight),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar2.upset,
                                                        pos: nil,
                                                        ani: ani.jiggle)
    ),
    3: StorySequence.Step(lftEvent: StorySequence.Event(txt: "You describe it in a model of steps and events. Passing nil to a value tells it to stay the same.",
                                                        img: testChar.talking,
                                                        pos: pos.near,
                                                        ani: ani.flip),
                          rgtEvent: nil
    ),
    4: StorySequence.Step(lftEvent: nil,
                          rgtEvent: StorySequence.Event(txt: "See? The left image didn't move or change!",
                                                        img: testChar2.scared,
                                                        pos: pos.far,
                                                        ani: nil)
    ),
    5: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Things can happen on one or both sides. Now both images are hidden.",
                                                        img: nil,
                                                        pos: pos.hidden,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: nil,
                                                        pos: pos.hidden,
                                                        ani: nil)
    ),
    6: StorySequence.Step(lftEvent: StorySequence.Event(txt: "A `StorySequence` is just a collection of `Steps`!",
                                                        img: testChar.normal,
                                                        pos: pos.far,
                                                        ani: nil),
                          rgtEvent: nil
    ),
    7: StorySequence.Step(lftEvent: StorySequence.Event(txt: "This is what the data looks like for a single step. It's two events, left and right.",
                                                        img: testChar.scared,
                                                        pos: pos.mid,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: misc.dataExample,
                                                        pos: pos.near,
                                                        ani: nil)
    ),
    8: StorySequence.Step(lftEvent: StorySequence.Event(txt: nil,
                                                        img: testChar.normal,
                                                        pos: pos.near,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: "It's not that bad!",
                                                        img: nil,
                                                        pos: pos.far,
                                                        ani: nil)
    ),
    9: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Oh yea! There's also predefined animations to give your characters some character.",
                                                        img: testChar.talking,
                                                        pos: pos.near,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: nil,
                                                        pos: pos.hidden,
                                                        ani: nil)
    ),
    10: StorySequence.Step(lftEvent: StorySequence.Event(txt: "But that's it for now! Thanks for listening!",
                                                         img: testChar.normal,
                                                         pos: pos.mid,
                                                         ani: nil),
                           rgtEvent: StorySequence.Event(txt: nil,
                                                         img: "minesweeper_abstinence_heart",
                                                         pos: pos.far,
                                                         ani: nil)
    )
])

// MARK: Example outro - scenario 5 - popupID -1
private let testChar3 = StorySequence.Images().testChar3
private let homeOutro: StorySequence = StorySequence(music: Sounds().scenarioMusic[5]?.goodEnding, [
    0: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Hi everyone, we're back!",
                                                        img: testChar2.smiling,
                                                        pos: pos.mid,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar.happy,
                                                        pos: pos.mid,
                                                        ani: nil)
    ),
    1: StorySequence.Step(lftEvent: StorySequence.Event(txt: nil,
                                                        img: testChar2.normal,
                                                        pos: pos.near,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: "Outro sequences are just like an intro sequence, except they are triggered by the PopupID value.",
                                                        img: testChar.lecturing,
                                                        pos: nil,
                                                        ani: nil)
    ),
    2: StorySequence.Step(lftEvent: StorySequence.Event(txt: "When an answer record has a positive int, it looks for a popup.",
                                                        img: testChar2.talking,
                                                        pos: nil,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar.normal,
                                                        pos: pos.near,
                                                        ani: nil)
    ),
    3: StorySequence.Step(lftEvent: StorySequence.Event(txt: nil,
                                                        img: testChar2.normal,
                                                        pos: nil,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: "But when it has a negative int, it looks to end the scenario with an outro sequence!",
                                                        img: testChar.talking,
                                                        pos: pos.far,
                                                        ani: nil)
    ),
    4: StorySequence.Step(lftEvent: StorySequence.Event(txt: "We think all of these story sequences can be used in different ways.",
                                                        img: testChar2.lecturing,
                                                        pos: nil,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar.scared,
                                                        pos: pos.near,
                                                        ani: ani.jiggle)
    ),
    5: StorySequence.Step(lftEvent: StorySequence.Event(txt: "We might be characters in the story, and we could just continue the scene with a script.",
                                                        img: testChar2.talking,
                                                        pos: pos.mid,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar.happy,
                                                        pos: nil,
                                                        ani: ani.tiltLeft)
    ),
    6: StorySequence.Step(lftEvent: StorySequence.Event(txt: nil,
                                                        img: nil,
                                                        pos: pos.hidden,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: "We could also address the player directly and be truly Out-Of-Character.",
                                                        img: testChar.talking,
                                                        pos: pos.far,
                                                        ani: nil)
    ),
    7: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Or introduce new characters of authority to talk about important things!",
                                                        img: testChar3.normal,
                                                        pos: pos.mid,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar.dazed,
                                                        pos: pos.near,
                                                        ani: ani.shake)
    ),
    8: StorySequence.Step(lftEvent: StorySequence.Event(txt: nil,
                                                        img: nil,
                                                        pos: pos.hidden,
                                                        ani: ani.flip),
                          rgtEvent: StorySequence.Event(txt: "Soon, we'll have some more concrete examples of what these scenes could look like.",
                                                        img: testChar.whatever,
                                                        pos: nil,
                                                        ani: nil)
    ),
    9: StorySequence.Step(lftEvent: StorySequence.Event(txt: "As well as documentation on exactly how to build the models to make these scenes work!",
                                                        img: testChar2.smiling,
                                                        pos: pos.near,
                                                        ani: ani.tiltRight),
                          rgtEvent: StorySequence.Event(txt: "Thanks!",
                                                        img: testChar.smiling,
                                                        pos: pos.near,
                                                        ani: ani.tiltLeft)
    )
])

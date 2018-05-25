import Foundation

/**
 Defined in StorySequence.swift. Called in ScenarioViewController.startSequence()
 
 Important: Contains references to instances of StorySequence defined in StorySequence.swift
 
 Each key is the ScenarioID, the value is a StorySequence.
 */
let introStorySequences: Dictionary<Int, StorySequence> = [
    5: home
]

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
private let home: StorySequence = StorySequence([
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

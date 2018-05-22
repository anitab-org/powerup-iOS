//
//  StorySequences.swift
//  Powerup
//
//  Created by KD on 5/15/18.
//  Copyright © 2018 Systers. All rights reserved.
//

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
private let testChar = StorySequence.Images().testChar
private let testChar2 = StorySequence.Images().testChar2
private let home: StorySequence = StorySequence([
    0: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Hey, this is an intro sequence!",
                                                        img: testChar.normal,
                                                        pos: .near,
                                                        ani: nil),
                          rgtEvent: nil
    ),
    1: StorySequence.Step(lftEvent: nil,
                          rgtEvent: StorySequence.Event(txt: "You can change the images in each step, and each side is independent.",
                                                        img: testChar2.sad,
                                                        pos: .near,
                                                        ani: nil)
    ),
    2: StorySequence.Step(lftEvent: StorySequence.Event(txt: "The images can move to different positions.",
                                                        img: nil,
                                                        pos: .mid,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: testChar2.upset,
                                                        pos: nil,
                                                        ani: nil)
    ),
    3: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Passing nil to a side just leaves everything alone",
                                                        img: testChar.talking,
                                                        pos: .near,
                                                        ani: nil),
                          rgtEvent: nil
    ),
    4: StorySequence.Step(lftEvent: nil,
                          rgtEvent: StorySequence.Event(txt: "See? The left side didn't change",
                                                        img: testChar2.scared,
                                                        pos: .far,
                                                        ani: nil)
    ),
    5: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Now both images are hidden.",
                                                        img: nil,
                                                        pos: .hidden,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: nil,
                                                        img: nil,
                                                        pos: .hidden,
                                                        ani: nil)
    ),
    6: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Surprise!",
                                                        img: testChar.normal,
                                                        pos: .far,
                                                        ani: nil),
                          rgtEvent: nil
    )
])

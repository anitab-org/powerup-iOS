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
private let home: StorySequence = StorySequence([
    0: StorySequence.Step(lftEvent: StorySequence.Event(txt: "left text event, step 0",
                                                        img: "test_image_normal",
                                                        pos: .start,
                                                        ani: nil),
                          rgtEvent: nil
    ),
    1: StorySequence.Step(lftEvent: nil,
                          rgtEvent: StorySequence.Event(txt: "left text event, step 0",
                                                        img: "test_image_normal",
                                                        pos: .start,
                                                        ani: nil)
    ),
    2: StorySequence.Step(lftEvent: StorySequence.Event(txt: "left text event, step 0",
                                                        img: "test_image_normal",
                                                        pos: .start,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: "left text event, step 0",
                                                        img: "test_image_normal",
                                                        pos: .start,
                                                        ani: nil)
    ),
    3: StorySequence.Step(lftEvent: StorySequence.Event(txt: "left text event, step 0",
                                                        img: "test_image_normal",
                                                        pos: .start,
                                                        ani: nil),
                          rgtEvent: nil
    ),
    4: StorySequence.Step(lftEvent: StorySequence.Event(txt: "left text event, step 0",
                                                        img: "test_image_normal",
                                                        pos: .start,
                                                        ani: nil),
                          rgtEvent: nil
    )
])

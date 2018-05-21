//
//  StorySequenceModel.swift
//  Powerup
//
//  Created by KD on 5/15/18.
//  Copyright © 2018 Systers. All rights reserved.
//

import UIKit

enum StorySequenceImagePosition {
    case hidden
    case start
    case mid
    case far
    case dismiss
}

struct StorySequenceEvent {
    var text: String?,
    image: String?,
    position: StorySequenceImagePosition?
    
    init (txt: String?, img: String?, pos: StorySequenceImagePosition?) {
        self.text = txt
        self.image = img
        self.position = pos
    }
}

struct StorySequenceStep {
    var lEvent: StorySequenceEvent?,
    rEvent: StorySequenceEvent?
    
    init (lEvent: StorySequenceEvent?, rEvent: StorySequenceEvent?) {
        self.lEvent = lEvent
        self.rEvent = rEvent
    }
}

struct StorySequence {
    var steps: Dictionary<Int, StorySequenceStep>
    
    init (_ steps: Dictionary<Int, StorySequenceStep>) {
        self.steps = steps
    }
}

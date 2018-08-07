import Foundation

/**
 Struct is responsible for retrieving and parsing StorySequences.json into a Swift datatype. It describes all instances of StorySequence.

 - Author: Cadence Holmes 2018
*/
struct StorySequences {

    // bundle needs to be able to be changed in order to automate testing
    var bundle = Bundle.main

    /**
     Parse `StorySequences.json` and return a formatted `StorySequence`.

     - Parameter scenario: The `scenarioID` of the target scenario.
     - Parameter outro: If `true`, searches for the `outro` event type. Otherwise searches for the `intro` event type.

     - Returns: A formatted `StorySequence`.

     - Throws: `print(error.localizedDescription)` if unable to retrieve data.
     */
    func getStorySequence(scenario: Int, outro: Int? = nil) -> StorySequence? {

        var sequence = StorySequence(music: nil, [:])

        let scenario = String(scenario)
        let key = (outro != nil) ? String(outro!) : nil
        let type = (outro == nil) ? "intros" : "outros"

        // parse events into the correct types once retrieved from json
        func parseEvent(event: Dictionary<String, AnyObject?>?) -> StorySequence.Event? {

            if event == nil {
                return nil
            }

            let p = event?["pos"] as? String
            let a = event?["ani"] as? String

            return StorySequence.Event(txt: event?["txt"] as? String,
                                       img: event?["img"] as? String,
                                       pos: (p != nil) ? StorySequence.ImagePosition(rawValue: p!) : nil,
                                       ani: (a != nil) ? StorySequence.ImageAnimation(rawValue: a!) : nil)
        }

        // change this to the main json containing all sequences
        let fileName = "StorySequences"
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            print("Unable to retrieve Story Sequence JSON.")
            return nil
        }

        do {
            // retrieve json and map to datatype Dictionary<String, AnyObject>
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

            if let json = json as? Dictionary<String, AnyObject> {

                // retrieve the collection of sequences based on type
                guard let sequences = json[type] as? Dictionary<String, AnyObject?> else {
                    print("Unable to retrieve sequences of type: \(type).")
                    return nil
                }

                var seq: Dictionary<String, AnyObject?>

                // handle intros and outros
                if key != nil {

                    // if there's a secondary key, then it's an outro - retrieve outros for scenario, then correct outro
                    let i = key!
                    guard let outros = sequences[scenario] as? Dictionary<String, AnyObject?> else {
                        print("Unable to retrieve outro sequences for scenario: \(scenario).")
                        return nil
                    }

                    guard let outro = outros[i] as? Dictionary<String, AnyObject?> else {
                        print("Unable to retrieve outro sequence for scenario - key: \(scenario) - \(i).")
                        return nil
                    }

                    seq = outro
                } else {

                    // if there's no secondary key, then it's an intro - retrieve intro for scenario
                    guard let intro = sequences[scenario] as? Dictionary<String, AnyObject?> else {
                        print("Unable to retrieve intro sequence for scenario: \(scenario).")
                        return nil
                    }

                    seq = intro
                }

                sequence.music = seq["music"] as? String

                guard let steps = seq["steps"] as? Dictionary<String, AnyObject?> else {
                    print("Unable to retrieve steps for: \(type) - \(scenario) - \(String(describing: key)).")
                    return nil
                }

                for step in steps {

                    guard let i = Int(step.key) else {
                        print("Key is not an Int")
                        return nil
                    }

                    guard let events = step.value as? Dictionary<String, AnyObject?> else {
                        print("Unable to retrieve step for key: \(i)")
                        continue
                    }

                    let lft = events["lftEvent"] as? Dictionary<String, AnyObject?>
                    let rgt = events["rgtEvent"] as? Dictionary<String, AnyObject?>

                    let lftEvent = parseEvent(event: lft)
                    let rgtEvent = parseEvent(event: rgt)

                    let newStep = StorySequence.Step(lftEvent: lftEvent, rgtEvent: rgtEvent)

                    sequence.steps[i] = newStep
                }

            }

        } catch let error {
            print(error.localizedDescription)
        }

        return sequence

    }

}

// MARK: Example data sets

/*

 Example Datasets

 While StorySequencePlayer expects to parse a file called StorySequences.json, which is created in an external tool, the resultant Swift dataset ultimately looks like the following examples.

 - define each story sequence as a private let, named descriptively
 - a StorySequence is a dictionary of StorySequenceStep, keys must be an Int
 - a StorySequenceStep describes two StorySequenceEvent, a left event and a right event.
 - A StorySequenceEvent describes the text, image, and image position.
 - if any properties are left nil, there will be no change from the previous step
 - you can nil the entire event as well (for no change from the previous step)

*/

/*
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
    5: StorySequence.Step(lftEvent: StorySequence.Event(txt: "Things can happen on one or both sides.",
                                                        img: nil,
                                                        pos: pos.hidden,
                                                        ani: nil),
                          rgtEvent: StorySequence.Event(txt: "Now both images are hidden!",
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
*/

/** ************** */
// Example outro

/*
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
*/

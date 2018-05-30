/**
 Struct containing dictionaries of popup events. Defined in PopupEvents.swift.
 */
struct PopupEvents {
    let scenarioPopups: Dictionary<Int, Dictionary<Int, PopupEvent>>

    init() {
        scenarioPopups = [
            5: homePopups
        ]
    }
}

// MARK: Home Popups
/**
 Dictionary containing descriptions of PopupEvent instances for the Home scenario. Keys reference Answer.popupID. Defined in PopupEvents.swift.
 */
let homePopups = [
    1: PopupEvent(topText: "test model 1",
                  botText: "has sound",
                  imgName: "minesweeper_abstinence_heart",
                  doSound: true),

    2: PopupEvent(topText: "test model 2 with longer text it should shrink to fit",
                  botText: "no sound",
                  imgName: "karma_star",
                  doSound: false),

    3: PopupEvent(topText: "test model 3, big image should aspect fit in view",
                  botText: "has sound",
                  imgName: "home_background",
                  doSound: true),

    4: PopupEvent(topText: "",
                  botText: "",
                  imgName: "display_clothes_01",
                  doSound: true),

    5: PopupEvent(topText: "test model 5, nil image, has sound",
                  botText: "but since no image should only play first sound",
                  imgName: nil,
                  doSound: true),

    6: PopupEvent(topText: "test model 6, image named doesnt exist",
                  botText: "has sound, but only plays first sound",
                  imgName: "wjqvwniiovnuiohvwjqioniioqdlknuv",
                  doSound: true)
]

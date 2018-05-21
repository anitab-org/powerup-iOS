/**
 Struct defining PopupEvent model.
 
 - Author:
 Cadence Holmes
 */
struct PopupEvent {
    var mainText: String?
    var subText: String?
    var image: String?
    var useSound: Bool?

    init (mainText: String?, subText: String?, image: String?, useSound: Bool?) {
        self.mainText = mainText
        self.subText = subText
        self.image = image
        self.useSound = useSound
    }
}

/**
 Dictionary containing descriptions of PopupEvent instances. Keys reference Answer.popupID.
 */
let popupEvents = [
    1: PopupEvent(mainText: "test model 1",
                  subText: "has sound",
                  image: "minesweeper_abstinence_heart",
                  useSound: true),
    2: PopupEvent(mainText: "test model 2 with longer text it should shrink to fit",
                  subText: "no sound",
                  image: "karma_star",
                  useSound: false),
    3: PopupEvent(mainText: "test model 3, big image should aspect fit in view",
                  subText: "has sound",
                  image: "home_background",
                  useSound: true),
    4: PopupEvent(mainText: "",
                  subText: "",
                  image: "display_clothes_01",
                  useSound: true),
    5: PopupEvent(mainText: "test model 5, nil image, has sound",
                  subText: "but since no image should only play first sound",
                  image: nil,
                  useSound: true),
    6: PopupEvent(mainText: "test model 6, image named doesnt exist",
                  subText: "has sound, but only plays first sound",
                  image: "wjqvwniiovnuiohvwjqioniioqdlknuv",
                  useSound: true)
]

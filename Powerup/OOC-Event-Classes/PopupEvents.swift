/**
 Dictionary containing descriptions of PopupEvent instances. Keys reference Answer.popupID.
 */
let popupEvents = [
    1: PopupEventPlayer.Event(topText: "test model 1",
                              botText: "has sound",
                              imgName: "minesweeper_abstinence_heart",
                              doSound: true),

    2: PopupEventPlayer.Event(topText: "test model 2 with longer text it should shrink to fit",
                              botText: "no sound",
                              imgName: "karma_star",
                              doSound: false),

    3: PopupEventPlayer.Event(topText: "test model 3, big image should aspect fit in view",
                              botText: "has sound",
                              imgName: "home_background",
                              doSound: true),

    4: PopupEventPlayer.Event(topText: "",
                              botText: "",
                              imgName: "display_clothes_01",
                              doSound: true),

    5: PopupEventPlayer.Event(topText: "test model 5, nil image, has sound",
                              botText: "but since no image should only play first sound",
                              imgName: nil,
                              doSound: true),

    6: PopupEventPlayer.Event(topText: "test model 6, image named doesnt exist",
                              botText: "has sound, but only plays first sound",
                              imgName: "wjqvwniiovnuiohvwjqioniioqdlknuv",
                              doSound: true)
]

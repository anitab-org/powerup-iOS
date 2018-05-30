/**
 Struct defining Event model for individual popups.
 */
struct PopupEvent {
    var topText: String?
    var botText: String?
    var imgName: String?
    var doSound: Bool?

    init (topText: String?, botText: String?, imgName: String?, doSound: Bool?) {
        self.topText = topText
        self.botText = botText
        self.imgName = imgName
        self.doSound = doSound
    }
}

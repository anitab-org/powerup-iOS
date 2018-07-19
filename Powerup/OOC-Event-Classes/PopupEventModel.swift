/**
 Struct defining Event model for individual popups.
 */
struct PopupEvent {
    var topText: String?
    var botText: String?
    var imgName: String?
    var slideSound: String?
    var badgeSound: String?

    init (topText: String?, botText: String?, imgName: String?, slideSound: String?, badgeSound: String?) {
        self.topText = topText
        self.botText = botText
        self.imgName = imgName
        self.slideSound = slideSound
        self.badgeSound = badgeSound
    }
}

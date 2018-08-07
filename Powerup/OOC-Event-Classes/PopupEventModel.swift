/**
 Struct defining Event model for individual popups.

```
- Parameters:
    - topText: The larger text at the top of the popup. Contained in its own `UILabel`.
    - botText: The smaller text at the bottom of the popup. Contained in its own `UILabel`.
    - imgName: The file name of the image asset to use as a badge icon. Ignored if left `nil`.
    - slideSound: The file name of the media asset to be played when the popup is slides into view. No sound is played if left `nil`.
    - badgeSound: The file name of the media asset to be played when/if a badge icon is displayed. No sound is played if left `nil`.
 ```

  - Author: Cadence Holmes 2018
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

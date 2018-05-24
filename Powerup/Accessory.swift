/** Data model for accessories (i.e. Eyes, Hair, etc) */
import UIKit

// The types of the accessories.
enum AccessoryType: String {
    case face = "Face"
    case eyes = "Eyes"
    case hair = "Hair"
    case clothes = "Clothes"
    case necklace = "Necklace"
    case handbag = "Handbag"
    case hat = "Hat"
    case glasses = "Glasses"
    case unknown = ""
}

struct Accessory {

    // The type of the accessory.
    var type: AccessoryType

    // Each accessory has a unique ID.
    var id: Int

    // The image of the accessory.
    var image: UIImage?

    // The image shown in Shop Scene boxes.
    var displayImage: UIImage?

    // The price to buy the accessory.
    var points: Int

    // Whether the accessory is purchased yet.
    var purchased: Bool

    init(type: AccessoryType, id: Int, imageName: String, points: Int, purchased: Bool) {
        self.type = type
        self.id = id
        self.image = UIImage(named: imageName)
        self.points = points
        self.purchased = purchased

        // Set display image. Avatar image is prefixed with "avatar_", display image is prefixed with "display_", so we have to substring from '_' and prefix it with "display".
        //let fromIndex = imageName.characters.count >= 6 ? imageName.index(imageName.startIndex, offsetBy: 6) : imageName.startIndex
        //let displayName = "display" + imageName.substring(from: fromIndex)
        let fromIndex = imageName.count >= 6 ? imageName.index(imageName.startIndex, offsetBy: 6) : imageName.startIndex
        let displayName = "display" + String(imageName[fromIndex...])
        self.displayImage = UIImage(named: displayName)
    }

    init(type: AccessoryType) {
        do {
            self = try DatabaseAccessor.sharedInstance.getAccessory(accessoryType: type, accessoryIndex: 1)
        } catch _ {
            self.type = .unknown
            self.id = 0
            self.image = nil
            self.displayImage = nil
            self.points = 0
            self.purchased = false
        }
    }
}

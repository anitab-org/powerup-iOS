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
}

struct Accessory {

    // The type of the accessory.
    var type: AccessoryType
    
    // Each accessory has a unique ID.
    var id: Int
    
    // The image of the accessory.
    var image: UIImage?
    
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
    }
    
    init(type: AccessoryType) {
        self = DatabaseAccessor.sharedInstance.getAccessory(accessoryType: type, accessoryIndex: 1)
    }
}

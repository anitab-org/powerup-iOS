/** Data model for accessories (i.e. Eyes, Hair, etc) */
import UIKit

struct Accessory {
    // The type of the accessory. (i.e. Hair, Glasses, etc.)
    var type: String
    
    // Each accessory has a unique ID.
    var id: Int
    
    // The image of the accessory.
    var image: UIImage?
    
    // The price to buy the accessory.
    var points: Int
    
    // Whether the accessory is purchased yet.
    var purchased: Bool
        
    init(type: String, id: Int, imageName: String, points: Int, purchased: Bool) {
        self.type = type
        self.id = id
        self.image = UIImage(named: imageName)
        self.points = points
        self.purchased = purchased
    }
    
    init(type: String) {
        self = DatabaseAccessor.sharedInstance().getAccessory(accessoryType: type, accessoryIndex: 1)
    }
}

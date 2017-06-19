/** Data model for accessories (i.e. Eyes, Hair, etc) */
import UIKit

struct Accessory {
    var type: String
    var id: Int
    var image: UIImage?
    var points: Int
    var purchased: Bool
    
    init(type: String, id: Int, imageName: String, points: Int, purchased: Bool) {
        self.type = type
        self.id = id
        self.image = UIImage(named: imageName)
        self.points = points
        self.purchased = purchased
    }
    
    init(type: String) {
        self = DatabaseAccessor.sharedInstance.getAccessory(accessoryType: type, accessoryIndex: 1)
    }
}

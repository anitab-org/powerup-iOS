import UIKit

// Stores the image names of each customizable parts of the avatar.
struct Customizables {
    // Use UserDefault for storing customized avatar now, will be changed after Firebase integration.
    static let avatarKey = "Avatar"
    
    static let clothes = [
        "cloth1",
        "cloth2",
        "cloth3",
        "cloth4",
        "cloth5",
        "cloth6",
        "cloth7",
        "cloth8",
        "cloth9"
    ]
    
    static let faces = [
        "brick_face",
        "yellow_face",
        "orange_face",
        "peach_face"
    ]
    
    static let hairs = [
        "hair2",
        "hair3",
        "hair4",
        "hair5",
        "hair6",
        "hair7",
        "hair8",
        "hair9",
        "hair10",
        "hair11"
    ]
    
    static let eyes = [
        "blue_eyes",
        "brown_eyes",
        "green_eyes",
        "lightGreen_eyes",
        "lightPink_eyes",
        "grey_eyes",
        "pink_eyes"
    ]
    
    static let handbags = [
        "purse1",
        "purse2",
        "purse3",
        "purse4"
    ]
    
    static let glasses = [
        "glasses1",
        "glasses2",
        "glasses3"
    ]
    
    static let necklace = [
        "necklace1",
        "necklace2",
        "necklace3",
        "necklace4"
    ]
    
    static let hats = [
        "hat1",
        "hat2",
        "hat4",
        "hat5"
    ]
    
    /**
     Apply customized appearence to the avatar
    **/
    static func applyCustomizables(clothes clothesView: UIImageView, face faceView: UIImageView, hair hairView: UIImageView, eyes eyesView: UIImageView, handBag handbagView: UIImageView, glasses glassesView: UIImageView, necklace necklaceView: UIImageView, hat hatView: UIImageView) {
        
        // Initialize avatar images
        if let avatarConfig = UserDefaults.standard.dictionary(forKey: Customizables.avatarKey) as! [String: Int]? {
            
            // Essential customizables
            eyesView.image = UIImage(named: Customizables.eyes[avatarConfig["eyes"]!])
            faceView.image = UIImage(named: Customizables.faces[avatarConfig["face"]!])
            hairView.image = UIImage(named: Customizables.hairs[avatarConfig["hair"]!])
            clothesView.image = UIImage(named: Customizables.clothes[avatarConfig["clothes"]!])
            
            // Optional customizables
            if let necklaceConfig = avatarConfig["necklace"] {
                necklaceView.image = UIImage(named: Customizables.necklace[necklaceConfig])
            }
            
            if let hatConfig = avatarConfig["hat"] {
                hatView.image = UIImage(named: Customizables.hats[hatConfig])
            }
            
            if let handbagConfig = avatarConfig["hanbag"] {
                handbagView.image = UIImage(named: Customizables.handbags[handbagConfig])
            }
            
            if let glassesConfig = avatarConfig["glasses"] {
                glassesView.image = UIImage(named: Customizables.glasses[glassesConfig])
            }
            
        } else {
            print("Error fetching avatar data.")
        }
    }
}

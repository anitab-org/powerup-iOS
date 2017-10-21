/** This struct is a data model for avatar features (customizables). */

struct Avatar {
    var id: Int
    
    // Required accessories.
    var face: Accessory
    var eyes: Accessory
    var hair: Accessory
    var clothes: Accessory
    
    // Optional accessories (Should be bought at the store).
    var necklace: Accessory?
    var glasses: Accessory?
    var handbag: Accessory?
    var hat: Accessory?

    init(avatarID: Int, face: Accessory, eyes: Accessory, hair: Accessory, clothes: Accessory, necklace: Accessory?, glasses: Accessory?, handbag: Accessory?, hat: Accessory?) {
        self.id = avatarID
        
        self.face = face
        self.eyes = eyes
        self.hair = hair
        self.clothes = clothes
        
        self.necklace = necklace
        self.glasses = glasses
        self.handbag = handbag
        self.hat = hat
    }
    
    init() {
        self.id = DatabaseAccessor.sharedInstance.avatarID
        
        self.face = Accessory(type: .face)
        self.eyes = Accessory(type: .eyes)
        self.hair = Accessory(type: .hair)
        self.clothes = Accessory(type: .clothes)
        
        self.necklace = nil
        self.glasses = nil
        self.handbag = nil
        self.hat = nil
    }
    
    // A convenient way to get the avatar's accessory by its type.
    func getAccessoryByType(_ type: AccessoryType) -> Accessory? {
        switch type {
        case .face:
            return face
        case .eyes:
            return eyes
        case .hair:
            return hair
        case .clothes:
            return clothes
        case .necklace:
            return necklace
        case .glasses:
            return glasses
        case .handbag:
            return handbag
        case .hat:
            return hat
        default:
            return nil
        }
    }
    
    // A convenient way to set the avatar's accessory by its type.
    mutating func setAccessoryByType(_ type: AccessoryType, accessory: Accessory?) {
        switch type {
        // These accessories can't be set the nil.
        case .face:
            if accessory == nil { return }
            face = accessory!
        case .eyes:
            if accessory == nil { return }
            eyes = accessory!
        case .hair:
            if accessory == nil { return }
            hair = accessory!
        case .clothes:
            if accessory == nil { return }
            clothes = accessory!
        
        case .necklace:
            necklace = accessory
        case .glasses:
            glasses = accessory
        case .handbag:
            handbag = accessory
        case .hat:
            hat = accessory
        default: break
        }
    }
}

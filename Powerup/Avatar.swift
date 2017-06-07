/** This struct is a data model for avatar features (customizables). */

struct Avatar {
    var id: Int
    
    // Required features
    var face: Int
    var eyes: Int
    var hair: Int
    var clothes: Int
    
    // Optional features
    var necklace: Int?
    var glasses: Int?
    var handbag: Int?
    var hat: Int?
}

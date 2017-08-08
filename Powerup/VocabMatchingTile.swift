import SpriteKit

/** This class is for the tiles of the Vocab Matching Game. */
class VocabMatchingTile: SKSpriteNode {
    
    // MARK: Properties
    // The correct clipboard for this tile will have the same matching id.
    var matchingID: Int
    
    // Which lane is the tile currently on.
    var laneNumber: Int = -1
    
    // The description shown on the corresponding clipboard.
    var descriptionText: String
    
    // MARK: Constructors
    init(matchingID: Int, textureName: String, descriptionText: String, size: CGSize) {
        self.matchingID = matchingID
        self.descriptionText = descriptionText
        super.init(texture: SKTexture(imageNamed: textureName), color: UIColor.clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
}

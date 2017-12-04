import SpriteKit

/** This class is for the tiles of the Vocab Matching Game. */
class VocabMatchingTile: SKSpriteNode {
    
    // MARK: Properties
    // The correct clipboard for this tile will have the same matching id.
    @objc var matchingID: Int
    
    // Which lane is the tile currently on.
    @objc var laneNumber: Int = -1
    
    // The description shown on the corresponding clipboard.
    @objc var descriptionText: String
    
    // MARK: Constructors
    @objc init(matchingID: Int, textureName: String, descriptionText: String, size: CGSize) {
        self.matchingID = matchingID
        self.descriptionText = descriptionText
        super.init(texture: SKTexture(imageNamed: textureName), color: UIColor.clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
}

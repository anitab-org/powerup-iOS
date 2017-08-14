import SpriteKit

/** This class is for the clipboards of the Vocab Matching Game. */
class VocabMatchingClipboard: SKSpriteNode {
    
    // MARK: Constant
    let descriptionTextPosX = 0.19
    let descriptionTextPosY = -0.1
    
    // MARK: Properties
    // The correct tile for this clipboard will have the same matching id.
    var matchingID: Int
    
    // Description text
    let descriptionLabel = SKLabelNode()
    
    // Wrapper node for the text.
    let descriptionWrapperNode = SKNode()
    let textLayer = CGFloat(0.01)
    
    // MARK: Constructors
    init(texture: SKTexture?, size: CGSize, matchingID: Int, description: String) {
        self.matchingID = matchingID
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        
        // Description label.
        descriptionLabel.text = description
        
        descriptionWrapperNode.position = CGPoint(x: descriptionTextPosX * Double(size.width), y: descriptionTextPosY * Double(size.height))
        descriptionWrapperNode.zPosition = textLayer
        
        descriptionWrapperNode.addChild(descriptionLabel)
        addChild(descriptionWrapperNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
}

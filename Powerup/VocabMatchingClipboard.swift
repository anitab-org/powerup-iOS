import SpriteKit

/** This class is for the clipboards of the Vocab Matching Game. */
class VocabMatchingClipboard: SKSpriteNode {
    
    // MARK: Constant
    @objc let descriptionTextPosX = 0.19
    @objc let descriptionTextPosY = -0.1
    
    // MARK: Properties
    // The correct tile for this clipboard will have the same matching id.
    @objc var matchingID: Int
    
    // Description text
    @objc let descriptionLabel = SKLabelNode()
    
    // Wrapper node for the text.
    @objc let descriptionWrapperNode = SKNode()
    @objc let textLayer = CGFloat(0.01)
    
    // MARK: Constructors
    @objc init(texture: SKTexture?, size: CGSize, matchingID: Int, description: String) {
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

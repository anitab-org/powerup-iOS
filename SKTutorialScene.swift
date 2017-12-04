import SpriteKit

/** This class is for the tutorial scenes of the mini games. It presents a sequence of tutorial images. When the user taps on each image, the next image will be shown. It will remove itself from the parent node after the last tutorial image, and run the start game code. */
class SKTutorialScene: SKSpriteNode {
    // MARK: Properties
    
    // The tutorial image sequence.
    @objc var imageSequence: [SKTexture]
    
    @objc var currIndex = 0
    
    // This closure will automatically be run after the last image.
    @objc var startGameFunc: () -> Void
    
    // MARK: Functions
    @objc func nextImage() {
        currIndex += 1
        
        // Update the texture (image).
        texture = imageSequence[currIndex]
    }
    
    // MARK: Constructors
    @objc init(namedImages: [String], size: CGSize, startGameFunc: @escaping () -> Void) {
        // Initialize the image sequence.
        imageSequence = [SKTexture]()
        for namedImage in namedImages {
            imageSequence.append(SKTexture(imageNamed: namedImage))
        }
        
        self.startGameFunc = startGameFunc
        
        super.init(texture: imageSequence.first, color: UIColor.clear, size: size)
        
        // touchesBegan(_:with:) would be called if only isUserInteractionEnabled is true.
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    // MARK: Touch Input
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currIndex < imageSequence.count - 1 {
            nextImage()
        } else {
            // The last image.
            removeFromParent()
            
            // Run the start game closure.
            startGameFunc()
        }
    }
}

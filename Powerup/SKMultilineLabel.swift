import SpriteKit

//  ======================== Modified from ======================== //
//  Created by Craig on 10/04/2015.                                 //
//  Copyright (c) 2015 Interactive Coconut.                         //
//  MIT License, http://www.opensource.org/licenses/mit-license.php //
//  =============================================================== //

/** SpriteKit doesn't provide labels spanning multiple lines. Use this node instead. */
class SKMultilineLabel: SKNode {
    
    // MARK: Properties
    var labelWidth: Int { didSet {update()} }
    var labelHeight: Int = 0
    var text: String { didSet { update() } }
    var fontName: String { didSet { update() } }
    var fontSize: CGFloat { didSet { update() } }
    var pos: CGPoint { didSet { update() } }
    var fontColor: UIColor { didSet { update() } }
    var leading: Int { didSet { update() } }
    var alignment: SKLabelHorizontalAlignmentMode { didSet { update() } }
    
    var labels: [SKLabelNode] = []
    
    // MARK: Constructor
    init(text: String, labelWidth: Int, pos: CGPoint, fontName: String, fontSize: CGFloat, fontColor: UIColor, leading: Int? = nil, alignment: SKLabelHorizontalAlignmentMode = .center) {
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = leading ?? Int(fontSize)
        self.alignment = alignment
        
        super.init()
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: Functions
    func update() {
        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        let separators = NSCharacterSet.whitespacesAndNewlines
        let words = (text as NSString).components(separatedBy: separators)
        var finalLine = false
        var wordCount = -1
        var lineCount = 0
        while (!finalLine) {
            lineCount+=1
            var lineLength = CGFloat(0)
            var lineString = ""
            var lineStringBeforeAddingWord = ""
            
            // creation of the SKLabelNode itself
            let label = SKLabelNode(fontNamed: fontName)
            // name each label node so you can animate it if u wish
            label.name = "line\(lineCount)"
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = fontColor
            
            while lineLength < CGFloat(labelWidth)
            {
                wordCount+=1
                if wordCount > words.count-1
                {
                    //label.text = "\(lineString) \(words[wordCount])"
                    finalLine = true
                    break
                }
                else
                {
                    lineStringBeforeAddingWord = lineString
                    lineString = "\(lineString) \(words[wordCount])"
                    label.text = lineString
                    lineLength = label.frame.width
                }
            }
            if lineLength > 0 {
                wordCount-=1
                if (!finalLine) {
                    lineString = lineStringBeforeAddingWord
                }
                label.text = lineString
                var linePos = pos
                if (alignment == .left) {
                    linePos.x -= CGFloat(labelWidth / 2)
                } else if (alignment == .right) {
                    linePos.x += CGFloat(labelWidth / 2)
                }
                linePos.y += CGFloat(-leading * lineCount)
                label.position = CGPoint(x:linePos.x , y:linePos.y )
                self.addChild(label)
                labels.append(label)
            }
        }
        
        labelHeight = lineCount * leading
    }
    
    /** Fade in the labels and perform completion closure afterwards. */
    func fadeIn(duration: Double) {
        let animation = SKAction.fadeIn(withDuration: duration)
        
        for label in labels {
            label.run(animation)
        }
    }
    
    /** Set alpha for all the labels */
    func setAlphaTo(_ alpha: CGFloat) {
        for label in labels {
            label.alpha = alpha
        }
    }
}

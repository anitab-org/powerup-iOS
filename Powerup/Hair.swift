//
//  Hair.swift
//  Powerup



import UIKit

class Hair: UIViewController {
    
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var customhair: UIImageView!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var hairImage: UIImage!
    var clothesImage: UIImage!
    
    var hair = ["pink", "blue", "purple","red","curly","black_straight"]
    var haircount = 0
    var hairtotal = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        clothesview.image = clothesImage
        faceview.image = faceImage
        customhair.image = hairImage
        
        hairview.image = UIImage(named: "\(hair[0]).png")
        //customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }
    
    @IBAction func hairR(sender: AnyObject) {
        if(haircount  < hairtotal){
            haircount++
        }
        hairview.image = UIImage(named: "\(hair[haircount-1]).png")
        customhair.image = UIImage(named: "\(hair[haircount-1]).png")
    }
    
    @IBAction func hairL(sender: AnyObject) {
        if(haircount > 1){
            haircount--
        }
        hairview.image = UIImage(named: "\(hair[haircount-1]).png")
        customhair.image = UIImage(named: "\(hair[haircount-1]).png")
        
    }
    
}





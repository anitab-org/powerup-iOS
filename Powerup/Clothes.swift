//
//  Clothes.swift
//  Powerup

import UIKit

class Clothes: UIViewController {

    @IBOutlet weak var clothesview: UIImageView!
    @IBOutlet weak var customclothes: UIImageView!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var hairImage: UIImage!
    var clothesImage: UIImage!
    
    var clothes = ["cloth1", "cloth2", "cloth3", "cloth4", "cloth5", "cloth6", "cloth7", "cloth8", "cloth9"]
    var clothescount = 0
    var clothestotal = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        customclothes.image = clothesImage
        
        clothesview.image = UIImage(named: "\(clothes[0]).png")
        //customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }

    @IBAction func clothesR(sender: AnyObject) {
        if(clothescount  < clothestotal){
            clothescount++
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount-1]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount-1]).png")
    }
    
    @IBAction func clothesL(sender: AnyObject) {
        if(clothescount > 1){
            clothescount--
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount-1]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount-1]).png")
        
    }

    
}


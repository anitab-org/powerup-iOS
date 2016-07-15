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
    
    var clothes = ["magenta_blue", "blue_orange", "green_blue","peach_grey","lightpink_purple","cyan_purple"]
    var clothescount = 0
    var clothestotal = 6
    
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


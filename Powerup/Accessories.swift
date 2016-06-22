//
//  Accessories.swift
//  Powerup
//



import UIKit

class Accessories: UIViewController {

    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    @IBOutlet weak var handbagsview: UIImageView!
    @IBOutlet weak var glassesview: UIImageView!
    @IBOutlet weak var hatsview: UIImageView!
    @IBOutlet weak var necklaceview: UIImageView!
    
    
    var handbags = ["purse1", "purse2", "purse3", "purse4"]
    var glasses = ["glasses1", "glasses2", "glasses3"]
    var hats = ["hat1", "hat2", "hat3", "hat4", "hat5"]
    var necklace = ["necklace1", "necklace2", "necklace3", "necklace4"]
    
    var handbagscount = 0, handbagstotal = 4
    var glassescount = 0, glassestotal = 3
    var hatscount = 0, hatstotal = 5
    var necklacecount = 0, necklacetotal = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        handbagsview.image = UIImage(named: "\(handbags[0]).png")
        glassesview.image = UIImage(named: "\(glasses[0]).png")
        hatsview.image = UIImage(named: "\(hats[0]).png")
        necklaceview.image = UIImage(named: "\(necklace[0]).png")
        
    }

    @IBAction func handbagsR(sender: AnyObject) {
        if(handbagscount + 1 < handbagstotal){
            handbagscount++
        }
        handbagsview.image = UIImage(named: "\(handbags[handbagscount]).png")
        //customhandbags.image = UIImage(named: "\(handbags[handbagscount]).png")
    }
    
    @IBAction func handbagsL(sender: AnyObject) {
        if(handbagscount > 0){
            handbagscount--
        }
        handbagsview.image = UIImage(named: "\(handbags[handbagscount]).png")
        //customhandbags.image = UIImage(named: "\(handbags[handbagscount]).png")
    }
    
    @IBAction func glassesR(sender: AnyObject) {
        
        if(glassescount + 1 < glassestotal){
            glassescount++
        }
        glassesview.image = UIImage(named: "\(glasses[glassescount]).png")
       // customglasses.image = UIImage(named: "\(glasses[glassescount]).png")
        
    }
    @IBAction func glassesL(sender: AnyObject) {
        if(glassescount > 0){
            glassescount--
        }
        glassesview.image = UIImage(named: "\(glasses[glassescount]).png")
       // customglasses.image = UIImage(named: "\(glasses[glassescount]).png")
        
    }
    @IBAction func hatsR(sender: AnyObject) {
        if(hatscount + 1 < hatstotal){
            hatscount++
        }
        hatsview.image = UIImage(named: "\(hats[hatscount]).png")
       // customhats.image = UIImage(named: "\(hats[hatscount]).png")
        
        
        
    }
    
    @IBAction func hatsL(sender: AnyObject) {
        if(hatscount  > 0){
            hatscount--
        }
        hatsview.image = UIImage(named: "\(hats[hatscount]).png")
       // customhats.image = UIImage(named: "\(hats[hatscount]).png")
    }
    
    @IBAction func necklaceR(sender: AnyObject) {
        if(necklacecount + 1 < necklacetotal){
            necklacecount++
        }
        necklaceview.image = UIImage(named: "\(necklace[necklacecount]).png")
      //  customnecklace.image = UIImage(named: "\(necklace[necklacecount]).png")
    }
    @IBAction func necklaceL(sender: AnyObject) {
        if(necklacecount  > 0){
            necklacecount--
        }
        necklaceview.image = UIImage(named: "\(necklace[necklacecount]).png")
       // customnecklace.image = UIImage(named: "\(necklace[necklacecount]).png")
    }

    
    
    
    

}
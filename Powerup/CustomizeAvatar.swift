
//  CustomizeAvatar.swift

import UIKit

class CustomizeAvatar: UIViewController {
    
    //strong var eyeImage : UIImage!
    
    
    @IBOutlet weak var customclothes: UIImageView!
    @IBOutlet weak var customhair: UIImageView!
    @IBOutlet weak var customface: UIImageView!
    @IBOutlet weak var customeyes: UIImageView!
    
    @IBOutlet weak var eyesview: UIImageView!
    var eyes = ["blue_eyes", "brown_eyes", "green_eyes","lightGreen_eyes","lightPink_eyes","grey_eyes","pink_eyes"]
    var eyescount = 0
    var eyestotal = 7
    @IBOutlet weak var faceview: UIImageView!
    var face = ["brick_face", "yellow_face",  "orange_face","peach_face"]
    var facecount = 0
    var facetotal = 4
    @IBOutlet weak var hairview: UIImageView!
    var hair = ["pink", "blue", "purple","red","curly","black_straight"]
    var haircount = 0
    var hairtotal = 6
    @IBOutlet weak var clothesview: UIImageView!
    var clothes = ["magenta_blue", "blue_orange", "green_blue","peach_grey","lightpink_purple","cyan_purple"]
    var clothescount = 0
    var clothestotal = 6
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        faceview.image = UIImage(named: "\(face[facecount]).png")
        
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
        customface.image = UIImage(named: "\(face[facecount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          }
    
   
    @IBAction func clothesR(sender: AnyObject) {
        if(clothescount + 1 < clothestotal){
            clothescount++
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }
    
    @IBAction func clothesL(sender: AnyObject) {
        if(clothescount > 0){
            clothescount--
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }
    
    @IBAction func hairR(sender: AnyObject) {
        
        if(haircount + 1 < hairtotal){
            haircount++
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
        
        
    }
    @IBAction func hairL(sender: AnyObject) {
        if(haircount > 0){
            haircount--
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
      
    }
    @IBAction func faceR(sender: AnyObject) {
        if(facecount + 1 < facetotal){
            facecount++
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
        customface.image = UIImage(named: "\(face[facecount]).png")
    }
    
    @IBAction func faceL(sender: AnyObject) {
        if(facecount  > 0){
            facecount--
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
        customface.image = UIImage(named: "\(face[facecount]).png")
    }
    
    @IBAction func eyesR(sender: AnyObject) {
        if(eyescount + 1 < eyestotal){
            eyescount++
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
    }
    @IBAction func eyesL(sender: AnyObject) {
        if(eyescount  > 0){
            eyescount--
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "firstMap"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen  {
                println("Working!!!!!!!!")
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
            
            
        }
        
    }

}

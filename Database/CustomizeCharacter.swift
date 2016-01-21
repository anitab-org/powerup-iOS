//
//  CustomizeCharacter.swift
//  
//
//  Created by Andrew  on 1/21/16.
//
//

import UIKit

class CustomizeCharacter: UIViewController {

    @IBOutlet weak var eyesview: UIImageView!
    var eyes = ["blueEyes", "Eyes", "eyesGreen"]
    var eyescount = 1
    @IBOutlet weak var faceview: UIImageView!
    var face = ["Face", "Face1",  "Face2"]
    var facecount = 1
    @IBOutlet weak var hairview: UIImageView!
    var hair = ["hat", "blueHair", "Hair"]
    var haircount = 1
    @IBOutlet weak var clothesview: UIImageView!
    var clothes = ["Clothes", "Clothes1", "Clothes2"]
    var clothescount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
          hairview.image = UIImage(named: "\(hair[haircount]).png")
          clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
          faceview.image = UIImage(named: "\(face[facecount]).png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clothesR(sender: AnyObject) {
        if(clothescount + 1 < 3){
            clothescount++
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
    }
   
    @IBAction func clothesL(sender: AnyObject) {
        if(clothescount - 1 >= 0){
            clothescount--
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
    }

    @IBAction func hairR(sender: AnyObject) {
        if(haircount + 1 < 3){
            haircount++
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
    }
    @IBAction func hairL(sender: AnyObject) {
        if(haircount - 1 >= 0){
            haircount--
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
    }
    @IBAction func faceR(sender: AnyObject) {
        if(facecount + 1 < 3){
            facecount++
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
    }

    @IBAction func faceL(sender: AnyObject) {
        if(facecount - 1 >= 0){
            facecount--
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
    }
    
    @IBAction func eyesR(sender: AnyObject) {
        if(eyescount + 1 < 3){
            eyescount++
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
    }
    @IBAction func eyesL(sender: AnyObject) {
        if(eyescount - 1 >= 0){
            eyescount--
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
    }
}

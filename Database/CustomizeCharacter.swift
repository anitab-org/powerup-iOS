//
//  CustomizeCharacter.swift
//  
//
//  Created by Andrew  on 1/21/16.
//
//

import UIKit

class CustomizeCharacter: UIViewController {

    @IBOutlet weak var customclothes: UIImageView!
    @IBOutlet weak var customhead: UIImageView!
    var customhead0 = ["hat", "hat&Face1", "hat&Face2"]
    var customhead1 = ["blueHair&Face", "blueHair&Face1", "blueHair&Face2"]
    var customhead2 = ["Hair&Face", "Hair&Face1", "Hair&Face2"]
    @IBOutlet weak var customeyes: UIImageView!
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
        if(haircount == 0){
            customhead.image = UIImage(named: "\(customhead0[facecount]).png")
        }else if(haircount == 1){
            customhead.image = UIImage(named: "\(customhead1[facecount]).png")
        }else{
            customhead.image = UIImage(named: "\(customhead2[facecount]).png")
        }
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")

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
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }
   
    @IBAction func clothesL(sender: AnyObject) {
        if(clothescount - 1 >= 0){
            clothescount--
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
         customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }

    @IBAction func hairR(sender: AnyObject) {
        if(haircount + 1 < 3){
            haircount++
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        if(haircount == 0){
            customhead.image = UIImage(named: "\(customhead0[facecount]).png")
        }else if(haircount == 1){
            customhead.image = UIImage(named: "\(customhead1[facecount]).png")
        }else{
            customhead.image = UIImage(named: "\(customhead2[facecount]).png")
        }

    }
    @IBAction func hairL(sender: AnyObject) {
        if(haircount - 1 >= 0){
            haircount--
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        if(haircount == 0){
            customhead.image = UIImage(named: "\(customhead0[facecount]).png")
        }else if(haircount == 1){
            customhead.image = UIImage(named: "\(customhead1[facecount]).png")
        }else{
            customhead.image = UIImage(named: "\(customhead2[facecount]).png")
        }

    }
    @IBAction func faceR(sender: AnyObject) {
        if(facecount + 1 < 3){
            facecount++
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
        if(haircount == 0){
            customhead.image = UIImage(named: "\(customhead0[facecount]).png")
        }else if(haircount == 1){
            customhead.image = UIImage(named: "\(customhead1[facecount]).png")
        }else{
            customhead.image = UIImage(named: "\(customhead2[facecount]).png")
        }

    }

    @IBAction func faceL(sender: AnyObject) {
        if(facecount - 1 >= 0){
            facecount--
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
        if(haircount == 0){
            customhead.image = UIImage(named: "\(customhead0[facecount]).png")
        }else if(haircount == 1){
            customhead.image = UIImage(named: "\(customhead1[facecount]).png")
        }else{
            customhead.image = UIImage(named: "\(customhead2[facecount]).png")
        }
    }
    
    @IBAction func eyesR(sender: AnyObject) {
        if(eyescount + 1 < 3){
            eyescount++
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
         customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
    }
    @IBAction func eyesL(sender: AnyObject) {
        if(eyescount - 1 >= 0){
            eyescount--
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
         customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
    }
}

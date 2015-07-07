//
//  Choices-FirstScreen.swift
//  Database
//
//  Created by Sanya Jain on 04/07/15.
//  Copyright (c) 2015 Sanya Jain. All rights reserved.
//

import UIKit

class Choices_FirstScreen: UIViewController {
    
    @IBOutlet weak var Question: UITextView!
    //@IBOutlet weak var t1: UITextField!
    
    @IBOutlet weak var Answer: UITextView!
    //@IBOutlet weak var label: UILabel!
    
    //@IBOutlet weak var find: UIButton!
    
    //@IBOutlet weak var test: UIButton!

    
    var databasePath = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "Choices.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        
        if mainDB.open(){
            let question = "SELECT Text FROM ChoicesTable WHERE QID=1 AND RefID='$'"
            let Aoption = "SELECT Text FROM ChoicesTable WHERE QID=1 AND RefID=1"
            
            
            let qresults:FMResultSet? = mainDB.executeQuery(question,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(Aoption,
                withArgumentsInArray: nil)
            //let bresults:FMResultSet? = mainDB.executeQuery(Boption,withArgumentsInArray: nil)
            
            
            if qresults?.next() == true {
                Question.text = qresults?.stringForColumn("Text")
                
                
            }
            
            if aresults?.next() == true {
                Answer.text = qresults?.stringForColumn("Text")
                
            
            }
            
                
    
            
            }
        mainDB.close()
    
}

}












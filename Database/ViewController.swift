

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var t1: UITextField!

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var find: UIButton!
    
    @IBOutlet weak var test: UIButton!

    
    var databasePath = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            /*- (void) copyDatabaseIfNeeded {
                
                //Using NSFileManager we can perform many file system operations.
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                
                NSString *dbPath = [self getDBPath];
                BOOL success = [fileManager fileExistsAtPath:dbPath];
                
                if(!success) {
                    
                    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite"];
                    success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
                    
                    if (!success)
                    NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
                }
                }
                
                - (NSString *) getDBPath
                    {
                        //Search for standard documents using NSSearchPathForDirectoriesInDomains
                        //First Param = Searching the documents directory
                        //Second Param = Searching the Users directory and not the System
                        //Expand any tildes and identify home directories.
                        
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
                        NSString *documentsDir = [paths objectAtIndex:0];
                        //NSLog(@"dbpath : %@",documentsDir);
                        return [documentsDir stringByAppendingPathComponent:@"database.sqlite"];
        }
        */
        

        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        var error: NSError?
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        
        
        if filemgr.fileExistsAtPath(databasePath as String){
            println("FOUND!!!!")
            filemgr.removeItemAtPath(databasePath as String, error: &error)
            
        }
        
        if let bundle_path = NSBundle.mainBundle().pathForResource("mainDatabase", ofType: "sqlite"){
            println("Test!!!!!!!!")
            
            if filemgr.copyItemAtPath(bundle_path, toPath: databasePath as String, error: &error){
                println("Success!!!!!!!!")
            }
            else{
                println("Failure")
                println(error?.localizedDescription)
            }
        }

        
        
        
        let mainDB = FMDatabase(path: databasePath as String)
            if mainDB == nil{
                println("Error: \(mainDB.lastErrorMessage())")
            }
        
            
           if mainDB.open(){
                let question = "SELECT QDescription FROM Question Where QID=1"
                let Aoption = "SELECT ADescription FROM Answer WHERE QID=1 AND AID=1"
                let Boption = "SELECT ADescription FROM Answer WHERE QID=1 AND AID=2"
            
            let qresults:FMResultSet? = mainDB.executeQuery(question,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(Aoption,
                withArgumentsInArray: nil)
            let bresults:FMResultSet? = mainDB.executeQuery(Boption,
                withArgumentsInArray: nil)
            
            
            if qresults?.next() == true {
                t1.text = qresults?.stringForColumn("QDescription")

                
            }
            
            if aresults?.next() == true {
            find.setTitle(aresults?.stringForColumn("ADescription"), forState: .Normal)
            }
            if bresults?.next() == true {
                test.setTitle(bresults?.stringForColumn("ADescription"), forState: .Normal)
                

            }
            
        
        }
        mainDB.close()
    }
    
    
    
    
    

    @IBAction func find(sender: UIButton) {
        
    }


    @IBAction func Boption(sender: UIButton) {
           }
    

}
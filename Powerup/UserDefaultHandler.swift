class UserDefaultsHandler {
    
    static func tutorialShown(key: String) -> Bool {
        if let object = UserDefaults.standard.object(forKey: key) {
            UserDefaults.standard.set(false, forKey: key)
            return object as! Bool
        } else {
            UserDefaults.standard.set(false, forKey: key)
            return true
        }
    }
    
}


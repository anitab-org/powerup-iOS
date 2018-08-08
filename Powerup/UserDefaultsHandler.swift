extension UserDefaults {
    
    enum KeyNames: String {
        case MineSweeperTutorialViewed, VocabTutorialViewed, SinkToSwimTutorialViewed
    }
    
    static func tutorialViewed(key: KeyNames) -> Bool {
        if let object = UserDefaults.standard.object(forKey: key.rawValue) {
            UserDefaults.standard.set(true, forKey: key.rawValue)
            return object as! Bool
        } else {
            UserDefaults.standard.set(true, forKey: key.rawValue)
            return false
        }
    }
    
    static func setTutorialViewed(key: KeyNames, value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
}

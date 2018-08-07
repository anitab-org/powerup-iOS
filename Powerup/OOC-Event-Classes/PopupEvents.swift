import Foundation

/**
 Struct describing popups. Protects necessary strings as swift datatypes, and parses `Popups.json` to retrieve a properly formatted `PopupEventModel`.

 `Popups.json` contains references to popups for `PopupEventPlayer`.

 The `scenarioPopups` are necessary. The first level key should match the scenario ID, and the second level key should match the `popupID` found in the `Answers` database.

 The `otherPopups` are for convenience. These must be passed directly to an instance of `PopupEventPlayer`.

 - Author: Cadence Holmes 2018
*/
struct PopupEvents {

    // bundle may need to be able to be changed in order to automate testing
    var bundle = Bundle.main

    /**
     For matching with JSON keys.

     - Important: This enum needs to be kept in sync with the structure and expected values for StorySequences.json. The values in PowerUp Story Designer web app should have matching values here.
    */
    enum PopupType: String {
        case scenario = "scenarioPopups"
        case other = "otherPopups"
    }

    /**
     For matching with JSON keys.

     - Important: This enum needs to be kept in sync with the structure and expected values for StorySequences.json. The values in PowerUp Story Designer web app should have matching values here.
    */
    enum PopupCollection: String {
        // scenarioPopups
        case home = "5"

        // otherPopups
        case achievements = "achievements"
    }

    /**
     Parse `Popup.json`, search for the target popup, and return a formatted `PopupEvent`.

     - Parameter type: The type of the target popup to be retrieved. Should either use the enum `PopupType` or a matching string.
     - Parameter collection: The collection of the target popup to be retrieved. Should use a string, either literal or the `rawValue` of a `PopupCollection` enum case.
     - Parameter popupID: The unique id number for the desired popup.

     - Returns: A formatted `PopupEvent`.

     - Throws: `print(error.localizedDescription)` if unable to retrieve data.
     */
    func getPopup(type: PopupType, collection: String, popupID: Int) -> PopupEvent? {

        var popup = PopupEvent(topText: nil, botText: nil, imgName: nil, slideSound: nil, badgeSound: nil)

        // change this to the main json containing all sequences
        let fileName = "Popups"
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            print("Unable to retrieve popups JSON.")
            return nil
        }

        do {
            print("retrieve")
            // retrieve json and map to datatype Dictionary<String, AnyObject>
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            print(json)
            if let json = json as? Dictionary<String, AnyObject> {

                // retrieve the group of popups based on type
                guard let typeColl = json[type.rawValue] as? Dictionary<String, AnyObject?> else {
                    print("Unable to retrieve popups of type: \(type.rawValue).")
                    return nil
                }

                // retrieve the group of popups based on collection
                let id = String(popupID)
                guard let coll = typeColl[collection] as? Dictionary<String, AnyObject?> else {
                    print("Unable to retrieve popups for type-collection: \(type.rawValue) - \(collection).")
                    return nil
                }

                // retrieve popup based on popupID
                guard let pop = coll[id] as? Dictionary<String, AnyObject?> else {
                    print("Unable to retrieve popup for type-collection-id: \(type.rawValue) - \(collection) - \(id).")
                    return nil
                }

                popup.topText = pop["topText"] as? String
                popup.botText = pop["botText"] as? String
                popup.imgName = pop["imgName"] as? String
                popup.slideSound = pop["slideSound"] as? String
                popup.badgeSound = pop["badgeSound"] as? String
            }

        } catch let error {
            print(error.localizedDescription)
        }

        return popup

    }

}


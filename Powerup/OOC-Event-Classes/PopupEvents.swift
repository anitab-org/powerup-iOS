/**
 For matching with JSON keys.
*/
enum PopupType: String {
    case scenario = "scenarioPopups"
    case other = "otherPopups"
}

/**
 For matching with JSON keys.
 */
enum PopupCollection: String {
    // scenarioPopups
    case home = "5"

    // otherPopups
    case achievements = "achievements"
}

func getPopup(type: PopupType, collection: String, popupID: Int) -> PopupEvent? {

    var popup = PopupEvent(topText: nil, botText: nil, imgName: nil, doSound: nil)

    // change this to the main json containing all sequences
    guard let path = Bundle.main.path(forResource: "Popups", ofType: "json") else {
        print("Unable to retrieve popups JSON.")
        return nil
    }

    do {
        // retrieve json and map to datatype Dictionary<String, AnyObject>
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

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
            popup.doSound = pop["doSound"] as? Bool
        }

    } catch let error {
        print(error.localizedDescription)
    }

    return popup

}

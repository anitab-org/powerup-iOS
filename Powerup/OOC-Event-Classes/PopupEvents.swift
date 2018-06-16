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

/**
 Struct containing dictionaries of popup events. Defined in PopupEvents.swift.
 */
struct PopupEvents {
    let scenarioPopups: Dictionary<Int, Dictionary<Int, PopupEvent>>

    init() {
        scenarioPopups = [
            5: homePopups
        ]
    }
}

// MARK: Home Popups
/**
 Dictionary containing descriptions of PopupEvent instances for the Home scenario. Keys reference Answer.popupID. Defined in PopupEvents.swift.
 */
let homePopups = [
    1: PopupEvent(topText: "test model 1",
                  botText: "has sound",
                  imgName: "minesweeper_abstinence_heart",
                  doSound: true),

    2: PopupEvent(topText: "test model 2 with longer text it should shrink to fit",
                  botText: "no sound",
                  imgName: "karma_star",
                  doSound: false),

    3: PopupEvent(topText: "test model 3, big image should aspect fit in view",
                  botText: "has sound",
                  imgName: "home_background",
                  doSound: true),

    4: PopupEvent(topText: "",
                  botText: "",
                  imgName: "display_clothes_01",
                  doSound: true),

    5: PopupEvent(topText: "test model 5, nil image, has sound",
                  botText: "but since no image should only play first sound",
                  imgName: nil,
                  doSound: true),

    6: PopupEvent(topText: "test model 6, image named doesnt exist",
                  botText: "has sound, but only plays first sound",
                  imgName: "wjqvwniiovnuiohvwjqioniioqdlknuv",
                  doSound: true)
]

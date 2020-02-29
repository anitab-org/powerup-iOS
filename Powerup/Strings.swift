import Foundation
// Strings

enum CustomText {
    static let endSceneTitleLabel = "Game Over"
    static let scoreLabelPrefix = "Score: "
    static let boxEnlargingKey = "enlarge"
    static let boxShrinkingKey = "shrink"
    
    static let ok = "OK"
    static let cancel = "Cancel"
    static let previewLabel = "Preview"
    static let cancelButton = "Maybe not"
    static let purchaseButton = "Purchase"
    
}

enum CustomMessage {
    static let warningTitle = "Warning"
    static let createAvatar = "Create your avatar to start the game!"
    static let confirmationTitle = "Are you sure?"
    static let oopsTitle = "Oops!"
    static let newAvatarTitle = "Create New Avatar"
    static let yayTitle = "Yay!"
    static let successFullPurchase = "The purchase is successful!"
    static let hoorayTitle = "Hooray!"
}

enum CustomImage {
    static let box = "shop_available_box"
    static let greyOutBox = "shop_unavailable_box"
}

enum CustomWarning {
    static let mapMigrationAlert = "If you migrate to map, current scene karma points will be lost"
    static let notEnoughPoints = "You don't have enough points to buy that!"
    static let startNewGame = "If you start a new game, previous data and all Karma points will be lost!"
}

enum CustomError {
    static let savingScenarioCompletionMessage = "Error saving scenario completion."
    static let savingKarmaPointsMessage = "Error saving Karma points."
    static let fetchingScenarioMessage = "Error fetching scenario data from database."
    static let loadingKarmaPoints = "Error loading Karma points."
    static let loadingAvatarMessage = "Error loading the avatar. Please try again!"
    static let loadingChoicesMessage = "Error loading the choices. Please try again!"
    static let loadingScenarioMessage = "Error loading scenarios, please and try again, if this error still occurs, try restarting the app."
    static let restartAppMessage = "Error initializing user data, please restart the app."
    
    static let savingPurchaseMessage = "Error saving your purchase, please retry this action. If that doesn't help, try restarting or reinstalling the app."
    static let fetchingAvatarMessage = "Error fetching avatar and score data, please retry this action. If that doesn't help, try restarting or reinstalling the app."
    static let savingAvatarMessage = "Error saving the avatar, please retry this action. If that doesn't help, try restarting or reinstalling the app."
    
    static let failedtoSaveAvatarMessage = "Failed to save avatar, please retry this action. If that doesn't help, try restaring or reinstalling the app."
    static let purchasingMessage = "Error purchasing item, please retry this action. If that doesn't help, try restarting or reinstalling the app."
    
}

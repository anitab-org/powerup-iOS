/** This struct is a data model for player's score in power/health bars. */

struct Score {
    var karmaPoints: Int
    var healing: Int
    var strength: Int
    var telepathy: Int
    var invisibility: Int
    
    init(karmaPoints: Int = 0, healing: Int = 0, strength: Int = 0, telepathy: Int = 0, invisibility: Int = 0) {
        self.karmaPoints = karmaPoints
        self.healing = healing
        self.strength = strength
        self.telepathy = telepathy
        self.invisibility = invisibility
    }
}

// MARK: Operators
func +(lhs: Score, rhs: Score) -> Score {
    return Score(karmaPoints: lhs.karmaPoints + rhs.karmaPoints, healing: lhs.healing + rhs.healing, strength: lhs.strength + rhs.strength, telepathy: lhs.telepathy + rhs.telepathy, invisibility: lhs.invisibility + rhs.invisibility)
}

func -(lhs: Score, rhs: Score) -> Score {
    return Score(karmaPoints: lhs.karmaPoints - rhs.karmaPoints, healing: lhs.healing - rhs.healing, strength: lhs.strength - rhs.strength, telepathy: lhs.telepathy - rhs.telepathy, invisibility: lhs.invisibility - rhs.invisibility)
}

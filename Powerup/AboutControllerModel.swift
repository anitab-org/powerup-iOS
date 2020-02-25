//model
import Foundation
struct Sections {
    var title: String
    var information: String
    var isExpandable: Bool

    init(title: String, information: String) {
        self.title = title
        self.information = information
        self.isExpandable = false
    }
}
public struct PoweupInfo {
    var detail: String

    public init(detail: String) {
        self.detail = detail
    }
}

public struct Section {
    var powerupQues: String
    var powerupDetail: PoweupInfo
    var collapsed: Bool

    public init(powerupQues: String, powerupDetail: PoweupInfo, collapsed: Bool = false) {
        self.powerupQues = powerupQues
        self.powerupDetail = powerupDetail
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section] = [
    Section(powerupQues: SectiontheGame, powerupDetail: PoweupInfo(detail: SectionWhatIsPowerupDetail), collapsed: true),
    Section(powerupQues: SectionWhyIsPowerupNeeded, powerupDetail: PoweupInfo(detail: SectionWhyIsPowerupNeededDetail), collapsed: true),
    Section(powerupQues: SectionPowerupHelpTeenagers, powerupDetail: PoweupInfo(detail: SectionPowerupHelpTeenagersDetail), collapsed: true)
]

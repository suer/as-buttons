import Foundation

public enum NotificationTiming: Int, Choice {
    case OnEnter = 1
    case OnExit = 2

    static func fromInt(rawValue: Int) -> NotificationTiming {
        switch(rawValue) {
        case 1:
            return .OnEnter
        case 2:
            return .OnExit
        default:
            return .OnEnter
        }
    }

    var value: Int {
        return self.rawValue
    }

    var displayValue: String {
        switch(self) {
        case .OnEnter:
            return "on Enter"
        case .OnExit:
            return "on Exit"
        }
    }
}
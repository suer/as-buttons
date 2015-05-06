import Foundation

class I18n {
    class func translate(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    class func translateWithFormat(key: String, args: CVarArgType...) -> String {
        return String(format: I18n.translate(key), arguments: args)
    }

    class var signin: String { return I18n.translate("Signin") }

    class var menu: String { return I18n.translate("Menu") }

    class var save: String { return I18n.translate("Save") }

    class var cancel: String { return I18n.translate("Cancel") }

    class var edit: String { return I18n.translate("Edit") }

    class var post: String { return I18n.translate("Post") }

    class var message: String { return I18n.translate("Message") }
}
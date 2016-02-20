import Eureka

final class ChoiceListPopoverSelectorRow<T: Choice>: SelectorRow<T, ChoicelistViewController<T>>, RowType {

    required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
            return ChoicelistViewController(options: self.options) {_ in }
            },
            completionCallback: { vc in
                vc.navigationController?.popViewControllerAnimated(true)
            }
        )
        displayValueFor = {
            guard let value = $0 else { return "" }
            return value.displayValue
        }
    }

}

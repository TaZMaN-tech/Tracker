import UIKit

protocol EditCategoryViewTextFieldHelperDelegate: AnyObject {
    func askLimitedCharacter()
    func noLimitedCharacters()
}

final class EditCategoryViewTextFieldHelper: NSObject {
    weak var delegate: EditCategoryViewTextFieldHelperDelegate?
}

extension EditCategoryViewTextFieldHelper: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count == 38 {
            delegate?.askLimitedCharacter()
        } else if updatedText.count < 38  {
            delegate?.noLimitedCharacters()
        }
        
        return updatedText.count <= 38
    }
}

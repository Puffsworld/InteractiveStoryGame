import SwiftUI

struct StoryChoiceButtonModel {
    let text: String
    let hint: String?
    let action: () -> Void
    var conerRadius: CGFloat? = nil
    var backgroundColor: Color = .blue
    
    init(text: String, hint: String?, action: @escaping () -> Void, conerRadius: CGFloat? = nil, backgroundColor: Color = .blue) {
        self.text = text
        self.hint = hint
        self.action = action
        self.conerRadius = conerRadius
        self.backgroundColor = backgroundColor
    }
}

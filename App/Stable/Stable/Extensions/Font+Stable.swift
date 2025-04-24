import SwiftUI

extension Font {
    static func stableTitle() -> Font {
        .system(size: 48, weight: .semibold, design: .rounded)
    }
    
    static func stableSubtitle() -> Font {
        .system(size: 20, weight: .regular, design: .rounded)
    }
}

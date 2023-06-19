import UIKit

extension UIFont {
    
    public enum Typeface: String {
        case normal = "HelveticaNeue-Normal"
        case medium = "HelveticaNeue-Medium"
        case bold = "HelveticaNeue-Bold"
    }
    
    convenience public init(weight: UIFont.Typeface, size: CGFloat) {
        self.init(name: weight.rawValue, size: size)!
    }
}

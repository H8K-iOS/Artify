import Foundation
import UIKit

extension String {
    static func createInfoLabel(title: String, value: String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor.gray
        ])
        str.append(NSAttributedString(string: "\n"))
        str.append(NSAttributedString(string: value, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]))
        
        return str
    }
}

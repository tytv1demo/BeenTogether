//
//  UIImage.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import FontAwesome_swift

extension UIImage {
    static func awesomeIcon(name: FontAwesome, style: FontAwesomeStyle = .solid, textColor: UIColor = UIColor(hexString: "DBDBDB")) -> UIImage {
        let defaultSize = CGSize(width: 24, height: 24)
        return UIImage.fontAwesomeIcon(name: name, style: style, textColor: textColor, size: defaultSize)
    }
}

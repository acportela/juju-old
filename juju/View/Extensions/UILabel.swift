//
//  UILabel.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UILabel {

    func setPartuallyUnderlined(title: String,
                                term: String,
                                color: UIColor,
                                regularFont: UIFont,
                                termFont: UIFont) {

        let attributedTitle = NSMutableAttributedString(string: title, attributes: [.font: regularFont])

        if title.range(of: term) != nil {

            let range = NSString(string: title).range(of: term)
            attributedTitle.addAttribute(.font, value: termFont, range: range)
        }

        let fullRange = NSRange(location: 0, length: title.count)

        attributedTitle.addAttribute(.foregroundColor, value: color, range: fullRange)
        self.attributedText = attributedTitle
    }
}

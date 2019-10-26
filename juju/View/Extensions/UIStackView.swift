//
//  UIStackView.swift
//  juju
//
//  Created by Antonio Rodrigues on 26/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UIStackView {

    func removeAllArrangedSubviews() {

        arrangedSubviews.forEach { removeArrangedSubview($0) }
    }
}

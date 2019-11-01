//
//  PopoverView.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol PopoverViewDelegate: AnyObject {

    func popoverViewWasTappedOutsideContentView(_ view: PopoverView)
}

class PopoverView: UIView, ViewCoding {

    // MARK: Views
    let popoverContentView = UIView()

    // MARK: Properties
    weak var popoverDelegate: PopoverViewDelegate?

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }

    func addSubViews() {

        self.addSubview(self.popoverContentView)
    }

    func setupConstraints() {

        self.popoverContentView.snp.makeConstraints { make in

            make.center.equalToSuperview()
        }
    }

    func configureViews() {

        self.popoverContentView.layer.cornerRadius = 4
        self.popoverContentView.backgroundColor = Styling.Colors.white
        self.popoverContentView.clipsToBounds = true

        self.backgroundColor = Styling.Colors.greyishBrown.withAlphaComponent(Constants.backgroundAlpha)

        self.addTapGesture()
    }
}

extension PopoverView: UIGestureRecognizerDelegate {

    private func addTapGesture() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.wasTapped))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    private func wasTapped() {

        self.popoverDelegate?.popoverViewWasTappedOutsideContentView(self)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {

        return (touch.view === self)
    }
}

extension PopoverView {

    private enum Constants {

        static let backgroundAlpha: CGFloat = 0.32
    }
}

//
//  TabView.swift
//  juju
//
//  Created by Antonio Rodrigues on 26/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TabViewDelegate: AnyObject {

    func tabView(_ view: TabView, didSelectTabAt index: Int)
}

final class TabView: UIView {

    private var lineWidthConstraint: NSLayoutConstraint?
    private var lineCenterXConstraint: NSLayoutConstraint?

    private let lineComponent: UIView = {

        let view = UIView()
        view.backgroundColor = Styling.Colors.rosyPink
        return view
    }()

    private let tabBarEntriesStackview: UIStackView = {

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.spacing = Styling.Spacing.sixteen

        return stackView
    }()

    weak var delegate: TabViewDelegate?

    // MARK: Init
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        self.setupViewConfiguration()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension TabView: ViewCoding {

    func addSubViews() {

        self.addSubview(self.tabBarEntriesStackview)
        self.addSubview(self.lineComponent)
    }

    func setupConstraints() {

        self.tabBarEntriesStackview.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }

        self.lineComponent.snp.makeConstraints { make in

            make.height.equalTo(Constants.lineHeight)
            make.bottom.equalTo(self.tabBarEntriesStackview.snp.bottom)
        }
    }

    func configureViews() {

        self.backgroundColor = .clear
    }
}

extension TabView: ViewConfiguration {

    enum States {

        case build([String], Int)
    }

    func configure(with state: TabView.States) {

        switch state {

        case .build(let entries, let defaultPositionSelected):

            self.tabBarEntriesStackview.removeAllArrangedSubviews()
            entries.forEach {

                self.tabBarEntriesStackview.addArrangedSubview(self.buildLabelComponent(with: $0))
            }

            self.layoutIfNeeded()
            self.moveLine(to: self.tabBarEntriesStackview.arrangedSubviews[defaultPositionSelected])
        }
    }
}

private extension TabView {

    func buildLabelComponent(with title: String) -> UILabel {

        let label = UILabel()
        label.text = title.capitalized
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.sixteen)
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.sizeToFit()

        return label
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {

        guard let view = sender?.view else {

            return
        }

        self.moveLine(to: view)

        if let index = self.tabBarEntriesStackview.arrangedSubviews.firstIndex(of: view) {

            self.delegate?.tabView(self, didSelectTabAt: index)
        }
    }

    func moveLine(to view: UIView) {

        let lineWidth = view.frame.width
        let lineCenter = view.center.x

        if self.lineWidthConstraint == nil || self.lineCenterXConstraint == nil {

            self.lineWidthConstraint = self.lineComponent.widthAnchor.constraint(equalToConstant: lineWidth)
            self.lineWidthConstraint?.isActive = true

            self.lineCenterXConstraint = self.lineComponent.centerXAnchor.constraint(equalTo: self.leadingAnchor,
                                                                                     constant: lineCenter)
            self.lineCenterXConstraint?.isActive = true

        } else {

            self.lineWidthConstraint?.constant = lineWidth
            self.lineCenterXConstraint?.constant = lineCenter
        }

        UIView.animate(withDuration: Constants.animationDuration) {

            self.layoutIfNeeded()
        }
    }
}

private extension TabView {

    enum Constants {

        static let none: CGFloat = 0
        static let lineHeight: CGFloat = 4
        static let animationDuration: Double = 0.2
    }
}

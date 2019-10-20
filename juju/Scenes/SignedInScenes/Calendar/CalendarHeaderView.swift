//
//  MonthLabelView.swift
//  juju
//
//  Created by Antonio Rodrigues on 16/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

protocol CalendarHeaderViewDelegate: AnyObject {
    
    func calendarHeaderViewDidTapPrevious(_ monthHeader: CalendarHeaderView)
    func calendarHeaderViewDidTapNext(_ monthHeader: CalendarHeaderView)
}
final class CalendarHeaderView: JTACMonthReusableView {
    
    // MARK: Views
    private let headerLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let weekLabelsStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let leftSign: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.leftChevron
        imageView.contentMode = .center
        return imageView
    }()
    
    private let rightSign: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.rightChevron
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: Properties
    
    weak var delegate: CalendarHeaderViewDelegate?
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension CalendarHeaderView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.headerLabel)
        self.addSubview(self.leftSign)
        self.addSubview(self.rightSign)
        self.addSubview(self.weekLabelsStack)
    }
    
    func setupConstraints() {
        
        self.headerLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview().offset(Styling.Spacing.twentyfour)
            make.left.right.equalToSuperview()
        }
        
        self.leftSign.snp.makeConstraints { make in
            
            make.centerY.equalTo(self.headerLabel.snp.centerY)
            make.left.equalToSuperview()
            make.width.height.equalTo(Constants.chevronSides)
        }
        
        self.rightSign.snp.makeConstraints { make in
            
            make.centerY.equalTo(self.headerLabel.snp.centerY)
            make.right.equalToSuperview()
            make.width.height.equalTo(Constants.chevronSides)
        }
        
        self.weekLabelsStack.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.headerLabel.snp.bottom).offset(Styling.Spacing.twentyfour)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
        self.addWeekLabels()
        
        let previousTap = UITapGestureRecognizer(target: self, action: #selector(self.previousItemTap))
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(self.nextItemTap))
        
        self.leftSign.addGestureRecognizer(previousTap)
        self.rightSign.addGestureRecognizer(nextTap)
    }
    
    private func addWeekLabels() {
        
        var calendar = Calendar(identifier: .iso8601)
        // TODO: Implement localization first and change this to .autoupdatingCurrent
        calendar.locale = Locale(identifier: "pt-br")
        let weekDays = calendar.shortWeekdaySymbols
        
        for index in 0...6 {
            
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Styling.Colors.charcoalGrey
            label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.twelve)
            label.text = weekDays[index].capitalized
            self.weekLabelsStack.addArrangedSubview(label)
        }
    }
}

extension CalendarHeaderView {
    
    @objc
    private func previousItemTap() {
        
        self.delegate?.calendarHeaderViewDidTapPrevious(self)
    }
    
    @objc
    private func nextItemTap() {
        
        self.delegate?.calendarHeaderViewDidTapNext(self)
    }
}
extension CalendarHeaderView: ViewConfiguration {
    
    enum States {
        
        case build(title: String)
    }
    
    func configure(with state: CalendarHeaderView.States) {
    
        switch state {
            
        case .build(let title):
            
            self.headerLabel.text = title
        }
    }
}

extension CalendarHeaderView {
    
    struct Constants {
        
        static let reuseIdentifier = "HeaderView"
        static let chevronSides: CGFloat = 44
    }
}

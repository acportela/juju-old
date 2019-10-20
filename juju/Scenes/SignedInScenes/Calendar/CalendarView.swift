//
//  CalendarView.swift
//  juju
//
//  Created by Antonio Rodrigues on 15/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

// TODO: Remove force unwraps

final class CalendarView: UIView {
    
    // MARK: Views
    private lazy var jtCalendar: JTACMonthView = {
        
        let calendar = JTACMonthView()
        calendar.register(DateCircleView.self,
                          forCellWithReuseIdentifier: DateCircleView.Constants.dateCellItendifier)
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        calendar.scrollDirection = .horizontal
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.allowsMultipleSelection = false
        calendar.showsHorizontalScrollIndicator = false
        calendar.layer.cornerRadius = 4
        calendar.layer.masksToBounds = true
        calendar.backgroundColor = Styling.Colors.white
        calendar.layer.borderWidth = 1
        calendar.layer.borderColor = Styling.Colors.duskyRose.cgColor
        calendar.register(CalendarHeaderView.self,
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: CalendarHeaderView.Constants.reuseIdentifier)
        return calendar
    }()
    
    private let buttonAddUrine = JujuButtonWithAccessory()
    
    var addUrineAction: (() -> Void)? {
        didSet {
            buttonAddUrine.wasTappedCallback = addUrineAction
        }
    }
    
    private var calendar = Calendar(identifier: .iso8601)
    private let headerFormatter = DateFormatter()

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension CalendarView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.jtCalendar)
        self.addSubview(self.buttonAddUrine)
    }
    
    func setupConstraints() {
        
        self.jtCalendar.snp.makeConstraints { make in
            
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.fourtyeight)
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().offset(-Styling.Spacing.sixteen)
            make.height.greaterThanOrEqualTo(Constants.calendarHeight)
        }
        
        self.buttonAddUrine.snp.makeConstraints { make in
            
            make.top.equalTo(self.jtCalendar.snp.bottom).offset(Styling.Spacing.fourtyeight)
            make.left.equalToSuperview().offset(Styling.Spacing.thirtytwo)
            make.right.equalToSuperview().offset(-Styling.Spacing.thirtytwo)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.veryLightPink
        headerFormatter.dateFormat = Constants.monthLabelFormat
        
        // TODO: Implement localization first and change this to .autoupdatingCurrent
        calendar.locale = Locale(identifier: "pt-br")
    }
    
    func reload() {
        
        self.jtCalendar.reloadData()
    }
}

extension CalendarView: ViewConfiguration {
    
    enum States {
        
        case build
    }
    
    func configure(with state: CalendarView.States) {
    
        switch state {
            
        case .build:
            
            let buttonConfig = JujuButtonWithAccessoryConfiguration(title: "Adicionar perda de urina",
                                                                    subtitle: .empty,
                                                                    accessoryImage: Resources.Images.urineDropCircle)
            self.buttonAddUrine.configure(with: .initial(buttonConfig))
        }
    }
}

extension CalendarView {
    
    struct Constants {
        
        static let buttonHeight: CGFloat = 48
        static let calendarHeight: CGFloat = 390
        static let monthHeight: CGFloat = 102
        static let monthLabelFormat = "MMMM"
        static let calendarDateFormat = "yyyy MM dd"
    }
}

extension CalendarView: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView,
                  willDisplay cell: JTACDayCell,
                  forItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) {
        
        guard let cell = cell as? DateCircleView  else { return }
        cell.configure(with: .circleAndDrop)
        cell.configure(with: .setText(cellState.text))
    }
    
    
    func calendar(_ calendar: JTACMonthView,
                  cellForItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCircleView.Constants.dateCellItendifier,
                                                       for: indexPath) as! DateCircleView
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
}

extension CalendarView: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = Constants.calendarDateFormat
        
        // TODO: Change these boundaries
        let startDate = dayFormatter.date(from: "2018 01 01")!
        let endDate = Date()
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 5,
                                       generateInDates: .off,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .sunday)
    }
    
    func calendar(_ calendar: JTACMonthView,
                  headerViewForDateRange range: (start: Date, end: Date),
                  at indexPath: IndexPath) -> JTACMonthReusableView {
   
        guard let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: CalendarHeaderView.Constants.reuseIdentifier,
                                                                            for: indexPath) as? CalendarHeaderView else {
            
            return JTACMonthReusableView()
        }
        header.delegate = self
        
        let monthIndex = self.calendar.component(.month, from: range.start) - 1
        let month = self.calendar.monthSymbols[monthIndex].capitalized
        
        header.configure(with: .build(title: month))
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        
        return MonthSize(defaultSize: Constants.monthHeight)
    }
}

extension CalendarView: CalendarHeaderViewDelegate {
    
    func calendarHeaderViewDidTapPrevious(_ monthHeader: CalendarHeaderView) {
        
        self.jtCalendar.scrollToSegment(.previous)
    }
    
    func calendarHeaderViewDidTapNext(_ monthHeader: CalendarHeaderView) {
        
        self.jtCalendar.scrollToSegment(.next)
    }
}

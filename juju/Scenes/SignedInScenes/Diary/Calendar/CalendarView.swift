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

protocol CalendarViewDelegate: AnyObject {

    func calendarViewWantsToShowSummary(_ calendarView: CalendarView,
                                        forDiary diary: DiaryProgress)
}

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

    weak var delegate: CalendarViewDelegate?

    let dateUtils = DateUtils()
    let initialCalendarRange: DateRange

    var diary: [DiaryProgress] = [] {
        didSet {
            self.jtCalendar.reloadData()
        }
    }
    
    // MARK: Lifecycle
    init(initialRange: DateRange, frame: CGRect = .zero) {

        self.initialCalendarRange = initialRange
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
            
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.twentyfour)
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().offset(-Styling.Spacing.sixteen)
            make.height.greaterThanOrEqualTo(Constants.calendarHeight)
        }
        
        self.buttonAddUrine.snp.makeConstraints { make in
            
            make.top.equalTo(self.jtCalendar.snp.bottom).offset(Styling.Spacing.twentyfour)
            make.left.equalToSuperview().offset(Styling.Spacing.thirtytwo)
            make.right.equalToSuperview().offset(-Styling.Spacing.thirtytwo)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.veryLightPink
        self.jtCalendar.scrollToDate(Date())
        self.buttonAddUrine.isHidden = true
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

    private func getDiaryWithDate(_ date: Date) -> DiaryProgress? {

        return self.diary.first { diary in

            DateUtils.defaultCalendar.isDate(date, inSameDayAs: diary.date)
        }
    }
}

extension CalendarView {
    
    struct Constants {
        
        static let buttonHeight: CGFloat = 48
        static let calendarHeight: CGFloat = 390
        static let monthHeight: CGFloat = 102
    }
}

extension CalendarView: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView,
                  willDisplay cell: JTACDayCell,
                  forItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) {
        
        guard let cell = cell as? DateCircleView  else { return }

        cell.configure(with: .setText(cellState.text))

        if let diary = self.getDiaryWithDate(date) {

            let exerised = diary.exercisedToday
            let lostUrine = !diary.urineLosses.isEmpty

            if exerised && lostUrine {
                cell.configure(with: .circleAndDrop)
                return
            }

            if exerised {
                cell.configure(with: .circle)
                return
            }

            if lostUrine {
                cell.configure(with: .drop)
                return
            }

        } else {
            
            cell.configure(with: .empty)
        }
    }
    
    func calendar(_ calendar: JTACMonthView,
                  cellForItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) -> JTACDayCell {
        
        let identifier = DateCircleView.Constants.dateCellItendifier
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: identifier,
                                                             for: indexPath)
                                                             as? DateCircleView else {
            return JTACDayCell()
        }
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView,
                  didSelectDate date: Date,
                  cell: JTACDayCell?,
                  cellState: CellState,
                  indexPath: IndexPath) {

        if let diary = self.getDiaryWithDate(date) {

            self.delegate?.calendarViewWantsToShowSummary(self, forDiary: diary)
        }
    }
}

extension CalendarView: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        return ConfigurationParameters(startDate: self.initialCalendarRange.from,
                                       endDate: self.initialCalendarRange.to,
                                       numberOfRows: 5,
                                       generateInDates: .off,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .sunday)
    }
    
    func calendar(_ calendar: JTACMonthView,
                  headerViewForDateRange range: (start: Date, end: Date),
                  at indexPath: IndexPath) -> JTACMonthReusableView {
   
        let identifier = CalendarHeaderView.Constants.reuseIdentifier
        
        guard let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: identifier,
                                                                            for: indexPath)
                                                                            as? CalendarHeaderView else {
            return JTACMonthReusableView()
        }
        
        header.configure(with: .build(range.start))
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        
        return MonthSize(defaultSize: Constants.monthHeight)
    }
}

//
//  MonthCalendarViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class MonthCalendarViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "AccentColor")
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        return view
    }()
    
    private let yearStackView = YearControl()
    private let monthStackView = MonthSelectControl()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "AccentColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    private var didTapYearButton = PublishSubject<Bool>()
    private var didTapMonthButton = PublishSubject<Int>()
    private var disposeBag = DisposeBag()
    private let viewModel = MonthCalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        monthStackView.delegate = self
        yearStackView.delegate = self
        
        bindings()
    }
    
    func bindings() {
        let input = MonthCalendarViewModel.Input(
            didTapYearButton: didTapYearButton.asObservable(),
            changeMonth: didTapMonthButton.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.year
            .compactMap { "\($0)년" }
            .observe(on: MainScheduler.instance)
            .bind(to: yearStackView.yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(to: monthStackView.selectedMonth)
            .disposed(by: disposeBag)
    }
}

extension MonthCalendarViewController: MonthControlDelegate {
    func monthControl(control: MonthSelectControl, didTapMonth month: Int) {
        didTapMonthButton.onNext(month)
    }
}

extension MonthCalendarViewController: YearControlDelegate {
    func yearControl(control: YearControl, didTapNext button: UIButton) {
        self.didTapYearButton.onNext(true)
    }
    
    func yearControl(control: YearControl, didTapPrevious button: UIButton) {
        self.didTapYearButton.onNext(false)
    }
}

private extension MonthCalendarViewController {
    func configureUI() {
        view.backgroundColor = .white
        configureHierarchy()
        makeConstraints()
        
        titleLabel.text = "달 선택"
    }
    
    func configureHierarchy() {
        [titleLabel, dividerView, yearStackView, monthStackView, confirmButton]
            .forEach(view.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
        }
        
        yearStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        monthStackView.snp.makeConstraints {
            $0.top.equalTo(yearStackView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(monthStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}


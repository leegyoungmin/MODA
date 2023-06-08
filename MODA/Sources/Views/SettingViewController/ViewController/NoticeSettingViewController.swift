//
//  NoticeSettingViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

protocol NoticeSettingDelegate: AnyObject {
    func noticeSettingView(
        controller: NoticeSettingViewController,
        didTapSave time: (hour: Int, minute: Int)
    )
}

final class NoticeSettingViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시간 설정"
        label.textColor = UIColor(named: "AccentColor")
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel.withAlphaComponent(0.4)
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "알림은 오전에 대한 알림만 제공합니다.\n일기를 작성하지 않으면 다시 알림을 전송합니다."
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let timePicker = UITimePicker()
    
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0

    weak var delegate: NoticeSettingDelegate?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        timePicker.timeDelegate = self
        
        saveButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                delegate?.noticeSettingView(
                    controller: self,
                    didTapSave: (selectedHour, selectedMinute)
                )
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension NoticeSettingViewController: TimePickerDelegate {
    func timePicker(picker: UITimePicker, didSelectedTime time: (hour: Int, minute: Int)) {
        self.selectedHour = time.hour
        self.selectedMinute = time.minute
    }
}


private extension NoticeSettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, explainLabel, timePicker, saveButton].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        explainLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        timePicker.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5).priority(.high)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.equalTo(timePicker.snp.leading)
            $0.top.equalTo(timePicker.snp.bottom).offset(16)
            $0.trailing.equalTo(timePicker.snp.trailing)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}

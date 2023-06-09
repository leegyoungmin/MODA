//
//  SettingViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import MessageUI

final class SettingViewController: UIViewController {
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorInset = .zero
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let settingSections = SettingSection.defaultSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        configureUI()
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSections.count
    }
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return settingSections[section].title
    }
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return settingSections[section].options.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let settingCell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.identifier,
            for: indexPath
        ) as? SettingCell else {
            return UITableViewCell()
        }
        
        let item = settingSections[indexPath.section].options[indexPath.row]
        settingCell.setUpData(to: item)
        return settingCell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        let titleLabel = UILabel(frame: view.bounds)
        view.addSubview(titleLabel)
        view.layoutMargins.left = 16
        titleLabel.text = settingSections[section].title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        return view
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 30
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.section == .zero && indexPath.row == .zero {
            let noticeController = NoticeSettingViewController()
            noticeController.delegate = self
            let controller = BottomSheetViewController(controller: noticeController)
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == .zero {
                self.presentMail()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingViewController: NoticeSettingDelegate {
    func noticeSettingView(
        controller: NoticeSettingViewController,
        didTapSave time: (hour: Int, minute: Int)
    ) {
        guard let cell = settingTableView.cellForRow(
            at: IndexPath(row: 0, section: 0)
        ) as? SettingCell else {
            return
        }
        
        cell.updateContent(time.hour.dateDescription + ":" + time.minute.dateDescription)
        
        removeAllNotification(identifier: [UNNotification.diaryIdentifier])
        requestNotification(hour: time.hour, minute: time.minute)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        switch result {
        case .failed:
            presentMailSendFailAlert()
        default:
            controller.dismiss(animated: true)
        }
    }
}

private extension SettingViewController {
    func removeAllNotification(identifier: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(
            withIdentifiers: identifier
        )
    }
    
    func requestNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "MODA"
        content.body = "아침에 일기를 쓰고, 기분 좋은 하루를 보내보세요."
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 12
        dateComponent.minute = 5
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponent,
            repeats: true
        )
        let alertRequest = UNNotificationRequest(
            identifier: UNNotification.diaryIdentifier,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(alertRequest)
        print("request Success")
    }
}

private extension SettingViewController {
    func presentMail() {
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            
            controller.setToRecipients(["cow970814@kakao.com"])
            controller.setSubject("MODA 문의 및 의견")
            self.present(controller, animated: true)
        }
    }
    
    func presentMailSendFailAlert() {
        let controller = UIAlertController(
            title: "",
            message: "메일을 발송하는데 문제가 발생하였습니다. 잠시후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(controller, animated: true)
    }
}

private extension SettingViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [settingTableView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        settingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

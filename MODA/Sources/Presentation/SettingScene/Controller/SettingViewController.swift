//
//  SettingViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import MessageUI
import WebKit
import StoreKit

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
    
    private let settingSections = SettingSection.generateSettings()
    
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
        switch indexPath.section {
        case 0:
            if indexPath.row == .zero {
                logOut()
            }
        case 1:
            if indexPath.row == .zero {
                self.presentNoticeSettingView()
            }
        case 2:
            switch indexPath.row {
            case 0:
                self.presentMail()
            case 1:
                AppStoreReviewManager.requestReviewIfAppropriate()
            case 2:
                self.presentPolicyView()
            default: break
            }
        default: break
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
            at: IndexPath(row: 0, section: 1)
        ) as? SettingCell else {
            return
        }
        
        UserDefaults.standard.set(time.hour, forKey: "notificationHour")
        UserDefaults.standard.set(time.minute, forKey: "notificationMinute")
        
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
    enum AppStoreReviewManager {
        private static let minimumReviewWorthyActionCount = 5
        private static var actionCount: Int {
            get { UserDefaults.standard.integer(forKey: "actionCount") }
            set { UserDefaults.standard.set(newValue, forKey: "actionCount") }
        }
        
        static func requestReviewIfAppropriate() {
            guard self.actionCount >= minimumReviewWorthyActionCount else { return }
            
            self.actionCount += 1
            
            let bundleVersionKey = kCFBundleVersionKey as String
            let currentVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
            
            let lastVersion = UserDefaults.standard.string(forKey: "lastVersion")
            
            guard lastVersion == nil || lastVersion != currentVersion else { return }
            
            if #available(iOS 14.0, *) {
                guard let scene = UIApplication.shared
                    .connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
                    return
                }
                
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
}

private extension SettingViewController {
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        presentSignInViewController()
    }
    func removeAllNotification(identifier: [String]) {
        UNUserNotificationCenter.current()
            .removeDeliveredNotifications(withIdentifiers: identifier)
    }
    
    func requestNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "app_name"~
        content.body = "alert_message"~
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        dateComponent.minute = minute
        
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
    }
}

private extension SettingViewController {
    func presentNoticeSettingView() {
        let noticeController = NoticeSettingViewController()
        noticeController.delegate = self
        let controller = BottomSheetViewController(controller: noticeController)
        
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        
        self.present(controller, animated: true)
    }
    
    func presentSignInViewController() {
        let scenes = UIApplication.shared.connectedScenes
        
        if let delegate = scenes.first?.delegate as? SceneDelegate,
           let window = delegate.window {
            
            let viewModel = SignInViewModel(
                useCase: DefaultSignInUseCase(
                    repository: DefaultAuthRepository(
                        service: UserService()
                    )
                )
            )
            window.rootViewController = SignInViewController(viewModel: viewModel)
        }
    }
    
    func presentMail() {
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            
            controller.setToRecipients(["MODA_email"~])
            controller.setSubject("MODA_comment"~)
            self.present(controller, animated: true)
        }
    }
    
    func presentMailSendFailAlert() {
        let controller = UIAlertController(
            title: "",
            message: "send_mail_error"~,
            preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "confirm"~, style: .default))
        
        present(controller, animated: true)
    }
}

private extension SettingViewController {
    func presentPolicyView() {
        guard let url = URL(string: "policy_site"~) else { return }
        
        UIApplication.shared.open(url)
    }
}

private extension SettingViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "설정"
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

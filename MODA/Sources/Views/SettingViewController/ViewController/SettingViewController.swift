//
//  SettingViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

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
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingViewController: NoticeSettingDelegate {
    func noticeSettingView(
        controller: NoticeSettingViewController,
        didTapSave time: (hour: Int, minute: Int)
    ) {
        print(time)
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

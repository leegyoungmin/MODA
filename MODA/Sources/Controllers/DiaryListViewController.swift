//
//  ViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let mockDatas: [Diary] = Diary.mockDatas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        configureUI()
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell()
        
        let item = mockDatas[indexPath.row]
        
        tableCell.textLabel?.text = item.content
        return tableCell
    }
}

private extension DiaryListViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [tableView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//
//  DemoListViewController.swift
//  DemoMetal2
//
//  Created by billthaslu on 2024/1/22.
//

import UIKit

import UIKit

let kCellReuseIdentifier = "UITableViewCell"

class DemoListViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellReuseIdentifier)
        return tableView
    }()
    
    var dataArray = [AnyClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        
        self.title = "DemoList"
        
        self.dataArray = [
            Two_1ViewController.self
        ]
        
    }


}

// MARK: - UITableViewDataSource
extension DemoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
        let aClass: AnyClass = self.dataArray[indexPath.row]
        cell.textLabel?.text = NSStringFromClass(aClass)
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension DemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aClass: AnyClass = self.dataArray[indexPath.row]
        if let className = aClass as? UIViewController.Type {
            let vc = className.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


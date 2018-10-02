//
//  ViewController.swift
//  TaskApp
//
//  Created by Matthew Wells on 9/30/18.
//  Copyright © 2018 Matthew Wells. All rights reserved.
//

import UIKit
import BLTNBoard
import SVProgressHUD

class TaskViewController: UITableViewController {
    
    var items = ["Item 1", "Item 2", "Item 3"]
    var dueDate = ["Date 1", "Date 2", "Date 3"]
    
    let page = TextFieldBLTNPage(title: "Add Task")
    let setupPage = TextFieldBLTNPage(title: "Edit Task")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartUp()
        Set()
    }
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = page
        
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    lazy var bulletinManager2: BLTNItemManager = {
        let rootItem: BLTNItem = setupPage
        
        return BLTNItemManager(rootItem: rootItem)
    }()

    func StartUp(){
        navigationItem.title = "Task List"
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.sectionHeaderHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(TaskViewController.insert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(TaskViewController.clear))
    }
    
    func Set(){
        if let x = UserDefaults.standard.array(forKey: "ArrayTasks") {
            items.removeAll()
            items = x as! [String]
        }
        if let x = UserDefaults.standard.array(forKey: "ArrayDate") {
            dueDate.removeAll()
            dueDate = x as! [String]
        }
    }
    
    func Save() {
        UserDefaults.standard.set(items, forKey: "ArrayTasks")
        UserDefaults.standard.set(dueDate, forKey: "ArrayDate")
    }
    
    @objc func insert(){

        page.actionButtonTitle = "SAVE"
        page.textFieldString = ""
        page.textFieldString1 = ""
        page.actionHandler = { (item:BLTNActionItem) in
            if let str = self.page.textField.text {
            self.items.append(str)
            }
            if let str2 = self.page.textField1.text {
                self.dueDate.append(str2)
            }
            let insertIndexPath = NSIndexPath(row: self.items.count - 1, section: 0)
            self.tableView.insertRows(at: [insertIndexPath as IndexPath], with: .automatic)
            self.Save()
            self.bulletinManager.dismissBulletin()
        }
        page.alternativeButtonTitle = "Cancel"
        page.alternativeHandler = { (item:BLTNActionItem) in
            self.bulletinManager.dismissBulletin()
        }
        page.isDismissable = false
        bulletinManager.showBulletin(above: self)
    }
    
    @objc func clear(){
        items.removeAll()
        dueDate.removeAll()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        myCell.nameLabel.text = items[indexPath.row]
        myCell.timeLabel.text = dueDate[indexPath.row]
        myCell.myTableViewController = self
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupPage.actionButtonTitle = "SAVE"
        setupPage.textFieldString = items[indexPath.row]
        setupPage.textFieldString1 = dueDate[indexPath.row]
        setupPage.actionHandler = { (item:BLTNActionItem) in
            if let task = self.setupPage.textField.text {
                self.items.remove(at: indexPath.row)
                self.items.insert(task, at: indexPath.row)
            }
            if let date = self.setupPage.textField1.text {
                self.dueDate.remove(at: indexPath.row)
                self.dueDate.insert(date, at: indexPath.row)
            }
            tableView.reloadData()
            self.Save()
            self.bulletinManager2.dismissBulletin()
        }
        setupPage.alternativeButtonTitle = "Cancel"
        setupPage.alternativeHandler = { (item:BLTNActionItem) in
            self.bulletinManager2.dismissBulletin()
        }
        setupPage.isDismissable = false
        bulletinManager2.showBulletin(above: self)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjectItems = self.items[sourceIndexPath.row]
        let movedObjectDates = self.dueDate[sourceIndexPath.row]
        
        items.remove(at: sourceIndexPath.row)
        dueDate.remove(at: sourceIndexPath.row)
        
        items.insert(movedObjectItems, at: destinationIndexPath.row)
        dueDate.insert(movedObjectDates, at: destinationIndexPath.row)
        self.Save()
    }

    func deleteCell(cell: UITableViewCell) {
        
        if let deletionIndexPath = tableView.indexPath(for: cell){
            items.remove(at: deletionIndexPath.row)
            dueDate.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
        Save()
    }
}

class Header: UITableViewHeaderFooterView{
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tasks"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Due"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        addSubview(dateLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0][v1(140)]-75-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": dateLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateLabel]))
    }
}

class MyCell: UITableViewCell {
   
    var myTableViewController: TaskViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Sample Text"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return textLabel
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Finished", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    func setupViews(){
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(MyCell.handleAction), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(140)]-38-[v1(90)]-12-[v2(80)]-38-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": timeLabel, "v2": actionButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLabel]))
        
        
    }
    
    @objc func handleAction() {
        myTableViewController?.deleteCell(cell: self)
        
    }
    
}











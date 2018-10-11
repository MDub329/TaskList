//
//  ViewController.swift
//  TaskApp
//
//  Created by Matthew Wells on 9/30/18.
//  Copyright © 2018 Matthew Wells. All rights reserved.
//

import UIKit
import BLTNBoard

class TaskViewController: UITableViewController{
    
    var items = ["Item 1", "Item 2", "Item 3"]
    var dueDate = ["Date 1", "Date 2", "Date 3"]
    
    let bgColor = #colorLiteral(red: 0.2100980884, green: 0.2274777916, blue: 0.2527261832, alpha: 1)
    let accentBGColor = #colorLiteral(red: 0.6673049983, green: 0, blue: 0.03121174827, alpha: 0.6015625)
    let textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let addPage = TextFieldBLTNPage(title: "Add Task")
    let editPage = TextFieldBLTNPage(title: "Edit Task")
    let dueDatePage = DueDatePicker(title: "Pick Due Date")
    let editDueDatePage = DueDatePicker(title: "Edit Due Date")
    var globalFooterLabel = UILabel() //Gain access to footer Total
    
    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartUp()
        Set()
//        self.tableView.isEditing = true
//        self.tableView.allowsSelectionDuringEditing = true
        navigationController?.navigationBar.barTintColor = accentBGColor
        tableView.backgroundColor = bgColor
        setUpAddPage()
        setUpEditPage()
        setUpDatePicker()
        setUPEditDatePicker()
    }
 
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = addPage
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    lazy var bulletinManager2: BLTNItemManager = {
        let rootItem: BLTNItem = editPage
        return BLTNItemManager(rootItem: rootItem)
    }()

    func StartUp(){
        navigationItem.title = "Task List"
        let textAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barStyle = .black
        tableView.register(MyCell.self, forCellReuseIdentifier: cellId)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(Footer.self, forHeaderFooterViewReuseIdentifier: footerId)
        tableView.sectionHeaderHeight = 50
        tableView.sectionFooterHeight = 65
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TaskViewController.insert))
        navigationItem.rightBarButtonItem?.tintColor = textColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(TaskViewController.clear))
        navigationItem.leftBarButtonItem?.tintColor = textColor
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
        addPage.actionButtonTitle = "Next"
        addPage.textFieldString = ""
        addPage.textFieldString1 = ""
        addPage.actionHandler = { (item:BLTNActionItem) in
            if let str = self.addPage.textField.text {
                self.items.append(str)
            }
            self.bulletinManager.displayNextItem()
        }
        addPage.alternativeButtonTitle = "Cancel"
        addPage.alternativeHandler = { (item:BLTNActionItem) in
            self.bulletinManager.dismissBulletin()
        }
        addPage.isDismissable = false
        bulletinManager.showBulletin(above: self)
    }
    
    @objc func clear(){
        items.removeAll()
        dueDate.removeAll()
        Save()
        tableView.reloadData()
    }
    
    func setUpDatePicker() {
        dueDatePage.actionButtonTitle = "Save"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-YY"
        dueDatePage.actionHandler = { (item:BLTNActionItem) in
            let dateString = dateFormat.string(from: self.dueDatePage.datePicker.date)
            self.dueDate.append(dateString)
            let insertIndexPath = NSIndexPath(row: self.items.count - 1, section: 0)
            self.tableView.insertRows(at: [insertIndexPath as IndexPath], with: .automatic)
            self.Save()
            let total = String(self.items.count)
            self.globalFooterLabel.text = "Total Tasks Left: \(total)"
            self.bulletinManager.dismissBulletin()
        }
        dueDatePage.isDismissable = false
        dueDatePage.appearance.actionButtonColor = accentBGColor
        dueDatePage.appearance.titleTextColor = .white
        dueDatePage.appearance.actionButtonBorderColor = .white
        dueDatePage.appearance.actionButtonBorderWidth = 2
        dueDatePage.appearance.actionButtonCornerRadius = 5
    }
    
    func setUPEditDatePicker() {
        editDueDatePage.actionButtonTitle = "Save"
        editDueDatePage.isDismissable = false
        editDueDatePage.appearance.actionButtonColor = accentBGColor
        editDueDatePage.appearance.titleTextColor = .white
        editDueDatePage.appearance.actionButtonBorderWidth = 2
        editDueDatePage.appearance.actionButtonCornerRadius = 5
        editDueDatePage.appearance.actionButtonBorderColor = .white
    }
    
    func setUpAddPage() {
        bulletinManager.backgroundColor = bgColor
        addPage.appearance.actionButtonColor = accentBGColor
        addPage.appearance.actionButtonBorderColor = .white
        addPage.appearance.actionButtonBorderWidth = 2
        addPage.appearance.actionButtonCornerRadius = 5
        addPage.appearance.titleTextColor = .white
        addPage.textField.textColor = .white
        addPage.appearance.alternativeButtonTitleColor = .white
        //addPage.textField1.textColor = accentBGColor
        addPage.next = dueDatePage
    }
    
    func setUpEditPage() {
        bulletinManager2.backgroundColor = bgColor
        editPage.appearance.actionButtonColor = accentBGColor
        editPage.appearance.titleTextColor = .white
        editPage.textField.textColor = accentBGColor
        editPage.textField1.textColor = accentBGColor
        editPage.next = editDueDatePage
        editPage.actionButtonTitle = "NEXT"
        editPage.alternativeButtonTitle = "Cancel"
        editPage.isDismissable = false
        editPage.appearance.actionButtonBorderColor = .white
        editPage.appearance.actionButtonBorderWidth = 2
        editPage.appearance.actionButtonCornerRadius = 5
        editPage.appearance.alternativeButtonTitleColor = .white
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyCell
        myCell.nameLabel.text = items[indexPath.row]
        myCell.timeLabel.text = dueDate[indexPath.row]
        myCell.myTableViewController = self
        myCell.floatView.backgroundColor = accentBGColor
        myCell.timeLabel.textColor = textColor
        myCell.nameLabel.textColor = textColor
        myCell.nameLabel.numberOfLines = 2
        myCell.actionButton.setTitleColor(textColor, for: .normal)
        myCell.actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! Header
        myHeader.backgroundView = UIView(frame: myHeader.bounds)
        myHeader.backgroundView?.backgroundColor = bgColor
        myHeader.dateLabel.textColor = textColor
        myHeader.nameLabel.textColor = textColor
        
        return myHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) as! Footer
        let total = String(items.count)
        myFooter.backgroundView = UIView(frame: myFooter.bounds)
        myFooter.backgroundView?.backgroundColor = bgColor
        globalFooterLabel = myFooter.totalLabel
        myFooter.totalLabel.textColor = textColor
        myFooter.totalLabel.text = "Total Tasks Left: \(total)"
        return myFooter
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editPage.textFieldString = items[indexPath.row]
        editPage.textFieldString1 = dueDate[indexPath.row]
        editPage.actionHandler = { (item:BLTNActionItem) in
            if let task = self.editPage.textField.text {
                self.items.remove(at: indexPath.row)
                self.items.insert(task, at: indexPath.row)
            }
            self.bulletinManager2.displayNextItem()
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM-dd-YY"
            //Set date in datePicker
            
            
            self.editDueDatePage.actionHandler = { (item:BLTNActionItem) in
                let dateString = dateFormat.string(from: self.editDueDatePage.datePicker.date)
                self.dueDate.remove(at: indexPath.row)
                self.dueDate.insert(dateString, at: indexPath.row)
                self.Save()
                self.bulletinManager2.dismissBulletin()
                tableView.reloadData()
            }
            
        }
        editPage.alternativeHandler = { (item:BLTNActionItem) in
            self.bulletinManager2.dismissBulletin()
            tableView.deselectRow(at: indexPath, animated: false)
        }
        bulletinManager2.showBulletin(above: self)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
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
            //update Footer Count
            let total = String(items.count)
            globalFooterLabel.text = "Total Tasks Left: \(total)"
        }
        Save()
    }
    
    
    
}


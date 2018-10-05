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

class TaskViewController: UITableViewController{
    
    var items = ["Item 1", "Item 2", "Item 3"]
    var dueDate = ["Date 1", "Date 2", "Date 3"]
    
    let bgColor = #colorLiteral(red: 0.2100980884, green: 0.2274777916, blue: 0.2527261832, alpha: 1)
    let accentBGColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let page = TextFieldBLTNPage(title: "Add Task")
    let setupPage = TextFieldBLTNPage(title: "Edit Task")
    var globalFooterLabel = UILabel() //Gain access to footer Total
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartUp()
        Set()
        
        navigationController?.navigationBar.barTintColor = accentBGColor
        
        tableView.backgroundColor = bgColor
        
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
        let textAttributes = [NSAttributedStringKey.foregroundColor:textColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barStyle = .black
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.register(Footer.self, forHeaderFooterViewReuseIdentifier: "footerId")
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
            //update footer Count
            let total = String(self.items.count)
            self.globalFooterLabel.text = "Total Tasks Left: \(total)"
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
        Save()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        myCell.nameLabel.text = items[indexPath.row]
        myCell.timeLabel.text = dueDate[indexPath.row]
        myCell.myTableViewController = self
        myCell.floatView.backgroundColor = accentBGColor
        myCell.timeLabel.textColor = textColor
        myCell.nameLabel.textColor = textColor
        myCell.actionButton.setTitleColor(textColor, for: .normal)
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
        myHeader.backgroundView = UIView(frame: myHeader.bounds)
        myHeader.backgroundView?.backgroundColor = bgColor
        myHeader.dateLabel.textColor = textColor
        myHeader.nameLabel.textColor = textColor
        
        return myHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! Footer
        let total = String(items.count)
        myFooter.backgroundView = UIView(frame: myFooter.bounds)
        myFooter.backgroundView?.backgroundColor = bgColor
        globalFooterLabel = myFooter.totalLabel
        myFooter.totalLabel.textColor = textColor
        myFooter.totalLabel.text = "Total Tasks Left: \(total)"
        return myFooter
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
            tableView.deselectRow(at: indexPath, animated: false)
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
            //update Footer Count
            let total = String(items.count)
            globalFooterLabel.text = "Total Tasks Left: \(total)"
        }
        Save()
    }
    
}

